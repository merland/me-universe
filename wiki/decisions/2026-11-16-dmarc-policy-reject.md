# DMARC policy moves to p=reject

Decided: both megabit.se and erlandsson.se change from `p=quarantine` to `p=reject` with `sp=reject`, keeping both `rua` addresses of each. Supersedes [2026-10-20-dmarc-policy-quarantine](2026-10-20-dmarc-policy-quarantine.md) on the policy point; it is the next step that record intended. The reporting set up in [2026-10-19-dmarc-aggregate-reports](2026-10-19-dmarc-aggregate-reports.md) and [2026-11-03-dmarc-postmark-digests](2026-11-03-dmarc-postmark-digests.md) is unchanged.

Why: the review scheduled for 2026-11-17 asked whether Google's servers were still the only passing source in the Postmark digests of 2026-11-09 and 2026-11-16. They were, on both domains, in both weeks: 8 of 353 and 19 of 1,415 messages for erlandsson.se, 3 of 179 and 3 of 564 for megabit.se, every Google message DKIM aligned and every other listed source failing both SPF and DKIM alignment, see [email-dmarc-reports](../email-dmarc-reports.md). Google Workspace is the only thing that sends mail as either domain, so reject changes only what happens to forged mail, which was already being quarantined. The one source that did not look like a rented server, a Bredband2 customer line in Sweden sending as megabit.se, is not one I recognise.

Known and accepted: the free digests list only the largest sources and left 47 and 267 erlandsson.se messages and 103 megabit.se messages in unlisted domains, so the evidence is the listed sources plus headline percentages that match Google's messages alone. megabit.se passes by DKIM alone, so a message whose signature breaks in transit, in a mailing list for example, is now rejected rather than quarantined.

Alternatives passed over: staying at `p=quarantine`; fetching the unlisted sources through Postmark's API before deciding.

Records changed in Route 53 by the agent with the AWS CLI, TTL 300 kept, and confirmed on all four authoritative servers of each zone, Google DNS and Cloudflare DNS on 2026-11-16.

Approved by me on 2026-11-16.
