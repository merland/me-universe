status: draft 2026-10-09

# Possible plan: give agents access to my Strava data via the API

Proposed by an agent on 2026-10-09 after I asked whether it was possible. Not decided. Exits: I approve it and it becomes a decision record plus a page, or I drop it.

## What it would give

Routine runs, weekly volume, trends, and Strava's own fitness and race-prediction numbers, pulled on demand, which [running-races](../wiki/running-races.md) currently lacks. Not the original FIT files, so RR intervals and Suunto ZoneSense fields still need the watch or Suunto app; FIT stays the source for deep analysis.

## How it would work

1. Register an application in Strava settings; this yields a client ID and secret.
2. One-time browser authorisation with scope `activity:read_all`; this yields a refresh token.
3. A script refreshes the six-hour access token each run and fetches activities, streams, laps and summaries.

## Constraints

- Client secret and refresh token are secrets: LastPass plus a gitignored local config, never the repo. The wiki would record only a `pw:` pointer.
- A fetch script is tooling beyond the initial brief; it either lives outside the wiki or I allow a `scripts/` addition.
- Pulled data worth keeping is filed under `sources/` as dated exports and distilled into pages.
- Rate limits are modest, on the order of a couple of hundred requests per 15 minutes, enough for personal use.
- Strava's API terms, changed late 2024, restrict AI-training and some third-party uses; personal analysis of my own data is within them.

## Options

- A short script that refreshes the token and dumps activities as JSON. Simplest, under my control, works in any session. Agent's suggested starting point.
- A community Strava MCP server exposing the data as tools in Claude Code. More convenient, one more dependency to trust with tokens.

## To decide

Whether to do it at all; script or MCP server; where the script and config live; the `pw:` entry name.
