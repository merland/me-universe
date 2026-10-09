# Running physiology

My heart-rate thresholds, max HR and VO2max, with measured values kept apart from estimates. Unless noted, facts come from an AI analysis session I had in 2026 (date not recorded, after summer 2026), filed as [sources/2026-10-09-running-physiology-ai-session-summary.md](../sources/2026-10-09-running-physiology-ai-session-summary.md); "source" below means that file. Race details are on [running-races](running-races.md).

## About me as a runner

Born 1972-08-07; 54 in 2026; weight about 76 kg, essentially unchanged since 2019; height 178 cm at the 2019 lab test (2026-10-09, source). I have run minimalist or barefoot-style for about 15 years, in Merrell VaporGlove shoes with very little cushioning (2026-10-09, source). Before the spring 2026 race season my winter mileage was insufficient, so my legs and feet were probably underprepared for a half marathon (2026-10-09, source, my own assessment).

## Measured: lab test 2019-04-30

From the lab report filed as [sources/2019-04-30-loptest-lab-report.pdf](../sources/2019-04-30-loptest-lab-report.pdf); the values below are as the analysis session read them from it (2026-10-09, source). Age 46, weight 75.7 kg.

| Measure | Value |
|---|---|
| VO2max | 50.2 ml/kg/min, 3.8 L/min |
| Estimated max HR | 210 bpm (highest reached in test 206) |
| Aerobic threshold, "Aerob Tröskel (LT), FatMax" | 172 bpm at 6:00/km, 10.0 km/h |
| Anaerobic threshold, "Anaerob tröskel (AT)" | 189 bpm at 11.5 km/h (report says 5:10/km; 11.5 km/h is really about 5:13/km) |
| Report's 3-zone model | low 155–172, medium 172–189, high 189–210 bpm |

Terminology I use: LT1 is the aerobic threshold, 172 bpm in 2019; LT2 is the anaerobic threshold, 189 bpm in 2019 (2026-10-09, source). See [glossary](glossary.md).

## Estimated: current values, 2026

These are inferences from the April and May 2026 race files, not lab measurements (2026-10-09, source, estimate).

| Measure | Working estimate | Confidence |
|---|---|---|
| Max HR | about 203 bpm, plausible range 202–205 | observed lower bound: 200 bpm reached in both 2026 races |
| LT1 | about 170–172 bpm | provisional, low |
| LT2 | about 189–191 bpm, likely 190 | better constrained, by the 10K; matches 2019's 189 |
| VO2max | unknown | not established from race data; mid or high 40s is plausible but unverified |

A race-equivalence VDOT of about 36.5 from the 2026 results is not a VO2max and must not be read as one (2026-10-09, source). A fresh treadmill VO2max and lactate test would settle current VO2max, LT1, LT2 and max HR; I have not done one (2026-10-09, source).

A 5-zone watch setup was discussed but not adopted: max HR 203, zone 2 from 155, zone 3 from 171 (about LT1), zone 4 from 179, zone 5 from 189–190 (about LT2) (2026-10-09, source, proposal only). It is not set on the Suunto Run 2, which I bought in October 2026 (2026-10-10, me).

## Current working interpretation

Over a 10K I can drive HR very high while keeping pace, cadence and step length stable. Over a half marathon, pace, cadence and step length deteriorate from about 80–90 minutes while HR stays high and can still rise at the finish (2026-10-09, source). My own theory, supported by that pattern and by an overuse injury after the May 2026 half marathon, is that my current limit over long races is running durability, meaning tissue tolerance to prolonged loading, rather than the cardiovascular "engine" (2026-10-09, source, hypothesis). Heat during that race is a real confounder, and nothing in the race data diagnoses a tissue or mechanism (2026-10-09, source).

Fifteen years of minimalist running means the shoes are not simply the cause; the likelier story is reduced load tolerance from low winter mileage, with minimal cushioning leaving less margin (2026-10-09, source, hypothesis).

## Analysis conventions for future sessions

- Prefer FIT files over GPX; GPX loses laps, device speed, RR intervals, training effect and Suunto ZoneSense data (2026-10-09, source).
- With more FIT files, compare raw HR, cadence, speed, step-length proxy, lap drift, RR intervals and Suunto DDFA if present (2026-10-09, source).
- Trust Suunto ZoneSense or DDFA only when the first ten minutes were genuinely easy; a race start invalidates the baseline (2026-10-09, source).
- Keep measured and estimated values apart; do not diagnose injuries from race data (2026-10-09, source).
