# DMARC aggregate reports turned on, policy still p=none

Supersedes [2026-10-10-dmarc-policy-stays-none](2026-10-10-dmarc-policy-stays-none.md) on one point: a `rua` address is added. The policy itself is unchanged.

Decided: both domains publish `v=DMARC1; p=none; rua=mailto:dmarc@<domain>`, each domain reporting to an address on itself: `dmarc@megabit.se` and `dmarc@erlandsson.se`. Both addresses reach my main inbox through the Google Workspace catch-all, see [erlandsson-se](../erlandsson-se.md) and [megabit-se](../megabit-se.md). The records were changed in Route 53 on 2026-10-19.

Why: without reports I cannot see whether anything other than Google Workspace sends as my domains, or how often megabit.se mail arrives with its DKIM signature broken, which matters because that domain passes DMARC by DKIM alone. Reports cost nothing, do not affect delivery, and give the evidence needed before any later tightening of the policy.

Alternatives passed over: one shared report address for both domains, which would have needed a cross-domain authorization record at `megabit.se._report._dmarc.erlandsson.se`; a third-party aggregator instead of my own inbox, which can be added later by changing the address; `ruf` forensic reports, which almost no receiver sends; tightening to `p=quarantine` or `p=reject` now, which waits until the reports have been read.

Approved by me on 2026-10-19.
