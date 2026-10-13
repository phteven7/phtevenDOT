# phtevenDOT

Personal dotfiles. Edit the files in this checkout; the normal application paths
point here through symlinks.

| Config | Repo location | Active macOS path |
| --- | --- | --- |
| tmux | `tmux/tmux.conf` | `~/.tmux.conf` |
| Neovim / LazyVim | `nvim/` | `~/.config/nvim` |
| Oh My Zsh settings | `zsh/zshrc` | `~/.zshrc` |
| Powerlevel10k prompt | `zsh/p10k.zsh` | `~/.p10k.zsh` |
| Login shell PATH | `zsh/zprofile` | `~/.zprofile` |
| Local Oh My Zsh custom files | `zsh/custom/` | Matching files under `~/.oh-my-zsh/custom/` |
| TryOmarchy / Hyprland / Amethyst | `omarchy/` after VM capture | Matching Linux config and theme paths |

The Neovim files include the existing C# setup and plugin lockfile. The former
Neovim checkout's Git metadata is retained with the original backup, rather than
nested inside this repo. Oh My Zsh, Powerlevel10k, the Zsh plugin checkouts, and
the tmux Catppuccin plugin remain installed in their original locations.
`dependencies.json` records their upstream URLs and installed commits. These
upstream packages are dependencies, not personal configuration; they are not
vendored into this repo. Neovim plugin data stays under `~/.local/share/nvim`.

## Apply or inspect links

Requires Python 3. From the repo:

```sh
python3 scripts/link.py macos          # preview
python3 scripts/link.py macos --apply  # back up originals, then link
```

Existing correct links are skipped. Originals are moved into a timestamped
folder under `~/.local/state/phtevenDOT/backups/`; each folder contains a
`manifest.json`. No original config or nested Git history is deleted.

After changes, open a new Zsh session, reload tmux with prefix + r, or restart
Neovim. Symlinks keep the original config paths valid, including tmux's theme
path and Zsh's prompt and plugin paths. Re-run the linker if the checkout moves.

To restore the originals, use the specific backup manifest:

```sh
python3 scripts/restore.py ~/.local/state/phtevenDOT/backups/TIMESTAMP/manifest.json
python3 scripts/restore.py ~/.local/state/phtevenDOT/backups/TIMESTAMP/manifest.json --apply
```

Restore refuses to overwrite a path that has changed since it was linked. Save
any edits made in the repo separately if you want to keep them after restoring.

## Capture TryOmarchy

TryOmarchy currently shares the Mac's `~/Documents` at `/mnt/mac` and exposes it
as `~/Documents` inside Linux. This checkout is therefore already available in
the VM; a separate clone is optional.

Run inside the VM:

```sh
cd ~/Documents/IUSDRepos/phtevenDOT
python3 scripts/collect-omarchy.py
```

The collector copies the live Hyprland configuration, available companion UI
configs, Amethyst theme directories, and top-level Omarchy settings into
`omarchy/`. It refuses to overwrite a previous capture. Theme symlinks in the
UI snapshot are resolved to preserve the actual active appearance. Its
`capture.json` records the original paths and selected theme. It does not copy
the VM disk, passwords, SSH keys, browser profiles, or shell history.

After reviewing the captured files and their external script references, run
inside the VM:

```sh
python3 scripts/link.py omarchy
python3 scripts/link.py omarchy --apply
hyprctl reload
```

The Linux linker backs up each original and points its normal config or theme
path into this checkout. Omarchy's `current/theme` selector remains in Linux;
custom Amethyst themes are linked at their original theme locations. Omarchy
and Hyprland must already be installed; their default config and helper scripts
under `~/.local/share/omarchy` remain dependencies. A shared checkout must stay
mounted while these Linux links are in use. On native Linux, clone locally and
run the same `omarchy` linker to use a local checkout instead.

## Portability

The captured Zsh PATH entries use `$HOME` rather than a specific Mac username.
The JetBrains Toolbox PATH entry is macOS-specific. Do not apply the macOS
profile over Omarchy's shell config unless you intentionally want that shell
setup too. No credentials or machine-generated caches belong in this repo.

## Hyprland Amethyst configuration

Personal Amethyst-style overrides for Omarchy’s Lua-based Hyprland configuration.
Requires an Omarchy/Hyprland installation supporting the `hl` and `o` Lua APIs;
these are not standalone `.conf` files for standard Hyprland installations.

### Layout

Uses the native master layout with a centered master occupying 55% of the width.
New windows become slaves. The master centers with at least two slaves and
falls back to the left with fewer slaves. Omarchy styling remains inherited.

### Shortcuts

On an Apple keyboard, Option is Alt and Command is Super.

| Shortcut | Action |
| --- | --- |
| Alt + Shift + H/J/K/L | Focus left/down/up/right |
| Alt + Shift + Return | Swap with master |
| Alt + Ctrl + Shift + H | Shrink master by 5 percentage points |
| Alt + Ctrl + Shift + L | Grow master by 5 percentage points |
| Alt + Ctrl + Shift + Return | Reset master width to 55% |

### Apply the customizations

`config/hypr/bindings.lua` and `config/hypr/looknfeel.lua` are exact copies of
the customized files. Back up your existing files before applying them.
If you already have personal overrides, merge the blocks labeled
`Project Amethyst` into your corresponding files instead of replacing them.
The main Omarchy config must load both files after its defaults.

Check existing bindings with `omarchy menu keybindings --print`. These shortcuts
were unbound on the source machine; on another installation, unbind conflicting
shortcuts with `hl.unbind(...)` before adding the new bindings.

After applying, run:

```sh
hyprctl reload
hyprctl configerrors
```

### Full machine snapshot

`snapshot/hypr/` contains the complete source-machine Hyprland configuration,
including monitor, input, autostart, night-light and portal settings.
It is included for reference and backup, not as a portable installation preset.

The snapshot depends on Omarchy defaults in `/usr/share/omarchy` (or
`OMARCHY_PATH`). Its input config also loads
`/usr/share/try-omarchy/pinch-input.lua` and
`/usr/share/try-omarchy/apple-keyboard-input.lua`.
Its QEMU monitor profile invokes `/usr/local/bin/omarchy-native-display-sync`
when the kernel option `omarchy.qemu_virgl=1` is present.
Those external helpers and the active Omarchy theme are not included.

Exported from the source machine on 2026-10-12. No live configuration was changed.
