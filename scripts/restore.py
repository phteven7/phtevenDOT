#!/usr/bin/env python3
"""Restore originals from a link.py backup manifest."""
import argparse
import json
import os
from pathlib import Path

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('manifest', type=Path)
parser.add_argument('--apply', action='store_true')
args = parser.parse_args()
entries = json.loads(args.manifest.read_text())
for entry in entries:
    dest = Path(entry['destination'])
    if not dest.is_symlink() or os.readlink(dest) != entry['source']:
        raise SystemExit(f'{dest} changed since linking; refusing to overwrite it.')
    if entry['backup'] and not os.path.lexists(entry['backup']):
        raise SystemExit(f'Missing backup: {entry["backup"]}')
for entry in reversed(entries):
    dest = Path(entry['destination'])
    print(f'Restore {dest}')
    if args.apply:
        dest.unlink()
        if entry['backup']:
            Path(entry['backup']).rename(dest)
if not args.apply:
    print('Preview only. Add --apply to restore.')
