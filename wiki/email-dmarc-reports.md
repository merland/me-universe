# DMARC reports

What receivers report about mail that claims to come from [megabit.se](megabit-se.md) or [erlandsson.se](erlandsson-se.md): who passes, who forges, and how the evidence is filed. The records that ask for the reports are on [email-authentication](email-authentication.md). Split from that page on 2026-11-16 when it outgrew the page budget (2026-11-16, session).

## How reports arrive and are filed

Each DMARC record names two `rua` addresses. Raw XML reports go to `dmarc@` on the domain itself, about ten a day from Google, Outlook.com, Yahoo/AOL, mail.com and Socialstyrelsen (2026-11-03, me). They are filed under `sources/` as `YYYY-MM-DD-dmarc-report-<domain>-<reporter>.xml`, named for the day covered, report id redacted because it trips the lint; four are filed, three from Google and one from Outlook.com, and nothing after 2026-10-20 (2026-11-16, session).

Postmark receives the same reports and emails one digest per domain every Monday; the first pair arrived on 2026-11-09 at 15:30 UTC (2026-11-16, me, sources below). A digest is filed as `YYYY-MM-DD-postmark-dmarc-digest-<domain>.txt`, named for the day it was sent, as a text rendering of the email and never the email itself: its unsubscribe link carries a private token (2026-11-16, session).

## Postmark weekly digests

| Sent | Domain | Period | Messages | From Google | Google SPF aligned | Google DKIM aligned | Other sources aligned | Listed in digest | Source |
|---|---|---|---|---|---|---|---|---|---|
| 2026-11-09 | erlandsson.se | 1–8 Nov | 353 | 8, from 6 addresses | 100% | 100% | 0% | 306; 12 domains, 47 messages unlisted | [digest](../sources/2026-11-09-postmark-dmarc-digest-erlandsson-se.txt) |
| 2026-11-09 | megabit.se | 2–9 Nov | 179 | 3, from 3 addresses | 0% | 100% | 0% | all 179 | [digest](../sources/2026-11-09-postmark-dmarc-digest-megabit-se.txt) |
| 2026-11-16 | erlandsson.se | 8–15 Nov | 1,415 | 19, from 6 addresses | 18 of 19 | 100% | 0% | 1,148; 31 domains, 267 messages unlisted | [digest](../sources/2026-11-16-postmark-dmarc-digest-erlandsson-se.txt) |
| 2026-11-16 | megabit.se | 9–16 Nov | 564 | 3, from 3 addresses | 0% | 100% | 0% | 461; 19 domains, 103 messages unlisted | [digest](../sources/2026-11-16-postmark-dmarc-digest-megabit-se.txt) |

Google is the only source that passes DMARC on either domain in both digest pairs; every other listed source fails both SPF and DKIM alignment (2026-11-16, session, sources above). Google's megabit.se mail passes by DKIM alone, the known envelope-sender situation described under Verified on [email-authentication](email-authentication.md); Postmark flags it and suggests a custom Return-Path, which is not something I have set up (2026-11-16, session). One of the five erlandsson.se messages from Google's 209.85.220.69 in the second week failed SPF alignment and passed by DKIM; the cause is unknown, possibly a message forwarded by its recipient (2026-11-16, session, unconfirmed).

The free digest lists the largest sources only and leaves the rest to Postmark's API. The headline share of aligned mail, 2% in the first week and 1% in the second, matches Google's messages alone, and rounding leaves room for at most a handful of aligned messages among the unlisted ones; aligned mail passes under any policy (2026-11-16, session, unconfirmed). What a digest cannot show is whether any unlisted failing source is a legitimate one.

Volume rose from 353 to 1,415 messages on erlandsson.se and from 179 to 564 on megabit.se. Postmark's address was added on 2026-11-03, so the first week was a partial one; how much of the rise is more forging is unknown (2026-11-16, session).

The failing sources are rented servers, as in October: addresses that Postmark could not resolve, many of them DigitalOcean, plus Cloudways, OVH, Vultr, Hetzner, Timeweb and smaller hosts; 78 unresolved addresses on erlandsson.se and 41 on megabit.se in the second week (2026-11-16, session, sources above). Two addresses recur across weeks and domains, both failing: 35.233.178.112, a Google Cloud virtual machine and not Google Workspace, and 86.107.98.104 at netsons.net (2026-11-16, session). In the first week 83.209.73.65, a Bredband2 customer line in Sweden (`h83-209-73-65.cust.bredband2.com`), sent 8 messages as megabit.se, all failing; I do not recognise it, so it counts as a forger, and it is absent from the second week (2026-11-16, me).

## Raw reports filed

| Day covered | Domain | Reporter | Messages | Legitimate | Forged | Forging hosts | Source |
|---|---|---|---|---|---|---|---|
| 2026-10-19 | erlandsson.se | Google | 145 | 1 | 144 | 22 | [2026-10-19 Google](../sources/2026-10-19-dmarc-report-erlandsson-se-google.xml) |
| 2026-10-19 | megabit.se | Google | 89 | 0 | 89 | 14 | [2026-10-19 Google](../sources/2026-10-19-dmarc-report-megabit-se-google.xml) |
| 2026-10-19 | megabit.se | Outlook.com | 1 | 0 | 1 | 1 | [2026-10-19 Outlook](../sources/2026-10-19-dmarc-report-megabit-se-outlook.xml) |
| 2026-10-20 | erlandsson.se | Google | 38 | 0 | 38 | 5 | [2026-10-20 Google](../sources/2026-10-20-dmarc-report-erlandsson-se-google.xml) |

The only legitimate message in these four came from Google's server 209.85.220.69 on 2026-10-19 and passed SPF and DKIM with alignment (2026-10-20, session, sources above). Every forged message failed SPF with softfail and had no DKIM signature; the hosts are mostly DigitalOcean machines, a spam campaign forging the From address, not a service of mine (2026-10-21, session, sources above). The Outlook.com message went to a hotmail.com address with megabit.se as envelope and header From (2026-10-21, sources/2026-10-19-dmarc-report-megabit-se-outlook.xml). Google's report for 2026-10-20 still lists `p=none` with disposition none on every row although the record changed to `p=quarantine` that day, so that mail was evaluated against the old record, probably cached or received before the change (2026-10-21, session, unconfirmed). No filed report shows a quarantine disposition, and the digests do not show dispositions at all (2026-11-16, session).
