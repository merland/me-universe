---
name: wiki-update
description: Session-end librarian pass for the me-universe personal wiki. Pull, name the pages this session touches, distill into them, journal if asked, grow folders at three pages, update INDEX.md, lint, one commit, push.
---

# wiki-update

The session-end pass for the me-universe wiki, triggered by natural language: "update the wiki", "write that up", "journal: …", or at the end of a session that settled a decision, learned how something is set up, or produced an answer that took real work across pages. It is not a slash command; a `/wiki-update` typed here belongs to a different wiki and must not be run. The wiki is the directory whose `README.md` carries the me-universe schema; read that file first if this session has not.

"Update the wiki" is my phrase for this pass, not a licence to sweep the whole wiki. Name the pages, change those, show the diff.

## Steps

1. **Pull.** `git pull --ff-only`. If it fails, stop and report; never force or rebase over someone else's writes.
2. **Name the pages.** Before editing, list what this session will touch: existing pages to change, new pages to create, a journal entry if I asked for one, anything going to `inbox/`. If the list is "everything", the scope is wrong; narrow it. Check `INDEX.md` for an existing page before creating one.
3. **Distill.** For each page: state current state, fold a change into the sentence it changes, never append a dated amendment. Date and source every fact (`me`, `session`, `journal/YYYY-MM-DD`, `sources/<file>`). Write `unknown` for what I did not say and `unconfirmed` for what was inferred. Never paste transcripts, chats or e-mails; a pasted document becomes a redacted file in `sources/` plus a distilled sentence with provenance. A secret is never written; record `pw: entry-name` and tell me.
4. **Proposals.** Anything an agent suggested and I have not approved goes to `inbox/`, opening with `status: draft YYYY-MM-DD`, not to `wiki/`.
5. **Decisions.** If I approved a decision this session, write `wiki/decisions/YYYY-MM-DD-slug.md`: what, why, alternatives passed over, "approved by me on YYYY-MM-DD". If it replaces an earlier record, link both ways; the only edit the old record receives is an added "Superseded by" line.
6. **Journal.** If I asked, append a few lines to `journal/YYYY-MM-DD.md` for today, creating it if missing. Never touch an earlier day's file. If an entry holds a fact that will still matter in a month, copy it into a knowledge page with `journal/YYYY-MM-DD` as provenance.
7. **Growth rule.** If a flat topic now has three or more pages, move them into `wiki/<topic>/`, fix links and `INDEX.md`, and make that its own `Wiki maintenance:` commit before the session commit.
8. **Index.** For every page added, removed, moved or changed in purpose, update `INDEX.md`: one line, at most 25 words, what the page answers. A map, not a changelog.
9. **Lint.** Run `scripts/lint.sh`. Fix every `FAIL`. Fix `WARN`s on the pages touched; list the others. Never commit over a `FAIL`; a secret match means remove it, then tell me.
10. **Diff.** Show `git diff --stat` and the content diff for the pages touched, and summarise what changed in a few lines.
11. **Commit.** One commit for the session. The message says what the wiki now knows or what was learned, not which files changed. No AI-attribution trailers.
12. **Push.** `git push`. If it fails, leave the commit local, report the hash, and do not retry with force.
13. **Report.** Pages touched, lint result, commit hash, push status.

## Never

- Bulk-read `wiki/` or `journal/`.
- Edit a past day's journal file, anything in `sources/`, or a decision record (beyond the "Superseded by" line).
- Write a page about a person.
- Add a CI workflow, publish, fork, or push anywhere but the private remote.
