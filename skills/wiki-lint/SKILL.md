---
name: wiki-lint
description: Run the me-universe wiki health check (scripts/lint.sh) and fix what it flags, as a `Wiki maintenance:` commit.
---

# wiki-lint

Runs the deterministic health check for the me-universe wiki and fixes what it flags. Triggered by natural language such as "lint the wiki" or "check the wiki"; it is not a slash command, and a `/wiki-lint` typed here belongs to a different wiki and must not be run. The wiki is the directory whose `README.md` carries the me-universe schema; read it first if this session has not.

## Steps

1. `git pull --ff-only`. If it fails, stop and report.
2. Run `scripts/lint.sh` from inside the repo and read every `FAIL` and `WARN` line.
3. Fix what can be fixed by editing:
   - broken links: point them at the right page, or remove them;
   - pages missing from `INDEX.md` or index entries with no page: add or remove the line, at most 25 words, saying what the page answers;
   - index lines over 25 words: shorten them;
   - inbox files without a status line: add `status: draft YYYY-MM-DD` using the file's first commit date, or today if uncommitted;
   - pages over about 1,100 words: split by topic, link the parts, update `INDEX.md`;
   - three or more flat pages sharing a topic: move them into `wiki/<topic>/` and fix links and `INDEX.md`.
4. Report, do not fix:
   - a secret match: remove the secret from the file and tell me which file and line; if it was already committed, say so, since rewriting history is my decision;
   - an append-only violation in history (`sources/`, `wiki/decisions/`, `journal/`): tell me; the fix is a new file, not an edit, and only I decide;
   - a stale page (newest date older than six months): list it and ask me whether it is still true; never re-date a fact without my confirmation;
   - a draft older than a month: list it and ask me to process or drop it.
5. Re-run the lint until it reports zero `FAIL`.
6. Commit with a message starting `Wiki maintenance:` that says what was fixed. No AI-attribution trailers.
7. `git push`. If it fails, report the commit hash and leave it local.
