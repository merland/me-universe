# megabit.se

A domain I manage. It is registered with AWS Route 53, and its DNS is hosted there too (2026-10-09, me). Email for the domain is handled by Google Workspace (2026-10-09, me). A catch-all, configured in Google Workspace routing, delivers mail to every address on the domain to my main Google Workspace account, martin@erlandsson.se, described on [erlandsson-se](erlandsson-se.md) (2026-10-09, me).

The domain is mainly for email. It also has a placeholder website that contains only a simple contact form (2026-10-09, me). Where that website is hosted is unknown.

Outgoing mail is authenticated with SPF, DKIM and DMARC at policy `p=none`, with end-to-end verification still open; details are on [email-authentication](email-authentication.md) (2026-10-09, me).
