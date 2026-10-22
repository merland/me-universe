# Suunto daily data is stored raw under sources/suunto, completed months only

**Decided:** the all-day heart rate, sleep and sleep-stage data from the Suunto app's "Export My Data" zip is filed in the wiki as the export's own NDJSON files, unmodified, under `sources/suunto/activity/`, `sources/suunto/sleep/` and `sources/suunto/sleep_stages/`, keeping the export's file names. Only months strictly before the export month are filed, so a filed file never changes. The export is requested about monthly; `scripts/suunto-import.py` does the filing and `scripts/suunto-summary.py` prints the monthly table shown on [suunto-export](../suunto-export.md). Everything the export has is backfilled, including the Spartan Ultra sleep durations from 2018 and step counts from 2019. Workouts, routes, images and the zip itself are not kept.

**Why:** the Suunto Android app does not write to Health Connect, so the export is the only automatic way out, and the Suunto app is not durable storage. `sources/` is append-only, so a month still being written cannot be filed; waiting for the next export costs nothing because every export is cumulative. Raw NDJSON is the richest format and the evidence itself; a converted copy would be a second home for the same facts. Workouts are visible in Strava and the Suunto app and would add about a gigabyte per export; the race recordings that matter are already filed individually.

**Alternatives passed over:** starting the backfill at 2026-10, when the Run 2 data begins; converting to CSV or SQLite; filing each whole zip by export date; a Data Act request to Suunto, kept as fallback only.

Approved by me on 2026-10-22.
