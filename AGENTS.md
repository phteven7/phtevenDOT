# Integrating phtevenDOT

This repository is the source for personal configs. When asked to integrate it
on a machine, inspect the host and existing configs, install missing dependencies,
and create symlinks from the normal application paths to this checkout. Resolve
the checkout's actual absolute path; do not assume a username or clone location.

## Config paths

On macOS and Linux:

- `tmux/tmux.conf` → `~/.tmux.conf`
- `nvim/` → `~/.config/nvim`
- `zsh/zshrc` → `~/.zshrc`
- `zsh/p10k.zsh` → `~/.p10k.zsh`

On macOS also link `zsh/zprofile` → `~/.zprofile`. It initializes an installed
Homebrew and adds optional JetBrains Toolbox and personal executable paths.

For Lua-based Omarchy also link these individual files:

- `config/hypr/bindings.lua` → `~/.config/hypr/bindings.lua`
- `config/hypr/looknfeel.lua` → `~/.config/hypr/looknfeel.lua`

Keep machine-specific Hyprland monitor, input, autostart, and VM integrations
in place. Check that the existing `hyprland.lua` loads `hypr.bindings` and
`hypr.looknfeel` after Omarchy defaults. These overrides require the `hl` and `o`
Lua APIs and cannot be installed as standard Hyprland `.conf` files. Inspect
existing keybindings for conflicts before adding the phteven bindings.

## Dependencies

Use `dependencies.json` for the Oh My Zsh, Powerlevel10k, Zsh plugins, and tmux
Catppuccin upstream URLs, expected paths, and known-working revisions. Keep
existing working installations. Install missing dependencies outside the repo;
do not copy their source or generated caches into this checkout.

The main tools are Git, Neovim, tmux, and Zsh. Neovim also uses ripgrep,
fd, a C compiler, and gitui. The C# config needs a .NET SDK; Mason manages the
Roslyn server and CSharpier. Use a Nerd Font for prompt and status icons.
Check the installed tool versions against the current LazyVim requirements.
Neovim bootstraps lazy.nvim and installs plugins using `nvim/lazy-lock.json`.

## Style

Neovim defaults to literal tab characters, displayed at two columns (four for
C#). Keep `.editorconfig` and `nvim/stylua.toml` consistent with that preference.
Project formatter settings remain authoritative; CSharpier projects need
`useTabs: true` if formatted C# should also use tabs. Do not silently rewrite
another project's indentation rules. Format Lua with the repo's StyLua config.

## Theme modes and sharing

Neovim's `config.theme` module owns fixed/Omarchy palette modes. The default is
fixed Catppuccin Mocha. `:PhtevenTheme` opens the picker and `<leader>uO` toggles.
Choices are saved under Neovim's state directory, outside the shared checkout.
Do not replace the mode controller with a symlink to Omarchy's generated
`neovim.lua` plugin spec. Auto mode reads flat `colors.toml` data from current
Omarchy state/config paths and maps it to Catppuccin; it does not execute the
system theme's Lua or download extra theme plugins.

Use **phteven bindings** for this collection, with Amethyst credited as its
inspiration. Swap is the featured workflow. Keep README, visual cards, and the
field guide aligned with the actual keybindings. Edit SVG artwork as source;
keep generated preview PNGs outside the repository.

## Integration and verification

Back up any existing files or directories before replacing them with symlinks,
including nested Git metadata. Keep backups outside this repository and record
their location. Merge existing personal overrides when needed. Skip paths
already linked to this checkout; leave an existing installation working if a
dependency is unavailable. Respect existing XDG/ZDOTDIR overrides when deciding
which paths the applications actually load.

Check Zsh syntax and startup, Neovim startup, and tmux config loading. Verify
tmux in a separate server so existing sessions are unaffected. On Omarchy,
reload Hyprland and check `hyprctl configerrors`. Verify that active paths resolve
into this checkout, and report anything that could not be checked on the host.

After changing theme behavior, run `nvim --headless -i NONE -c 'luafile tests/theme.lua'`
with this config active. It uses temporary fixtures and leaves saved user
preferences untouched. Real Omarchy session checks still belong on Linux.

Do not reintroduce collection scripts, automatic setup scripts, duplicate
snapshots, or starter examples. Keep the Neovim license and plugin lockfile.
