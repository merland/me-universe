# 2026-10-22: deadlines live in one page checked by a script

**Decided:** every dated obligation in the wiki (expiring licences, medicals, certificates, tokens and secrets, recurring exports, statutory filings, scheduled reviews) is a row in [deadlines](../deadlines.md) with an ISO due date and a lead time in days. `scripts/due.sh` reads the page and prints only the rows whose lead time has begun. Agents run the script right after the pull at session start and report anything but `due: nothing` in their first reply; the lint runs it again at session end and lists fired rows as `WARN deadline`. A fired row is handled by acting on it, or by re-dating it when the obligation recurs; it is never deleted to silence it. The LLM never computes dates.

**Why:** the dates were scattered over four pages with nothing to remind anyone of them. A shell script is deterministic, costs no tokens and works in any session. Since `scripts/lint.sh` is also the pre-commit hook, a fired row warns rather than fails: a failing check would block every unrelated commit for the whole lead window.

**Alternatives passed over:** calendar invites; cron jobs or scheduled agents; reminders in chat tools; letting the model compare dates itself; a failing lint check as in the design this was adapted from. Any of them can be taken up later with a new record.

Approved by me on 2026-10-22.
