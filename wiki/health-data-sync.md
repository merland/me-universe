# Health data sync: Withings to Google Fit

How measurements from my Withings devices reach Google Fit on the Pixel, and the state of that link.

## Devices and direction

I own a Withings scale and a Withings blood-pressure monitor (BPM); models unknown (2026-10-19, me). The only direction I want is Withings into Google Fit: weight, body composition, heart rate and blood pressure. Nothing needs to flow from Google Fit back into Withings (2026-10-19, me). Steps and workouts do not apply: neither device records them, and runs go from the Suunto watch to Strava instead, see [devices](devices.md).

## How the link works

The Withings app has not been able to link to Google Fit directly on Android since 2024-05-06, when Google retired the Google Fit API in favour of Health Connect (2026-10-19, session, Withings support page). The path is therefore Withings app → Health Connect → Google Fit. Health Connect is a store on the phone; each app needs its own per-data-type permission in it, Withings to write and Google Fit to read (2026-10-19, session).

On the [Google Pixel 11 Pro XL](devices.md) running Android 16, Health Connect appears as Settings > Health. The per-app toggles are under App permissions > Health, fitness and wellness > Fitness and Wellness, with a Vitals section for heart rate and blood pressure (2026-10-19, me).

Withings side: the Withings app, avatar at top left > Settings > "Export health data to Health Connect". It reports "You're already connected" and has its own per-type toggles, all on (2026-10-19, me).

Google Fit side: profile picture > Settings > "Sync Fit with Health Connect", on; Google Fit holds the "Health, fitness and wellness" permission group in Settings > Apps > Fit > Permissions (2026-10-19, me).

## The 2026-10-19 fix

Nothing was arriving in Google Fit. Both apps were registered with Health Connect, but every data-type permission for both was off. Neither app asked again, because each already considered itself connected. The fix was to switch on the types per app under Settings > Health > Fitness and Wellness: write for Withings, read for Google Fit, on weight, body fat and the other composition fields, heart rate, blood pressure, steps and exercise (2026-10-19, me).

Verified: a manual weight entry added in the Withings app appeared in Google Fit > Browse > Weight after force-stopping and reopening Google Fit (2026-10-19, me).

Unverified: blood pressure and heart rate from the BPM; it was not used on the day of the fix (2026-10-19, me). A Withings community post from 2026-09 reports BPM Core blood pressure not reaching Google Fit even though Health Connect holds it, so this path may still fail (2026-10-19, session, unconfirmed). Next BPM reading: check Google Fit > Browse > Vitals > Blood pressure and fold the result in here.

Readings taken before the permissions were granted have not appeared in Google Fit; the export seems to cover new data only (2026-10-19, session, unconfirmed as a rule).

While searching Settings for a data browser I switched on "Permit access to apps usage data"; it is unrelated to health data and can go back off (2026-10-19, me). The Health Connect data browser was not found on this Android 16 build (2026-10-19, me).

## Context, unconfirmed

Google Fit is a legacy app; its APIs are being retired and Health Connect is the replacement (2026-10-19, session, third-party reports). One article dated 2026-10 claims Withings now gates automatic Health Connect and Apple Health sync behind a paid Withings+ plan for accounts created after 2026-10-13, with earlier accounts keeping free sync; single source, not checked against Withings (2026-10-19, session, unconfirmed). My account predates that date, so it would not apply (2026-10-19, session, inference).

See also [services](services.md) and [running/physiology](running/physiology.md) for heart-rate context.
