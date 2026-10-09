# Email authentication (SPF, DKIM, DMARC)

How outgoing mail from my Google Workspace domains is authenticated. DNS for both domains is in AWS Route 53 and mail goes out through Google Workspace. The facts below come from my own note of 2026-10-09, filed as [sources/2026-10-09-email-authentication-setup.md](../sources/2026-10-09-email-authentication-setup.md).

## Current state

| Domain | SPF | DKIM | DMARC |
|---|---|---|---|
| [megabit.se](megabit-se.md) | TXT record authorizing Google Workspace | own 2048-bit key from Google Admin Console, TXT record in Route 53, signing turned on in Google Workspace | `v=DMARC1; p=none` |
| [erlandsson.se](erlandsson-se.md) | TXT record authorizing Google Workspace | own 2048-bit key from Google Admin Console, TXT record in Route 53, signing turned on in Google Workspace | `v=DMARC1; p=none` |

Everything in the table was set up on 2026-10-09 (2026-10-09, me). The exact SPF record values and the DKIM selector names are unknown; I did not record them (2026-10-09, me).

The SPF, DKIM and DMARC DNS records of both domains were checked with `dig` and are published (2026-10-09, me). DKIM signing was activated in Google Workspace the same day, but whether mail sent from either domain actually passes SPF, DKIM and DMARC has not been verified yet (2026-10-09, me).

## Why it was set up

An email sent from megabit.se was rejected by Kivra for missing email authentication. The investigation found that neither SPF nor DKIM was configured (2026-10-09, me).

## How it was done

For each domain, in this order: an SPF TXT record added in Route 53; a 2048-bit DKIM key generated in the Google Admin Console and its TXT record published in Route 53; DKIM signing activated in Google Workspace; a DMARC TXT record with policy `p=none` added in Route 53 (2026-10-09, me). Each domain has its own DKIM key (2026-10-09, me).

## Open items

Listed by me on 2026-10-09; none is done yet.

- Verify that mail from both domains passes SPF, DKIM and DMARC, using Gmail's "Show original" on a received message.
- Retry sending to Kivra from megabit.se.
- Optionally turn on DMARC aggregate reporting (`rua`).
- Consider moving DMARC from `p=none` to `p=reject` once every legitimate sending source is confirmed to authenticate. Which sending sources exist besides Google Workspace is unknown (2026-10-09, me).
