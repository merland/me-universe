# DMARC policy moves to p=quarantine

Decided: both megabit.se and erlandsson.se change from `p=none` to `p=quarantine`, keeping the `rua` address of each. Supersedes [2026-10-10-dmarc-policy-stays-none](2026-10-10-dmarc-policy-stays-none.md) on the policy point.

Why: the first aggregate reports, for 2026-10-19 from Google alone, show 144 forged messages from 22 hosts using erlandsson.se and 89 from 14 hosts using megabit.se, against one legitimate message, see [email-authentication](../email-authentication.md). The earlier record assumed forged mail was not a problem; it is. Legitimate mail is unaffected because the only real sender, Google Workspace, passes DKIM with alignment on both domains.

Alternatives passed over: staying at `p=none`; going straight to `p=reject`. Reject with `sp=reject` is the intended next step once a few more days of reports confirm Google's servers are the only passing source.

Records changed in Route 53 and confirmed on the authoritative servers, Google DNS and Cloudflare DNS on 2026-10-20.

Approved by me on 2026-10-20.
