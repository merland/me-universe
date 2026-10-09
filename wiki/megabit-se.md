# megabit.se

The domain of my company [megabit-rd-ab](megabit-rd-ab.md) (2026-10-10, me). It is registered with AWS Route 53, and its DNS is hosted there too (2026-10-09, me). Email for the domain is handled by Google Workspace (2026-10-09, me). A catch-all, configured in Google Workspace routing, delivers mail to every address on the domain to my main Google Workspace account, martin@erlandsson.se, described on [erlandsson-se](erlandsson-se.md) (2026-10-09, me).

The domain is mainly for email. It also has a placeholder website that contains only a simple contact form (2026-10-09, me). The site is hosted on AWS Lightsail as a simple container deployed by AWS; form submissions end up in my "My forms" base in Airtable, see [services](services.md) (2026-10-10, me).

martin@megabit.se is a send-as identity of the erlandsson.se account, not a separate Google Workspace user (2026-10-10, journal/2026-10-10).

Outgoing mail is authenticated with SPF, DKIM and DMARC at policy `p=none`, verified end to end on 2026-10-10 and accepted by Kivra; details are on [email-authentication](email-authentication.md) (2026-10-10, me).
