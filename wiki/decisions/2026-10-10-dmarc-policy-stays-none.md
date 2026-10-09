# DMARC policy stays at p=none

Decided: both megabit.se and erlandsson.se keep `v=DMARC1; p=none`. No aggregate-report address (`rua`) is added for now.

Why: the goal of the authentication work was for Kivra to accept my mail, and that is achieved with SPF, DKIM and DMARC passing at `p=none`, see [email-authentication](../email-authentication.md). A stricter policy only changes how receivers treat forged mail, which has not been a problem. megabit.se passes DMARC by DKIM alone, so a stricter policy would carry some risk there if a signature breaks in transit.

Alternatives passed over: `p=quarantine`; `p=reject`; adding `rua` first and tightening after reviewing reports. Any of them can be taken up later with a new record.

Approved by me on 2026-10-10.
