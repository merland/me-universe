# Deadlines

The register of every dated obligation in this wiki: licences and medicals that expire, recurring exports to fetch, statutory filings, scheduled reviews, and any token or secret with an expiry, should one ever be held. `scripts/due.sh` reads this page and prints only the rows whose lead time has begun; nobody, human or agent, reads the page unless the script says something is due. Agents run the script right after the pull at session start and the lint runs it again at session end, listing fired rows as `WARN deadline`. A printed row is a finding to act on or to leave standing for me, never to silence. By design there are no calendar invites, cron jobs, scheduled agents or chat reminders, and the LLM never does the date arithmetic; the script is the only reminder mechanism (decided by me on 2026-10-22, see [decisions/2026-10-22-deadline-register](decisions/2026-10-22-deadline-register.md)).

Created 2026-10-22 from dates that were scattered over [flying](flying.md), [suunto-export](suunto-export.md), [email-authentication](email-authentication.md) and [megabit-rd-ab](megabit-rd-ab.md) (2026-10-22, session).

## Format

The script depends on this. One row per obligation. `Due` is an ISO date, `YYYY-MM-DD`. `Lead days` is an integer. The row fires from `Due − Lead` until it is handled. Handled means the row is **removed**, or **re-dated** when the obligation recurs: an imported export gets the next window, a renewed medical its new expiry, a rotated token its new expiry. The *why* and the procedure stay on the pointer page; only the date, the lead and one sentence live here.

Every `What must happen` cell starts with a bracketed kind tag, so a fired row says what sort of work it is. Allowed kinds; a new kind is added to this list before it is used in a row:

- `[Renew]` a licence, medical, certificate, domain or subscription with an expiry.
- `[Import]` a recurring data export to request, fetch and file under `sources/`.
- `[File]` a statutory submission for the company.
- `[Review]` a decision or check scheduled for a date.

`DUE_HORIZON=90 scripts/due.sh` lists everything within 90 days, for a human glance.

## Register

| Due | Lead days | What must happen | Pointer |
|---|---|---|---|
| 2026-10-27 | 0 | [Review] Move both domains to DMARC p=reject with sp=reject if Google's servers are still the only passing source in the aggregate reports; I decide, then a decision record is written and the email page updated | [email-authentication](email-authentication.md) |
| 2026-11-21 | 0 | [Import] Request the Suunto "Export My Data" zip and run the import routine; then re-date this row to 30 days after the export | [suunto-export](suunto-export.md) |
| 2027-07-31 | 60 | [File] File the 2026 årsredovisning for Megabit R&D AB with Bolagsverket; I do it, then re-date this row to the next year | [megabit-rd-ab](megabit-rd-ab.md) |
| 2027-08-22 | 60 | [Renew] Book and pass the Class 2 aeromedical exam before the medical expires; I do it, then update the expiry on the flying page and re-date this row | [flying](flying.md) |
