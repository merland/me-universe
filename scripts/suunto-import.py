#!/usr/bin/env python3
"""File the daily data from an unzipped Suunto app export into sources/suunto/.

Usage: python3 -I scripts/suunto-import.py <unzipped-export-dir>

Copies activity/, sleep/ and sleep_stages/ month files verbatim, but only for
months strictly before the export month, so a filed month never changes.
A file already filed is left alone: identical means skipped, different means
reported and not written (file a corrected copy as a new file, per README.md).
"""
import json
import sys
from pathlib import Path

FOLDERS = ("activity", "sleep", "sleep_stages")


def export_month(export: Path) -> str:
    """Newest activity timestamp, as YYYY-MM."""
    newest = ""
    for f in (export / "activity").glob("*.ndjson"):
        for line in f.open():
            ts = json.loads(line)["timestamp"][:10]
            newest = max(newest, ts)
    if not newest:
        sys.exit("no activity data found; is this an unzipped Suunto export?")
    return newest[:7]


def main() -> int:
    if len(sys.argv) != 2:
        sys.exit(__doc__)
    export = Path(sys.argv[1]).expanduser()
    repo = Path(__file__).resolve().parent.parent
    dest_root = repo / "sources" / "suunto"
    month = export_month(export)
    print(f"export month {month}: filing months before it")
    added = skipped = pending = differs = 0
    for folder in FOLDERS:
        src_dir = export / folder
        if not src_dir.is_dir():
            print(f"  {folder}/: not in export")
            continue
        for src in sorted(src_dir.glob("*.ndjson")):
            if src.name[:7] >= month:
                print(f"  pending  {folder}/{src.name} (export month, wait for next export)")
                pending += 1
                continue
            dst = dest_root / folder / src.name
            data = src.read_bytes()
            if dst.exists():
                if dst.read_bytes() == data:
                    skipped += 1
                else:
                    print(f"  DIFFERS  {folder}/{src.name}: filed copy differs, not written; "
                          f"file a corrected copy as a new file if the export is right")
                    differs += 1
                continue
            dst.parent.mkdir(parents=True, exist_ok=True)
            dst.write_bytes(data)
            print(f"  added    {folder}/{src.name}")
            added += 1
    print(f"added {added}, identical and skipped {skipped}, pending {pending}, differing {differs}")
    return 1 if differs else 0


if __name__ == "__main__":
    sys.exit(main())
