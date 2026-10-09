# me-universe

A personal knowledge base: a plain-Markdown wiki in git, maintained by me and by AI agents. It remembers what I know, what I have decided, how the things I use are set up, and short dated notes about what happened.

This file is the schema. An agent reads it in full at the start of every session, after `AGENTS.md` sends it here. "I" and "me" in this repository is the owner; "agent" is any AI tool working here.

## Lineage: the LLM wiki pattern

This repo follows Andrej Karpathy's "LLM Wiki" pattern (gist, April 2026): **the model is not the memory; files are the memory.** Three layers: immutable raw sources that the model reads but never edits; a wiki of Markdown pages that the model writes and the human reads; and a schema document (this `README.md` plus `AGENTS.md`) that turns a generic chatbot into a disciplined maintainer. Three operations: **ingest** a source into the wiki, **query** the wiki and file useful answers back, **lint** for contradictions, stale claims, orphans and gaps. An index is read first on every session; git is the only writer; Obsidian or any Markdown viewer is just a viewer. Karpathy's own summary: "Obsidian is the IDE, the LLM is the programmer, the wiki is the codebase."

I have run a team wiki on this pattern since August 2026. The rules below carry what that repo and the wider practice have learned since the gist. Where the two disagree I have chosen, and the choice is deliberate.

### What the practice has learned since April 2026

1. **The index is the scaling lever.** It is loaded every session, so it must stay one short line per page saying what the page answers. My team wiki's index silently became a 4,500-word changelog within six weeks and had to be rewritten. Past roughly 150 pages, agents start duplicating content unless the index is tight.
2. **Pages drift by appending.** "Reassessed …, since …, since …" amendments double page length. A page states current state with dated facts; changes are folded in; git keeps the history.
3. **Scoped updates, never "update the wiki".** Name the pages a session touches, edit those, review the diff.
4. **Lint is a first-class operation**, run by a deterministic script, not by asking the model to "check health". Contradictions are cheapest to catch at write time.
5. **Query write-back.** An answer that took real work across several pages becomes a page or section. Most of the measured token saving comes from this.
6. **Agents read the wiki at session start and then forget it.** An audit of nine working sessions (gist comment, September 2026) found the wiki consulted at start but never mid-task; twice the agent re-diagnosed a failure that had a written lesson. So: before diagnosing, deciding or configuring anything, check the index for a page that already covers it, and say when a page was used.
7. **Inferences harden into facts.** Without discipline, a model's guess written back into the wiki reads like a sourced fact next session. Every fact carries its origin; agent suggestions are held apart from decisions.
8. **Inbox needs an exit.** Raw material parked "for later" with no status line stays forever.
9. **Dropped on purpose by people who have run these for months**: per-fact confidence scores, memory decay, per-page review dates, source hashing, a separate `log.md`, vector search. Immutable sources, dated facts, git history and a tight index do the same job at this scale with no machinery. The "LLM Wiki v2" proposals (typed knowledge graph, hybrid search, decay, hooks) are for thousands of pages and many agents; this repo adopts none of them until a lint shows the simple version failing.
10. **One writer at a time.** Concurrent agent sessions produce conflicting edits. One session commits at a time; pull before writing.

## Purpose

The wiki has no fixed subject. The first use is my technical setup (online services and how I have configured them, devices, domains, subscriptions), but it takes any topic I bring later: a hobby, a renovation, a health regime, a reading list, a side project. The structure grows with use; it is not designed up front.

Three kinds of content live here:

- **Knowledge pages** (`wiki/`): the current state of something, each fact dated with its origin.
- **Decision records** (`wiki/decisions/`): what I chose and why, dated, never rewritten.
- **Journal entries** (`journal/`): short dated notes about what happened or what I noticed. Raw, low effort, append-only. The librarian pass distills durable facts out of them into knowledge pages later.

## What never goes in

- **Secrets.** No passwords, API keys, recovery codes, 2FA seeds, tokens, private keys, or card numbers, not even partially. Secrets live in my password manager; the wiki records only the entry name to look up, written as `pw: github-main`. If I paste a secret into a session, the agent does not write it down and tells me.
- **Dossiers on other people.** People may be mentioned where they touch my life, projects or journal, but no page is *about* a person.
- **Machine-local state and scratch work.** Anything derivable from a repo with its own README gets a pointer, not a copy.

## Structure

```text
README.md        ← this schema
AGENTS.md        ← short pointer: pull first, read README, read INDEX, never bulk-read wiki/
CLAUDE.md        ← symlink to AGENTS.md (adapter for Claude Code)
INDEX.md         ← one line per page, at most 25 words, saying what the page answers
wiki/            ← knowledge pages; flat to begin with
  decisions/     ← YYYY-MM-DD-slug.md, never rewritten
  glossary.md    ← my own shorthand and names for things
journal/         ← YYYY-MM-DD.md, one file per day, append-only
inbox/           ← unprocessed material; every file opens with `status: draft YYYY-MM-DD`
sources/         ← append-only evidence: exports, invoices, documents, secrets redacted before filing
archive/         ← retired pages kept because they explain a later decision
scripts/lint.sh  ← deterministic health check, shell only
skills/          ← the session-end pass and the lint pass, as plain Markdown procedures
```

There is no `log.md`: commit messages that say what was learned make `git log` the operation log.

### How the structure grows

- `wiki/` starts flat. When three or more pages share a topic, move them into a subfolder named for that topic and update links and `INDEX.md` in the same commit, as a `Wiki maintenance:` commit.
- A subfolder may get its own `README.md` only when its pages need a shared convention, such as common headings. That is where a template lives, if one is ever needed, written after the second or third page of that kind, from what those pages actually turned out to need. Never write a template before the pages exist.
- Pages move, merge and split freely. `INDEX.md` and links are updated in the same commit, always.
- `journal/` and `sources/` never restructure. Their filenames are dates; they are the fixed layer everything else is distilled from.
- Nothing in the structure is sacred except: `sources/` and `journal/` append-only, decision records never rewritten, `INDEX.md` current.

## Reading rules

1. `git pull --ff-only` before anything else.
2. Read `INDEX.md`, open only the pages relevant to the task, never bulk-read `wiki/` or `journal/`.
3. Trust levels: `wiki/` is synthesized and may be stale, check dates; `sources/` and `journal/` are evidence; `inbox/` is unreliable.
4. Mid-task lookup: before diagnosing a problem, choosing between options, or configuring something, re-check `INDEX.md` for a page that already covers it, and say which page was used. Lesson 6 above.
5. Read the journal only when a task needs recent context, scanning the latest files, never the whole folder.

## Writing rules

1. Librarian, not stenographer. Distill; never paste transcripts, chats or e-mails into `wiki/`. A pasted document becomes a redacted file in `sources/` plus a distilled sentence in `wiki/` with provenance.
2. Every fact carries a date and where it came from: me, a session, a journal entry, a source file. Mark uncertainty explicitly rather than omitting it.
3. Point rather than copy. One home per fact. When restating elsewhere for context, restate coarser and date it.
4. Knowledge pages state current state, not history. A change is folded into the sentence it changes, never appended as a dated amendment. Pages stay under about 1,500 tokens (about 1,100 words); split when larger.
5. `sources/` and `journal/` are append-only. Decision records are never rewritten; a new record supersedes an old one, linked both ways.
6. Record what I did and chose, not what an agent proposed. A decision record names me as the approver with the date. An agent's suggestion goes to `inbox/` until I approve it.
7. Record facts, not inferred habits. One observed instance is a fact; a pattern is an open question until I confirm it.
8. Query write-back: an answer that took real work across several pages becomes a page or a section, so the next session looks it up instead of re-deriving it.
9. Scoped updates only. "Update the wiki" is my phrase for the session-end pass; it still means: name the pages this session changes, change those, show the diff. Never sweep the whole wiki.
10. `INDEX.md` is updated in the same commit whenever a page is added, removed, moved, or changes purpose. It is a map, not a changelog.
11. One commit per session, message says what was learned, not which files changed. Maintenance-only commits start with `Wiki maintenance:`. Push after every commit, for backup. If push fails, commit locally and report the hash.
12. No AI-attribution trailers in commits.
13. The remote is a private repository only I control. Never publish, fork, or push elsewhere. Never add a CI workflow that reads the contents.

### How a fact is written

A fact is a sentence with its date and origin in parentheses at the end. Origins are `me`, `session`, `journal/YYYY-MM-DD`, or `sources/<file>`.

```markdown
The home router is a Foo X1, bought 2025-03 (2026-10-09, me).
The ISP contract runs to 2027-01-31 (2026-10-09, sources/2026-10-09-isp-contract.pdf).
Backups probably run nightly; not confirmed (2026-10-09, session, unconfirmed).
```

Something I have not told an agent is written as `unknown`, never guessed. An agent's inference is marked `unconfirmed` and is an open question until I confirm it.

### Links and the index

Links are relative Markdown links, written from the linking file: a journal entry links to the glossary as `../wiki/glossary.md`, the index as `wiki/glossary.md`. The lint resolves them. `INDEX.md` lists every page under `wiki/` and `archive/`, one line each, at most 25 words, saying what the page answers. Subfolder `README.md` files are conventions, not pages, and are not indexed.

## Journal

- One file per day, `journal/YYYY-MM-DD.md`, created on first entry. Entries are a few lines each, appended in order. Never edited after the day.
- An entry can be added by me directly or by an agent on my instruction, such as "journal: switched the router to the new ISP today".
- The journal is evidence, like `sources/`, not knowledge. When an entry holds a fact that will still matter in a month, the librarian pass copies the fact into a knowledge page, dated, with `journal/YYYY-MM-DD` as provenance. The entry itself stays.
- Agents read the journal only when a task needs recent context, scanning the latest files, never the whole folder.

## Decision records

`wiki/decisions/YYYY-MM-DD-slug.md`. Each states what I decided, why, the alternatives I passed over if any, and "approved by me on YYYY-MM-DD". A record is never edited after its commit. To change a decision, write a new record that links to the old one, and add a single "superseded by" link at the top of the old one in the same commit; that link is the only edit a decision record ever receives, and the lint accepts no other. A proposal an agent made and I have not approved is not a decision; it goes to `inbox/`.

## Inbox

Unprocessed material. Every Markdown file opens with `status: draft YYYY-MM-DD` on its first line. Non-Markdown material parked here gets a `.md` note beside it carrying the status line. The exit from the inbox is one of: distilled into `wiki/` and deleted in the same commit; approved by me and turned into a decision record; or dropped. Drafts older than a month are listed by the lint until I process or drop them.

## Sources

Append-only evidence, named `YYYY-MM-DD-slug.ext`. Secrets are redacted before a file is filed, never after. A source is never edited or removed once committed; a corrected version is a new file.

## Archive

A page retired from `wiki/` is moved here, unchanged except for a first line saying when it was retired and which decision record or page explains why. Archived pages stay in `INDEX.md` under their own heading so they remain findable.

## Lint

`scripts/lint.sh` is a deterministic health check in shell, awk and grep, with git and date for history. It runs from anywhere inside the repo and exits non-zero on any `FAIL`. `WARN` lines are listed, not failed.

It checks:

- links resolve;
- `INDEX.md` and the pages under `wiki/` and `archive/` match both ways;
- pages over about 1,100 words (warn);
- index lines over 25 words;
- `wiki/decisions/` or `sources/` files changed after their first commit, in history or in the working tree;
- `journal/` files edited after their date, with one day of grace for a session that runs past midnight;
- inbox files without a status line, and drafts older than a month (warn);
- knowledge pages whose newest date is older than six months (warn);
- flat topics with three or more pages sharing a filename prefix that should become a folder (warn);
- things that look like secrets: long base64 or hex strings, private key headers, keys with the common `sk-` and `ghp_` prefixes, 16-digit numbers. A secret match fails the lint and blocks the commit; the report names the file and line without printing the match.

To make the block mechanical, install the script as a local pre-commit hook; hooks are not versioned, so this is done once per clone:

```sh
ln -s ../../scripts/lint.sh .git/hooks/pre-commit
```

The lint must pass before any commit. An agent never commits over a `FAIL`.

## Skills

`skills/wiki-update/SKILL.md` is the session-end pass. `skills/wiki-lint/SKILL.md` runs the lint and fixes what it flags. Both are plain Markdown procedures with a `name` and `description` front matter, vendor-neutral. They are not installed anywhere and are not slash commands.

I trigger them in natural language. "Update the wiki", "write that up", "journal: …" and the like mean the session-end pass; "lint the wiki" or "check the wiki" means the lint pass. An agent follows the SKILL.md file directly.

This repo has no connection to any other wiki, repository or skill set. If I type `/wiki-update`, `/wiki-lint` or any other slash command that names a wiki while working here, the agent does not run it: it belongs to a different wiki and would write there. The agent says so and stops.

## A session, in short

1. Start: pull, read this file, read `INDEX.md`, open only what the task needs.
2. During: before diagnosing, choosing or configuring, re-check `INDEX.md`; say which page was used. Never write a secret down.
3. End: when I say "update the wiki" or similar, run the pass in `skills/wiki-update/SKILL.md`. Name the pages, distill, journal if asked, grow folders at three pages, update `INDEX.md`, lint, one commit whose message says what was learned, push.
