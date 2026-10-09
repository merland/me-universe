2026-10-09 – Email Authentication Setup (Google Workspace / AWS Route 53)

Background:
An email sent from megabit.se was rejected by Kivra due to missing
email authentication. Investigation revealed missing SPF and DKIM
configuration.

Changes made:

megabit.se:
- Added SPF TXT record authorizing Google Workspace.
- Generated a 2048-bit DKIM key in Google Admin Console.
- Published DKIM TXT record in AWS Route 53.
- Activated DKIM signing in Google Workspace.
- Added DMARC TXT record: v=DMARC1; p=none

erlandsson.se:
- Added SPF TXT record authorizing Google Workspace.
- Generated a separate 2048-bit DKIM key.
- Published DKIM TXT record in AWS Route 53.
- Activated DKIM signing in Google Workspace.
- Added DMARC TXT record: v=DMARC1; p=none

Verification:
- SPF records verified using dig.
- DKIM DNS records verified using dig.
- DMARC records verified using dig.
- DKIM activation initiated for both domains.

Remaining:
- Verify SPF, DKIM and DMARC PASS using Gmail "Show original".
- Retry sending email to Kivra.
- Optionally enable DMARC reporting (rua).
- Consider strengthening DMARC from p=none to p=reject
  after confirming all legitimate email sources authenticate.

Result:
Both domains now have SPF, DKIM and DMARC DNS records configured.
Actual outgoing email authentication remains to be verified.
