#!/usr/bin/env python3
"""Export the live Omarchy desktop configuration into this shared checkout."""
import json
import os
import re
from pathlib import Path
import shutil
import sys

REPO = Path(__file__).resolve().parents[1]
HOME = Path.home()
DEST = REPO / 'omarchy'
NAMES = ('hypr', 'waybar', 'ghostty', 'alacritty', 'kitty', 'mako', 'swayosd', 'walker', 'wofi', 'rofi')
IGNORE = shutil.ignore_patterns('.git', '.DS_Store', '__pycache__', '*.log', '*.bak', '*.backup', '*.swp')


def main():
    if sys.platform != 'linux':
        raise SystemExit('Run this script inside TryOmarchy, not on macOS.')
    if DEST.exists():
        raise SystemExit(f'{DEST} already exists; refusing to overwrite a previous export.')
    hypr = HOME / '.config/hypr'
    if not hypr.is_dir():
        raise SystemExit(f'No Hyprland configuration found at {hypr}.')
    stage = REPO / '.omarchy-collecting'
    stage.mkdir(exist_ok=False)
    collected = []
    try:
        for name in NAMES:
            source = HOME / '.config' / name
            if source.is_dir():
                # Resolve theme links into a standalone snapshot of the active setup.
                shutil.copytree(source, stage / 'config' / name, symlinks=False, ignore=IGNORE)
                collected.append(str(source))
        themes = []
        for root in (HOME / '.config/omarchy/themes', HOME / '.local/share/omarchy/themes'):
            if root.is_dir():
                for theme in root.iterdir():
                    if 'amethyst' in theme.name.lower() and theme.is_dir():
                        relative = theme.relative_to(HOME)
                        target = stage / 'home' / relative
                        shutil.copytree(theme, target, symlinks=False, ignore=IGNORE)
                        themes.append(str(relative))
        # Save user-facing Omarchy settings, leaving its runtime state in place.
        settings = HOME / '.config/omarchy'
        if settings.is_dir():
            for source in settings.iterdir():
                if source.is_file() and not source.is_symlink() and source.suffix in ('.conf', '.toml', '.json', '.jsonc', '.yaml', '.yml'):
                    target = stage / 'home' / source.relative_to(HOME)
                    target.parent.mkdir(parents=True, exist_ok=True)
                    shutil.copy2(source, target)
        # Include executable user helpers directly referenced by these configs.
        # Do not walk unrelated ~/.local data, credentials, or application state.
        helpers = set()
        reference = re.compile(r'(?:~/|\$HOME/|\$\{HOME\}/|' + re.escape(str(HOME)) + r'/)((?:\.local/bin|bin)/[A-Za-z0-9_.+/-]+)')
        for config in (stage / 'config').rglob('*'):
            if not config.is_file() or config.stat().st_size > 1024 * 1024:
                continue
            try:
                content = config.read_text()
            except UnicodeDecodeError:
                continue
            for relative in reference.findall(content):
                if '..' in Path(relative).parts:
                    continue
                source = HOME / relative
                if source.is_file() and source.stat().st_size < 1024 * 1024:
                    target = stage / 'home' / relative
                    target.parent.mkdir(parents=True, exist_ok=True)
                    shutil.copy2(source, target)
                    helpers.add(relative)
        manifest = {
            'source_home': str(HOME), 'hostname': os.uname().nodename,
            'configs': collected, 'amethyst_themes': themes,
            'current_theme': str((settings / 'current/theme').resolve()),
            'shared_repo': str(REPO), 'helpers': sorted(helpers),
        }
        (stage / 'capture.json').write_text(json.dumps(manifest, indent=2) + '\n')
        stage.rename(DEST)
    except BaseException:
        shutil.rmtree(stage)
        raise
    print(f'Exported {len(collected)} config directories and {len(themes)} Amethyst theme directories to {DEST}.')
    print('The Mac-side agent can now inspect and link these files. Existing VM configs are still active.')

if __name__ == '__main__':
    main()
