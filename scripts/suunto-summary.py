#!/usr/bin/env python3
"""Monthly summary of the Suunto daily data filed under sources/suunto/.

Usage: python3 -I scripts/suunto-summary.py

Prints a Markdown table, one row per month, grouped by each line's own
timestamp (export files are bucketed loosely). Heart rates in the export are
beats per second and are converted to bpm. Columns without data print "–".
"""
import json
import statistics
from datetime import datetime, timedelta
from collections import defaultdict
from pathlib import Path

repo = Path(__file__).resolve().parent.parent
root = repo / "sources" / "suunto"


def lines(folder):
    for f in sorted((root / folder).glob("*.ndjson")):
        for line in f.open():
            line = line.strip()
            if line:
                yield json.loads(line)


def bpm(hz):
    return hz * 60


# activity: per day, lowest 10-minute HR, sample count, steps
day_min_hr = {}
day_hr_samples = defaultdict(int)
day_steps = defaultdict(int)
day_samples = defaultdict(int)
for d in lines("activity"):
    day = d["timestamp"][:10]
    e = d["entryData"]
    day_samples[day] += 1
    day_steps[day] += e.get("stepCount", 0)
    if "hr" in e:
        day_hr_samples[day] += 1
        day_min_hr[day] = min(day_min_hr.get(day, 999), bpm(e["hr"]))

# sleep: the export holds several fragments per night in the Spartan era and one
# line per night from the Run 2 on; a night is keyed by the date 12 hours before
# the fragment's start, so 22:40 and the next day's 00:25 land on the same night.
night_secs = defaultdict(lambda: defaultdict(float))
night_fields = defaultdict(list)
for d in lines("sleep"):
    e = d["entryData"]
    if e.get("isNap"):
        continue
    ts = d["timestamp"]
    night = (datetime.fromisoformat(ts) - timedelta(hours=12)).strftime("%Y-%m-%d")
    for k in ("duration", "deepSleepDuration"):
        if k in e:
            night_secs[night][k] += e[k]
    night_fields[night].append(e)

months = sorted(set(m[:7] for m in day_steps) | set(n[:7] for n in night_secs))


def mean(xs, fmt):
    return fmt % statistics.mean(xs) if xs else "–"


def hours(secs):
    return secs / 3600


MAX_NIGHT_H = 16  # fragments summing beyond this are export artefacts (seen for 2023-08/09)

print("## Sleep and steps\n")
print("| Month | Nights | Sleep h | Deep h | Steps/day |")
print("|---|---|---|---|---|")
hr_rows = []
for m in months:
    ns = [n for n in night_secs if n.startswith(m)
          and "duration" in night_secs[n] and hours(night_secs[n]["duration"]) <= MAX_NIGHT_H]
    sleep_h = [hours(night_secs[n]["duration"]) for n in ns]
    deep_h = [hours(night_secs[n]["deepSleepDuration"]) for n in ns if "deepSleepDuration" in night_secs[n]]
    days = [d for d in day_steps if d.startswith(m)]
    # steps count only on days the watch sampled most of the day (>= 80 of 144 slots);
    # the Spartan era omitted idle slots, and 2023-2026-09 holds workout slots only
    steps = [day_steps[d] for d in days if day_samples[d] >= 80]
    if ns or steps:
        print("| %s | %s | %s | %s | %s |" % (
            m, len(ns) or "–", mean(sleep_h, "%.1f"), mean(deep_h, "%.1f"), mean(steps, "%.0f")))
    # heart rate: only days with near-full wrist coverage (>= 120 of 144 samples)
    full = [d for d in days if day_hr_samples.get(d, 0) >= 120]
    rest = [day_min_hr[d] for d in full]
    es = [e for n in ns for e in night_fields[n]]
    s_avg = [bpm(e["hrAvg"]) for e in es if "hrAvg" in e]
    s_min = [bpm(e["hrMin"]) for e in es if "hrMin" in e]
    hrv = [e["avgHrv"] for e in es if "avgHrv" in e]
    if full or s_avg:
        hr_rows.append("| %s | %s | %s | %s | %s | %s |" % (
            m, len(full) or "–", ("%.0f" % statistics.median(rest)) if rest else "–",
            mean(s_avg, "%.0f"), mean(s_min, "%.0f"), mean(hrv, "%.0f")))

print("\n## Heart rate, wrist, Run 2 era\n")
print("| Month | HR days | Rest HR | Sleep HR avg | Sleep HR min | HRV |")
print("|---|---|---|---|---|---|")
print("\n".join(hr_rows) if hr_rows else "| – | – | – | – | – | – |")
