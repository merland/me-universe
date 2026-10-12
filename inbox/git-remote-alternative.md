status: draft 2026-10-10

# Possible plan: move this repo's remote off GitHub

Raised by me on 2026-10-10 as a question; the options below were researched by an agent in that session. Not decided. Exits: I pick one and it becomes a decision record plus an update to [services](../wiki/services.md), or I drop it and GitHub stays.

## Why consider it

The remote is a private repo under my GitHub account merland, which is also my work account and linked to my work address (2026-10-10, me). The wiki holds health, finances and company data; the schema says the remote is a private repository only I control. GitHub's operator can read a plain-text private repo, and the account mixes personal and work.

## Options

**Codeberg** (codeberg.org). Non-profit, Codeberg e.V. in Berlin, GDPR, no ads, no AI training on hosted code, no paid tiers; standard git over SSH, so the lint hook and push routine are unchanged. Private repos are free but capped at 100 MiB per user; account-wide limits are 750 MiB git and 1.5 GiB packages, LFS and attachments (2026-10-10, session, from docs.codeberg.org FAQ and the Codeberg-e.V. requests repo). Codeberg's mission is free software: the requests repo says quota raises are not granted for private or proprietary use, so a private-only account is tolerated, not intended. This repo was 5.6 MB in total and 4 MB in `sources/` on 2026-10-10 (session), so the cap is far off but binary sources grow toward it.

**Self-hosted on AWS Lightsail**, where I already run containers (see [services](../wiki/services.md)). Either Forgejo for a web UI, or a plain bare repo over SSH with no UI to patch, backed up to S3. No cap, no mission mismatch; I own patching and backups.

**git-remote-gcrypt** on top of either: encrypts the whole repo with my GPG key before push, so the host sees only ciphertext. Cost: web UI useless, every clone needs the key, losing the key loses the backup.

Passed over in the research: GitLab.com (no real privacy gain over GitHub), Sourcehut (paid, email-driven), a second GitHub account (same operator).

## If moving

Create the account with an erlandsson.se address, add an SSH key, create the private repo, change the origin URL, push, then update [services](../wiki/services.md) and write the decision record.
