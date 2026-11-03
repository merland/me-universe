# DMARC aggregate reports also go to Postmark's free weekly digest

Extends [2026-10-19-dmarc-aggregate-reports](2026-10-19-dmarc-aggregate-reports.md), which anticipated a third-party aggregator "added later by changing the address". Nothing is superseded; the policy stays as decided in [2026-10-20-dmarc-policy-quarantine](2026-10-20-dmarc-policy-quarantine.md).

Decided: both megabit.se and erlandsson.se add a Postmark DMARC digest address as a second `rua` entry, the own `dmarc@<domain>` address kept first, policy unchanged at `p=quarantine`. Postmark's free tier sends one email per domain every Monday with the top ten sending sources and whether they pass; no account, dashboard or stored credential. Each domain was signed up separately at dmarc.postmarkapp.com with martin@erlandsson.se as contact.

Why: by 2026-11-03 five receivers (Google, Outlook.com, Yahoo/AOL, mail.com, Socialstyrelsen) send about ten reports a day, and reading the XML by hand no longer scales. The only recurring question is whether a legitimate source failed, which the weekly digest answers. The raw reports keep arriving at the own address, so the evidence trail under `sources/` is unchanged.

Alternatives passed over: Valimail Monitor, also free and with a dashboard, but an account with an enforcement vendor and a reported 24-hour delay; dmarcian, whose free tier is for non-business use while megabit.se is a company domain; Cloudflare DMARC Management, which needs Cloudflare DNS while mine is in Route 53; a script fetching the reports from Gmail, which would store an OAuth token or app password and, if run by cron, contradict [2026-10-22-deadline-register](2026-10-22-deadline-register.md); replacing the own `rua` address rather than adding, which would stop the raw files.

Records changed in Route 53 by the agent with the AWS CLI and confirmed on all four authoritative servers of each zone, Google DNS and Cloudflare DNS on 2026-11-03. Postmark's API tokens were pasted into the session, not recorded; they belong in the password manager.

Approved by me on 2026-11-03.
