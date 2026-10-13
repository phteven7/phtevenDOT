# Integrating phtevenDOT

This repository is the source for personal configs. Integration is a guided
conversation: the user chooses what to install, then the agent handles the
selected dependencies, backups, links, and verification. Resolve the checkout's
actual absolute path; do not assume a username or clone location.

## Start with scope: Full or Custom

These instructions apply when asked to integrate/install configs on a machine,
not when asked to edit, review, or document this repository.

Before downloading dependencies, replacing configs, or creating links, inspect
the host read-only and establish the user's selection. Follow the prompts and
component boundaries in [the integration flow](docs/integration.md).

- If the user has not selected a scope, ask: **"Full or Custom? Full integrates
  every compatible config; Custom lets you pick the components."** Wait for an
  answer. Do not assume Full, and do not treat a preselected UI option or silence
  as a submitted choice.
- For Custom, ask which components they want: **Hyprland/phteven bindings,
  tmux, Neovim, Zsh + Powerlevel10k, macOS login paths, or Powerlevel10k only.**
  Explain which are available on this host. Accept a free-text list if the UI
  cannot offer multiple selections.
- An explicit request such as **"tmux only"**, **"Neovim and Hyprland"**, or
  **"Full"** already establishes scope. Retain selections from the conversation;
  do not repeat the mode question or ask again for the same authorization.
- Full means all compatible configs in this repo, with the complete Zsh setup
  covering Powerlevel10k. It does not include an OS/Omarchy installation,
  unrelated applications, or a change to the user's default login shell.
- A selected component includes its necessary dependencies. Never install or
  alter an unselected component because its files happen to be in this repo.
  If the selection is empty, canceled, or only a request for a preview, make no
  installation changes.

For selected Neovim on a host with an Omarchy palette, ask whether it should use
**Fixed** or **Follow Omarchy**, unless that preference was already given. On
other hosts, explain that Fixed is the available default. Keep this preference
in local Neovim state, not in shared config source.

Summarize the selected components, exact destinations, missing dependencies,
backup locations, and any incompatibilities. Then carry out the user's selected
scope; do not add a second approval prompt for the same choice. If an unavailable
component needs a different setup, explain it and ask only about that change.
Continue independent work on the other selected components.

## Config paths

Link only the paths belonging to selected components. On macOS and Linux:

- `tmux/tmux.conf` → `~/.tmux.conf`
- `nvim/` → `~/.config/nvim`
- `zsh/zshrc` → `~/.zshrc`
- `zsh/p10k.zsh` → `~/.p10k.zsh`

For selected macOS login paths, link `zsh/zprofile` → `~/.zprofile`. It initializes an installed
Homebrew and adds optional JetBrains Toolbox and personal executable paths.

For selected phteven bindings on Lua-based Omarchy, link these individual files:

- `config/hypr/bindings.lua` → `~/.config/hypr/bindings.lua`
- `config/hypr/looknfeel.lua` → `~/.config/hypr/looknfeel.lua`

Keep machine-specific Hyprland monitor, input, autostart, and VM integrations
in place. Check that the existing `hyprland.lua` loads `hypr.bindings` and
`hypr.looknfeel` after Omarchy defaults. These overrides require the `hl` and `o`
Lua APIs and cannot be installed as standard Hyprland `.conf` files. Inspect
existing keybindings for conflicts before adding the phteven bindings.

## Dependencies

Use `dependencies.json` for upstream URLs, expected paths, and known-working
revisions. Scope dependencies to the selected components: tmux needs its
Catppuccin theme; Zsh needs Oh My Zsh, its two custom plugins, and Powerlevel10k;
Neovim manages its own plugins. A tmux-only install must not install Neovim or
Zsh. Powerlevel10k-only integration uses the existing Zsh setup and merges its
theme/prompt references; it must not replace the user's entire `.zshrc`.
If that shell does not use Oh My Zsh, source the installed Powerlevel10k theme
directly rather than adding Oh My Zsh solely for the prompt.

Keep existing working installations. Install missing dependencies outside the repo;
do not copy their source or generated caches into this checkout.

The corresponding tools are Git and the selected application's executable.
Neovim also uses ripgrep, fd, a C compiler, and gitui. A .NET SDK is needed for
its C# tools, not for basic editing; offer it when the user wants C# support.
Mason manages the Roslyn server and CSharpier. Explain Nerd Font requirements
for selected prompt/status features without changing terminal settings silently.
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

Verify only selected components: Zsh syntax/startup, Neovim startup, tmux config
loading, or Hyprland reload and `hyprctl configerrors`, as applicable. Verify
tmux in a separate server so existing sessions are unaffected. Check that
selected active paths resolve into this checkout (or document the small merge
used for prompt-only integration). Report installed, skipped, and blocked
components separately, including backups and anything unverified on this host.

After changing theme behavior, run `nvim --headless -i NONE -c 'luafile tests/theme.lua'`
with this config active. It uses temporary fixtures and leaves saved user
preferences untouched. Real Omarchy session checks still belong on Linux.

Do not reintroduce collection scripts, automatic setup scripts, duplicate
snapshots, or starter examples. Keep the Neovim license and plugin lockfile.
