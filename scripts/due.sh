#!/bin/sh
# Due check for wiki/deadlines.md. Reads only table rows "| YYYY-MM-DD | lead days | what | pointer |".
# A row fires when (due - today) in whole days <= lead: "due in N days (date): what → pointer", or "overdue N days …".
# An unreadable date or a non-integer lead prints its own line and counts as a hit; nothing is skipped silently.
# Exit 1 if anything was printed, else print exactly "due: nothing" and exit 0.
# DUE_TODAY=YYYY-MM-DD replaces today (tests); DUE_HORIZON=N replaces every row's lead, to list all within N days.

set -u
cd "$(git -C "$(dirname "$0")" rev-parse --show-toplevel 2>/dev/null)" 2>/dev/null || exit 2
page=wiki/deadlines.md
epoch() { date -j -f %Y-%m-%d "$1" +%s 2>/dev/null || date -d "$1" +%s 2>/dev/null; }
trim() { printf '%s' "$1" | sed 's/^ *//; s/ *$//'; }
today=${DUE_TODAY:-$(date +%Y-%m-%d)}
t=$(epoch "$today") || { echo "due: unreadable DUE_TODAY"; exit 1; }
hits=0
while IFS='|' read -r _ due lead what pointer _; do
  due=$(trim "$due"); lead=$(trim "${DUE_HORIZON:-$lead}"); what=$(trim "$what"); pointer=$(trim "$pointer")
  [ -z "$due" ] && continue
  d=$(epoch "$due") || { echo "due: unreadable date in row: $due | $what"; hits=$((hits + 1)); continue; }
  case $lead in ''|*[!0-9]*) echo "due: lead days not a number in row: $due | $lead | $what"; hits=$((hits + 1)); continue;; esac
  days=$(( (d - t) / 86400 ))
  [ "$days" -gt "$lead" ] && continue
  hits=$((hits + 1))
  if [ "$days" -ge 0 ]; then echo "due in $days days ($due): $what → $pointer"
  else echo "overdue $((-days)) days ($due): $what → $pointer"; fi
done <<ROWS
$(grep -E '^\| *[0-9]{4}-[0-9]{2}-[0-9]{2} *\|' "$page")
ROWS
[ "$hits" -gt 0 ] && exit 1
echo "due: nothing"
