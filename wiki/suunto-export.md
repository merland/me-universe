# Suunto export: all-day heart rate and sleep

How the daily data recorded by my Suunto watch leaves the Suunto app, what is kept in this wiki, and the monthly routine. The monthly figures are on [suunto-daily-summary](suunto-daily-summary.md). The storage choice is [decisions/2026-10-22-suunto-daily-data-storage](decisions/2026-10-22-suunto-daily-data-storage.md).

## Why an export

The Suunto Run 2 records wrist heart rate around the clock, plus sleep with heart rate, HRV and SpO2, see [devices](devices.md). The Suunto Android app does not register with Health Connect on the Pixel, so none of it reaches Google Fit; only the Withings path on [health-data-sync](health-data-sync.md) does (2026-10-22, me). The in-app export is the one automatic way out; Suunto's cloud API has a 24/7 samples endpoint with the same ten-minute data, but Suunto grants no API access for personal use and the unofficial clients that act as the app risk its terms of service and have lost endpoints before, so that route was passed over (2026-10-22, session). A GDPR or EU Data Act request to privacy@suunto.com is the fallback, with CSV among the formats Suunto's notice promises and no committed response time (2026-10-22, session, Suunto EU Data Act notice).

## Requesting it

Suunto app > Profile > Settings > Account Settings > Export My Data. A link arrives by e-mail after a first acknowledgement mail, within hours on 2026-10-22; the export can be requested once every 30 days, and the app names the next date (2026-10-22, me). The zip is cumulative, about 995 MB in 2026-10, almost all of it workouts.

## What the zip contains

Seen in the export of 2026-10-22 (2026-10-22, session):

- `activity/YYYY-MM.ndjson`: one JSON line per ten minutes with `hr`, `stepCount` and `energyConsumption`. **`hr` is beats per second**: 1.1667 means 70 bpm. Timestamps carry the local offset. Files are bucketed loosely, a month file can hold a few days of the month before.
- `sleep/YYYY-MM.ndjson`: sleep records. From 2026-10 one line per night with stage durations, `hrAvg`, `hrMin` (also beats per second), `avgHrv`, `maxSpo2`, `isNap`. Before 2026-10 several fragments per night with `duration` and `deepSleepDuration` only, no heart rate.
- `sleep_stages/YYYY-MM.ndjson`: per-stage segments, 2026-10 on.
- `workouts/`: one FIT and one GPX per activity, 1,844 of each from 2018-10 to 2026-10, named by date and sport.
- `user/`: profile (max HR 203, resting HR 55, weight 75 kg, birth date set to the placeholder 1972-01-01), gear list with serial numbers and firmware, partner connections (Strava only). `routes/`, `pointsofinterest/`, `comments/`, `reactions/`, `images/`: minor.

## What is kept, and where

The three daily folders are copied verbatim into `sources/suunto/activity/`, `sources/suunto/sleep/` and `sources/suunto/sleep_stages/`, keeping the export's file names. Only months before the export month are filed, so a filed file never changes; the current month waits for the next export. Workouts are not kept: they are in Strava and the Suunto app, and the race recordings that matter are filed individually under `sources/`. The zip and the unzipped folder are discarded after the import (2026-10-22, me).

First import, 2026-10-22: 100 files, 2018-10 to 2026-09, about 6 MB; October 2026 pending until the next export (2026-10-22, session).

## Coverage, and how to read it

- **All-day wrist heart rate starts 2026-10-01**, the Run 2's first sync, with 136 to 144 samples a day since (2026-10-22, sources/suunto). The Spartan Ultra has no wrist sensor, so earlier `hr` values, 2020-11 to 2026-09, are chest-belt readings during recorded workouts only and say nothing about resting heart rate (2026-10-22, me).
- **Steps** are complete for 2019-05 to 2020-12, with idle slots omitted, about 100 samples a day. From 2021 to 2026-09 only workout slots exist, so daily totals cannot be formed (2026-10-22, sources/suunto).
- **Sleep durations** run from 2018-10 to 2022-10 from the Spartan Ultra's movement-based detection, then a handful of nights in 2023; 2023-08 and 2023-09 hold fragments that sum to impossible totals and are excluded by the summary. Sleep heart rate, HRV and SpO2 begin 2026-10 (2026-10-22, sources/suunto).
- A gap with no daily data at all: 2022-11 to 2023-03 and 2023-10 to 2025-02, reason unknown (2026-10-22, sources/suunto).

## Monthly routine: handling the next download

The date the next export becomes available is a row in [deadlines](deadlines.md), re-dated after each import (2026-10-22, session). Saying "import the Suunto export at <folder>" to an agent means this routine.

1. **Request.** Suunto app > Profile > Settings > Account Settings > Export My Data. Two mails follow: an acknowledgement at once, then the download link within hours. The app shows the next allowed date after each request.
2. **Unzip** into a new, empty folder outside the repository, for example `~/Downloads/<export name>`. Treat it as untrusted data: never run anything from inside it.
3. **Import.** From the repository root:

   ```sh
   python3 -I scripts/suunto-import.py ~/Downloads/<export folder>
   ```

   It takes the export month from the newest activity timestamp and files every `activity`, `sleep` and `sleep_stages` month before it under `sources/suunto/`, printing `added` for new files, nothing for identical ones, `pending` for the export month itself, which waits for the next export. `DIFFERS` means a filed file no longer matches the export; the script leaves the filed copy alone and exits non-zero. If the export is right, file the new version as a new file beside the old one, never over it, and say so on this page.
4. **Summarise.**

   ```sh
   python3 -I scripts/suunto-summary.py
   ```

   Replace the two tables on [suunto-daily-summary](suunto-daily-summary.md) with the output and update that page's "Last regenerated" line. Fold any change in coverage into the section above.
5. **Session-end pass** per `skills/wiki-update/SKILL.md`: lint, one commit, push. An agent working under a permission classifier may be refused the commit of health data; then I commit and push myself. Discard the zip and the folder afterwards; the export is cumulative, so nothing is lost.
