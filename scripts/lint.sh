#!/bin/sh
# Deterministic health check for the me-universe wiki.
# Shell, awk, grep, sed, git and date only. Run from anywhere inside the repo.
# Exit 1 on any FAIL. WARN lines are listed, not failed.
# Usable unchanged as a pre-commit hook: ln -s ../../scripts/lint.sh .git/hooks/pre-commit

set -u
cd "$(git rev-parse --show-toplevel)" || exit 2

report=$(mktemp) || exit 2
trap 'rm -f "$report" "$report.a" "$report.b"' EXIT
fail() { printf 'FAIL %s\n' "$*" >> "$report"; }
warn() { printf 'WARN %s\n' "$*" >> "$report"; }

today=$(date +%Y-%m-%d)
days_ago()  { date -v-"$1"d +%Y-%m-%d 2>/dev/null || date -d "$1 days ago" +%Y-%m-%d; }
next_day()  { date -j -v+1d -f %Y-%m-%d "$1" +%Y-%m-%d 2>/dev/null || date -d "$1 + 1 day" +%Y-%m-%d; }
month_ago=$(days_ago 30)
six_months_ago=$(days_ago 182)
have_history=0; git rev-parse --verify HEAD >/dev/null 2>&1 && have_history=1

# All Markdown files, excluding .git and symlinked adapter folders (find does not follow symlinks).
md_files() { find . -path ./.git -prune -o -type f -name '*.md' -print | sed 's|^\./||' | sort; }

# 1. Secrets. Report file:line only; never print the match.
secret_re='[A-Za-z0-9+/]{40,}={0,2}|[0-9a-fA-F]{32,}|BEGIN [A-Z ]*PRIVATE KEY|(^|[^A-Za-z0-9_])sk-[A-Za-z0-9_-]{8,}|(^|[^A-Za-z0-9_])ghp_[A-Za-z0-9]{10,}|([0-9]{4}[ -]?){3}[0-9]{4}'
grep -rInE --exclude-dir=.git --exclude=lint.sh -e "$secret_re" . 2>/dev/null | cut -d: -f1,2 | sed 's|^\./||' | while read -r loc; do
  fail "$loc: looks like a secret; redact before committing"
done

# 2. Links resolve (relative Markdown links; http, mailto and #anchors skipped).
md_files | while read -r f; do
  dir=$(dirname "$f")
  grep -oE '\]\([^)]+\)' "$f" 2>/dev/null | sed 's/^](//; s/)$//' | while read -r t; do
    case "$t" in http://*|https://*|mailto:*|\#*|'') continue;; esac
    p=${t%%#*}; p=${p%% *}
    [ -z "$p" ] && continue
    [ -e "$dir/$p" ] || [ -e "$p" ] || fail "$f: broken link -> $t"
  done
done

# 3. INDEX.md and pages match both ways (wiki/ and archive/; subfolder README.md excluded).
grep -oE '\]\([^)]+\.md\)' INDEX.md 2>/dev/null | sed 's/^](//; s/)$//' | sort -u > "$report.a"
find wiki archive -type f -name '*.md' 2>/dev/null | grep -v '/README\.md$' | sort > "$report.b"
comm -13 "$report.a" "$report.b" | while read -r p; do fail "$p: not listed in INDEX.md"; done
comm -23 "$report.a" "$report.b" | while read -r p; do fail "INDEX.md lists $p, which does not exist"; done

# 4. Pages over about 1,100 words.
find wiki archive -type f -name '*.md' 2>/dev/null | sort | while read -r f; do
  n=$(wc -w < "$f" | tr -d ' ')
  [ "$n" -gt 1100 ] && warn "$f: $n words, over about 1,100; split it"
done

# 5. Index lines over 25 words (the leading dash is not counted).
awk '/^- / && NF-1 > 25 { print FILENAME ": line " NR " has " NF-1 " words, limit 25" }' INDEX.md 2>/dev/null | while read -r l; do fail "$l"; done

# 6. Append-only: wiki/decisions/ and sources/ never change after their first commit.
#    The only edit a decision record may receive is added lines starting "Superseded by".
if [ "$have_history" = 1 ]; then
  git ls-files wiki/decisions sources | grep -v '/\.gitkeep$' | while read -r f; do
    git log --diff-filter=M --format=%h -- "$f" | while read -r c; do
      changed=$(git diff "$c^" "$c" -- "$f" | grep -E '^[-+]' | grep -vE '^(\+\+\+|---)')
      case "$f" in
        wiki/decisions/*)
          if printf '%s\n' "$changed" | grep -qvE '^\+Superseded by'; then
            fail "$f: modified in commit $c; decision records are never rewritten"
          fi;;
        *) fail "$f: modified in commit $c; sources/ is append-only";;
      esac
    done
  done
fi
git status --porcelain -- wiki/decisions sources 2>/dev/null | grep -vE '^(\?\?|A ) ' | while read -r l; do
  fail "uncommitted change to append-only file: $l"
done

# 7. Journal: YYYY-MM-DD.md, never edited after its day (one day of grace).
find journal -type f -name '*.md' 2>/dev/null | sort | while read -r f; do
  d=$(basename "$f" .md)
  case "$d" in
    [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]) ;;
    *) fail "$f: journal files are named YYYY-MM-DD.md"; continue;;
  esac
  limit=$(next_day "$d")
  if [ "$have_history" = 1 ]; then
    git log --diff-filter=M --format=%ad --date=short -- "$f" | while read -r cd; do
      [ "$cd" \> "$limit" ] && fail "$f: edited on $cd, after its day"
    done
  fi
  if git status --porcelain -- "$f" 2>/dev/null | grep -qE '^.M|^M'; then
    [ "$today" \> "$limit" ] && fail "$f: modified in the working tree on $today, after its day"
  fi
done

# 8. Inbox: every Markdown file opens with "status: draft YYYY-MM-DD"; drafts older than a month are listed.
find inbox -type f -name '*.md' 2>/dev/null | sort | while read -r f; do
  s=$(head -n 3 "$f" | grep -oE 'status: [a-z]+ [0-9]{4}-[0-9]{2}-[0-9]{2}' | head -n 1)
  if [ -z "$s" ]; then
    fail "$f: no 'status: draft YYYY-MM-DD' line at the top"
  else
    sd=$(printf '%s' "$s" | awk '{print $3}')
    [ "$sd" \< "$month_ago" ] && warn "$f: draft since $sd, older than a month; process or drop it"
  fi
done

# 9. Knowledge pages whose newest date is older than six months (listed, not failed).
find wiki -type f -name '*.md' 2>/dev/null | grep -v '^wiki/decisions/' | grep -v '/README\.md$' | sort | while read -r f; do
  newest=$(grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}' "$f" | sort | tail -n 1)
  if [ -z "$newest" ]; then
    warn "$f: no dated facts"
  elif [ "$newest" \< "$six_months_ago" ]; then
    warn "$f: newest date is $newest, older than six months; check it is still true"
  fi
done

# 10. Flat topics with three or more pages sharing a filename prefix should become a folder.
find wiki -maxdepth 1 -type f -name '*-*.md' 2>/dev/null | sed 's|^wiki/||' | awk -F- '
  { c[$1]++; names[$1] = names[$1] " " $0 }
  END { for (k in c) if (c[k] >= 3) print k ": " c[k] " flat pages (" names[k] " ); move them to wiki/" k "/" }
' | while read -r l; do warn "$l"; done

# Report.
cat "$report"
nf=$(grep -c '^FAIL' "$report"); nw=$(grep -c '^WARN' "$report")
printf 'lint: %s fail, %s warn\n' "$nf" "$nw"
[ "$nf" -eq 0 ]
