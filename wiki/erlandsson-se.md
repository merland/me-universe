# erlandsson.se

A domain I manage. It is registered with AWS Route 53, and its DNS is hosted there too (2026-10-09, me). Email for the domain is handled by Google Workspace (2026-10-09, me). My main Google Workspace account is martin@erlandsson.se (2026-10-09, me). A catch-all, configured in Google Workspace routing, delivers mail to every other address on the domain to that account; mail to any address on [megabit-se](megabit-se.md) is delivered there as well (2026-10-09, me).

The domain is mainly for email. It also has a placeholder website that contains only a simple contact form (2026-10-09, me). The site is hosted on AWS Lightsail as a simple container deployed by AWS; form submissions end up in my "My forms" base in Airtable, see [services](services.md) (2026-10-10, me).

My old Gmail address, marterland@gmail.com, still exists and receives mail, but everything is forwarded to martin@erlandsson.se, so I never read the Gmail inbox itself (2026-10-10, me).

Outgoing mail is authenticated with SPF, DKIM and DMARC at policy `p=none`, verified end to end on 2026-10-09 and accepted by Kivra; details are on [email-authentication](email-authentication.md) (2026-10-10, me).
