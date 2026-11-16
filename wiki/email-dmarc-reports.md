# DMARC reports

What receivers report about mail that claims to come from [megabit.se](megabit-se.md) or [erlandsson.se](erlandsson-se.md): who passes, who forges, and how the evidence is filed. The records that ask for the reports are on [email-authentication](email-authentication.md). Split from that page on 2026-11-16 when it outgrew the page budget (2026-11-16, session).

## How reports arrive and are filed

Each DMARC record names two `rua` addresses. Raw XML reports go to `dmarc@` on the domain itself, about ten a day from Google, Outlook.com, Yahoo/AOL, mail.com and Socialstyrelsen (2026-11-03, me). They are filed under `sources/` as `YYYY-MM-DD-dmarc-report-<domain>-<reporter>.xml`, named for the day covered, report id redacted because it trips the lint; four are filed, three from Google and one from Outlook.com, and nothing after 2026-10-20 (2026-11-16, session).

Postmark receives the same reports and emails one digest per domain every Monday; the first pair arrived on 2026-11-09 at 15:30 UTC (2026-11-16, me, sources below). A digest is filed as `YYYY-MM-DD-postmark-dmarc-digest-<domain>.txt`, named for the day it was sent, as a text rendering of the email and never the email itself: its unsubscribe link carries a private token (2026-11-16, session).

## Postmark weekly digests

| Sent | Domain | Period | Messages | From Google | Google SPF aligned | Google DKIM aligned | Other sources aligned | Source |
|---|---|---|---|---|---|---|---|---|
| 2026-11-09 | erlandsson.se | 1–8 Nov | 353 | 8, from 6 addresses | 100% | 100% | 0% | [digest](../sources/2026-11-09-postmark-dmarc-digest-erlandsson-se.txt) |
| 2026-11-09 | megabit.se | 2–9 Nov | 179 | 3, from 3 addresses | 0% | 100% | 0% | [digest](../sources/2026-11-09-postmark-dmarc-digest-megabit-se.txt) |

Google is the only source that passes DMARC on either domain in the first digests; every other listed source fails both SPF and DKIM alignment (2026-11-16, session, sources above). Google's megabit.se mail passes by DKIM alone, the known envelope-sender situation described under Verified on [email-authentication](email-authentication.md); Postmark flags it and suggests a custom Return-Path, which is not something I have set up (2026-11-16, session).

The megabit.se digest is complete: its rows sum to 179. The erlandsson.se digest lists 306 of 353 messages and leaves 12 further domains, 47 messages, to Postmark's API. Its headline of 2% aligned equals Google's 8 messages, so the unlisted 47 very probably all fail (2026-11-16, session, unconfirmed).

The failing sources are rented servers, as in October: DigitalOcean addresses that Postmark could not resolve, Vultr, OVH, Hetzner, DreamHost and smaller hosts, 34 unresolved addresses plus nine named hosts on erlandsson.se and 19 plus nine on megabit.se (2026-11-16, session, sources above). One is different in kind: 83.209.73.65, a Bredband2 customer line in Sweden (`h83-209-73-65.cust.bredband2.com`), sent 8 messages as megabit.se, all failing. Whether that line is mine or someone I know is unknown; it was not the connection my Mac was on when checked (2026-11-16, session).

The digests of 2026-11-16 are not yet filed (2026-11-16, session).

## Raw reports filed

| Day covered | Domain | Reporter | Messages | Legitimate | Forged | Forging hosts | Source |
|---|---|---|---|---|---|---|---|
| 2026-10-19 | erlandsson.se | Google | 145 | 1 | 144 | 22 | [2026-10-19 Google](../sources/2026-10-19-dmarc-report-erlandsson-se-google.xml) |
| 2026-10-19 | megabit.se | Google | 89 | 0 | 89 | 14 | [2026-10-19 Google](../sources/2026-10-19-dmarc-report-megabit-se-google.xml) |
| 2026-10-19 | megabit.se | Outlook.com | 1 | 0 | 1 | 1 | [2026-10-19 Outlook](../sources/2026-10-19-dmarc-report-megabit-se-outlook.xml) |
| 2026-10-20 | erlandsson.se | Google | 38 | 0 | 38 | 5 | [2026-10-20 Google](../sources/2026-10-20-dmarc-report-erlandsson-se-google.xml) |

The only legitimate message in these four came from Google's server 209.85.220.69 on 2026-10-19 and passed SPF and DKIM with alignment (2026-10-20, session, sources above). Every forged message failed SPF with softfail and had no DKIM signature; the hosts are mostly DigitalOcean machines, a spam campaign forging the From address, not a service of mine (2026-10-21, session, sources above). The Outlook.com message went to a hotmail.com address with megabit.se as envelope and header From (2026-10-21, sources/2026-10-19-dmarc-report-megabit-se-outlook.xml). Google's report for 2026-10-20 still lists `p=none` with disposition none on every row although the record changed to `p=quarantine` that day, so that mail was evaluated against the old record, probably cached or received before the change (2026-10-21, session, unconfirmed). No filed report shows a quarantine disposition, and the digests do not show dispositions at all (2026-11-16, session).
