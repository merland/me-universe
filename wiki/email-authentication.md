# Email authentication (SPF, DKIM, DMARC)

How outgoing mail from my Google Workspace domains is authenticated. DNS for both domains is in AWS Route 53 and mail goes out through Google Workspace. The facts below come from my own note of 2026-10-09, filed as [sources/2026-10-09-email-authentication-setup.md](../sources/2026-10-09-email-authentication-setup.md).

## Current state

| Domain | SPF | DKIM | DMARC |
|---|---|---|---|
| [megabit.se](megabit-se.md) | `v=spf1 include:_spf.google.com ~all` | selector `google`, own 2048-bit RSA key from Google Admin Console, TXT record in Route 53, signing turned on in Google Workspace | `v=DMARC1; p=quarantine; rua=mailto:dmarc@megabit.se` |
| [erlandsson.se](erlandsson-se.md) | `v=spf1 include:_spf.google.com ~all` | selector `google`, own 2048-bit RSA key from Google Admin Console, TXT record in Route 53, signing turned on in Google Workspace | `v=DMARC1; p=quarantine; rua=mailto:dmarc@erlandsson.se` |

Everything in the table was set up on 2026-10-09 (2026-10-09, me). The record values, selector and key sizes were read back from DNS with `dig` on 2026-10-19: identical answers from the authoritative Route 53 servers, Google DNS and Cloudflare DNS, so the records are fully propagated; the two DKIM public keys are different and both decode to 2048-bit RSA (2026-10-19, session). MX: megabit.se has Google's single record `1 smtp.google.com`, TTL 300, set in Route 53 on 2026-10-20 in place of the five legacy records that the Admin console flagged as Incorrect, confirmed on the authoritative server, Google DNS and Cloudflare DNS the same day, after which the Admin console shows All OK (2026-10-20, session); erlandsson.se keeps the five-record legacy form with alt1 to alt4, TTL 86400, which the Admin console accepts as All OK (2026-10-20, session). The `rua` address was added to both DMARC records in Route 53 on 2026-10-19 and confirmed the same day on the authoritative servers, Google DNS and Cloudflare DNS; each domain reports to `dmarc@` on itself, which the catch-all delivers to martin@erlandsson.se, see [decisions/2026-10-19-dmarc-aggregate-reports](decisions/2026-10-19-dmarc-aggregate-reports.md) (2026-10-19, session). The policy moved from `p=none` to `p=quarantine` on both domains on 2026-10-20, confirmed the same day on the authoritative servers, Google DNS and Cloudflare DNS, see [decisions/2026-10-20-dmarc-policy-quarantine](decisions/2026-10-20-dmarc-policy-quarantine.md) (2026-10-20, session).

## Verified

Both domains were tested with learndmarc.com, an external receiver that reports the three checks; the results are filed as screenshots under `sources/`.

| Domain | Tested | SPF | DKIM | DMARC |
|---|---|---|---|---|
| erlandsson.se | 2026-10-09 | pass, aligned | pass, aligned | pass |
| megabit.se | 2026-10-10 | pass on envelope sender erlandsson.se, so not aligned | pass, aligned | pass, by DKIM alone |

erlandsson.se: all three pass with alignment (2026-10-09, sources/2026-10-09-learndmarc-erlandsson-se.png).

megabit.se: I send as martin@megabit.se from my erlandsson.se Google Workspace account, and Google then uses erlandsson.se as the envelope sender. SPF therefore passes for erlandsson.se but does not align with the From domain megabit.se; DKIM is signed as megabit.se and aligns, which is enough for DMARC to pass (2026-10-10, sources/2026-10-10-learndmarc-megabit-se.png). Consequence: megabit.se has no SPF fallback if a DKIM signature breaks in transit, for example through a mailing list that rewrites the message. Not a problem today.

The checker also noted that neither DMARC record sets `aspf` or `adkim`, so alignment is relaxed by default (2026-10-09, sources/2026-10-09-learndmarc-erlandsson-se.png).

Kivra: a test mail from martin@erlandsson.se was accepted into the Kivra mailbox of Megabit R&D AB on 2026-10-10, shown as "Kivra Mail" with Kivra's standard banner that mail received by e-mail is from a sender not verified by Kivra (2026-10-10, sources/2026-10-10-kivra-accepts-mail.png). A second test from martin@megabit.se was accepted the same way (2026-10-10, sources/2026-10-10-kivra-accepts-mail-from-megabit-se.png). The original problem, Kivra rejecting mail from megabit.se, is solved.

## Aggregate reports

The first reports arrived on 2026-10-20, both from Google, covering 2026-10-19, filed as [sources/2026-10-19-dmarc-report-erlandsson-se-google.xml](../sources/2026-10-19-dmarc-report-erlandsson-se-google.xml) and [sources/2026-10-19-dmarc-report-megabit-se-google.xml](../sources/2026-10-19-dmarc-report-megabit-se-google.xml) (2026-10-20, me).

| Domain | Messages | Legitimate | Forged | Forging hosts |
|---|---|---|---|---|
| erlandsson.se | 145 | 1 | 144 | 22 |
| megabit.se | 89 | 0 | 89 | 14 |

The one legitimate message came from Google's server 209.85.220.69 and passed SPF and DKIM with alignment. Every forged message failed SPF with softfail and had no DKIM signature; the hosts are mostly DigitalOcean machines, a spam campaign forging the From address, not a service of mine (2026-10-20, session, sources above). Only Google's receivers report, so this is a lower bound.

## Why it was set up

An email sent from megabit.se was rejected by Kivra for missing email authentication. The investigation found that neither SPF nor DKIM was configured (2026-10-09, me).

## How it was done

For each domain, in this order: an SPF TXT record added in Route 53; a 2048-bit DKIM key generated in the Google Admin Console and its TXT record published in Route 53; DKIM signing activated in Google Workspace; a DMARC TXT record with policy `p=none` added in Route 53 (2026-10-09, me). Each domain has its own DKIM key (2026-10-09, me).

## Open items

Listed by me on 2026-10-09; status updated 2026-10-19.

- Done 2026-10-09 and 2026-10-10: verified that mail from both domains passes DMARC, see Verified above.
- Done 2026-10-10: Kivra accepts mail from both erlandsson.se and megabit.se.
- Closed 2026-10-10: the policy stays at `p=none`, see [decisions/2026-10-10-dmarc-policy-stays-none](decisions/2026-10-10-dmarc-policy-stays-none.md). Google Workspace is the only thing that sends mail as either domain (2026-10-09, me).
- Done 2026-10-19: exact SPF records of both domains read from DNS, see Current state above.
- Done 2026-10-19: `rua` added to both domains, see [decisions/2026-10-19-dmarc-aggregate-reports](decisions/2026-10-19-dmarc-aggregate-reports.md).
- Done 2026-10-20: first reports read, see Aggregate reports above; both domains are forged by spam hosts, policy raised to `p=quarantine`.
- Open: after a few more days of reports, if Google's servers remain the only passing source, move both domains to `p=reject` with `sp=reject`, see [decisions/2026-10-20-dmarc-policy-quarantine](decisions/2026-10-20-dmarc-policy-quarantine.md).
