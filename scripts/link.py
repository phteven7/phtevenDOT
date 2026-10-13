#!/usr/bin/env python3
"""Link collected configs to this checkout, preserving originals as backups."""
import argparse
from datetime import datetime
import json
import os
from pathlib import Path
import sys

REPO = Path(__file__).resolve().parents[1]
HOME = Path.home()


def mappings(profile):
    if profile == 'macos':
        return [(REPO / source, HOME / dest) for source, dest in (
            ('tmux/tmux.conf', '.tmux.conf'),
            ('nvim', '.config/nvim'),
            ('zsh/zshrc', '.zshrc'),
            ('zsh/zprofile', '.zprofile'),
            ('zsh/p10k.zsh', '.p10k.zsh'),
            ('zsh/custom/example.zsh', '.oh-my-zsh/custom/example.zsh'),
            ('zsh/custom/themes/example.zsh-theme', '.oh-my-zsh/custom/themes/example.zsh-theme'),
            ('zsh/custom/plugins/example/example.plugin.zsh', '.oh-my-zsh/custom/plugins/example/example.plugin.zsh'),
        )]
    if sys.platform != 'linux':
        raise SystemExit('The omarchy profile must run inside Linux.')
    capture = json.loads((REPO / 'omarchy/capture.json').read_text())
    result = [(REPO / 'omarchy/config' / Path(path).name, HOME / '.config' / Path(path).name)
              for path in capture['configs']]
    for relative in capture['amethyst_themes'] + capture.get('helpers', []):
        result.append((REPO / 'omarchy/home' / relative, HOME / relative))
    settings = REPO / 'omarchy/home/.config/omarchy'
    if settings.is_dir():
        result.extend((source, HOME / '.config/omarchy' / source.name)
                      for source in settings.iterdir() if source.is_file())
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('profile', choices=('macos', 'omarchy'))
    parser.add_argument('--apply', action='store_true', help='Apply links; otherwise preview only.')
    args = parser.parse_args()
    pairs = mappings(args.profile)
    for source, dest in pairs:
        if not source.exists():
            raise SystemExit(f'Missing repo config: {source}')
    pending = [(s, d) for s, d in pairs if not (d.is_symlink() and d.resolve() == s.resolve())]
    if not pending:
        print('All configs already point to this checkout.')
        return
    for source, dest in pending:
        print(f'{dest} -> {source}')
    if not args.apply:
        print('Preview only. Add --apply to create links and back up originals.')
        return
    backup_root = HOME / '.local/state/phtevenDOT/backups' / datetime.now().strftime('%Y%m%d-%H%M%S-%f')
    backup_root.mkdir(parents=True)
    journal = []
    try:
        for source, dest in pending:
            backup = backup_root / dest.relative_to(HOME)
            existed = os.path.lexists(dest)
            if existed:
                backup.parent.mkdir(parents=True, exist_ok=True)
                dest.rename(backup)
            journal.append({'destination': str(dest), 'source': str(source),
                            'backup': str(backup) if existed else None})
            dest.parent.mkdir(parents=True, exist_ok=True)
            dest.symlink_to(source, target_is_directory=source.is_dir())
        (backup_root / 'manifest.json').write_text(json.dumps(journal, indent=2) + '\n')
    except BaseException:
        for entry in reversed(journal):
            dest = Path(entry['destination'])
            if dest.is_symlink() and os.readlink(dest) == entry['source']:
                dest.unlink()
            if entry['backup']:
                Path(entry['backup']).rename(dest)
        raise
    print(f'Linked {len(pending)} configs. Originals and restore manifest: {backup_root}')

if __name__ == '__main__':
    main()
