# Email authentication (SPF, DKIM, DMARC)

How outgoing mail from my Google Workspace domains is authenticated. DNS for both domains is in AWS Route 53 and mail goes out through Google Workspace. The facts below come from my own note of 2026-10-09, filed as [sources/2026-10-09-email-authentication-setup.md](../sources/2026-10-09-email-authentication-setup.md).

## Current state

| Domain | SPF | DKIM | DMARC |
|---|---|---|---|
| [megabit.se](megabit-se.md) | TXT record authorizing Google Workspace | own 2048-bit key from Google Admin Console, TXT record in Route 53, signing turned on in Google Workspace | `v=DMARC1; p=none` |
| [erlandsson.se](erlandsson-se.md) | TXT record authorizing Google Workspace | own 2048-bit key from Google Admin Console, TXT record in Route 53, signing turned on in Google Workspace | `v=DMARC1; p=none` |

Everything in the table was set up on 2026-10-09 (2026-10-09, me). The exact SPF record values and the DKIM selector names are unknown; I did not record them (2026-10-09, me).

The SPF, DKIM and DMARC DNS records of both domains were checked with `dig` and are published (2026-10-09, me). The DKIM selector for both domains is `google` (2026-10-09, sources/2026-10-09-learndmarc-erlandsson-se.png; 2026-10-10, sources/2026-10-10-learndmarc-megabit-se.png). The SPF record of erlandsson.se contains `include:_spf.google.com`; megabit.se's SPF record was not exercised by the test below and its exact value is still unknown (2026-10-09, me).

## Verified

Both domains were tested with learndmarc.com, an external receiver that reports the three checks; the results are filed as screenshots under `sources/`.

| Domain | Tested | SPF | DKIM | DMARC |
|---|---|---|---|---|
| erlandsson.se | 2026-10-09 | pass, aligned | pass, aligned | pass |
| megabit.se | 2026-10-10 | pass on envelope sender erlandsson.se, so not aligned | pass, aligned | pass, by DKIM alone |

erlandsson.se: all three pass with alignment (2026-10-09, sources/2026-10-09-learndmarc-erlandsson-se.png).

megabit.se: I send as martin@megabit.se from my erlandsson.se Google Workspace account, and Google then uses erlandsson.se as the envelope sender. SPF therefore passes for erlandsson.se but does not align with the From domain megabit.se; DKIM is signed as megabit.se and aligns, which is enough for DMARC to pass (2026-10-10, sources/2026-10-10-learndmarc-megabit-se.png). Consequence: megabit.se has no SPF fallback if a DKIM signature breaks in transit, for example through a mailing list that rewrites the message. Not a problem today.

The checker also noted that neither DMARC record sets `aspf` or `adkim`, so alignment is relaxed by default (2026-10-09, sources/2026-10-09-learndmarc-erlandsson-se.png).

Kivra: a test mail from martin@erlandsson.se was accepted into the Kivra mailbox of Megabit R&D AB on 2026-10-10, shown as "Kivra Mail" with Kivra's standard banner that mail received by e-mail is from a sender not verified by Kivra (2026-10-10, sources/2026-10-10-kivra-accepts-mail.png). The original rejection was of mail from megabit.se; that exact case has not been retried (2026-10-10, me).

## Why it was set up

An email sent from megabit.se was rejected by Kivra for missing email authentication. The investigation found that neither SPF nor DKIM was configured (2026-10-09, me).

## How it was done

For each domain, in this order: an SPF TXT record added in Route 53; a 2048-bit DKIM key generated in the Google Admin Console and its TXT record published in Route 53; DKIM signing activated in Google Workspace; a DMARC TXT record with policy `p=none` added in Route 53 (2026-10-09, me). Each domain has its own DKIM key (2026-10-09, me).

## Open items

Listed by me on 2026-10-09; status updated 2026-10-10.

- Done 2026-10-09 and 2026-10-10: verified that mail from both domains passes DMARC, see Verified above.
- Partly done 2026-10-10: Kivra accepts mail from erlandsson.se. Sending to Kivra from megabit.se, the case that failed originally, is still untested.
- Optionally turn on DMARC aggregate reporting (`rua`).
- Consider moving DMARC from `p=none` to `p=reject` now that sending is confirmed to authenticate. Google Workspace is the only thing that sends mail as either domain (2026-10-09, me). For megabit.se this relies on DKIM alone, see Verified.
- Record the exact SPF record value of megabit.se.
