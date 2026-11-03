status: draft 2026-11-03

# Possible plan: a script that files and summarises DMARC aggregate reports

Proposed by an agent on 2026-11-03 when I asked how to automate the DMARC review. Not decided. Exits: I approve it and it becomes a script under `scripts/` plus a sentence on [email-authentication](../wiki/email-authentication.md), or I drop it because the Postmark digests (decided the same day) turn out to be enough.

The idea: `scripts/dmarc-summary.py`, in the style of `scripts/suunto-import.py` and `scripts/suunto-summary.py`. Given a folder of downloaded report attachments (zip, gz or xml), it would unpack them, file each under `sources/` as `YYYY-MM-DD-dmarc-report-<domain>-<reporter>.xml` with the report id redacted, and print the per-report table the email page uses plus one line naming every source that passed DMARC. The download from Gmail would stay manual, once per review, like the Suunto export.

Passed over in the same discussion and recorded in [decisions/2026-11-03-dmarc-postmark-digests](../wiki/decisions/2026-11-03-dmarc-postmark-digests.md): fetching the attachments from Gmail automatically, which needs a stored OAuth token or app password and, if run by cron, a new decision over the 2026-10-22 deadline-register record.

Also waiting: the reports from Yahoo/AOL, mail.com and Socialstyrelsen received since late October are not filed under `sources/`; this script would be the way to file them.
