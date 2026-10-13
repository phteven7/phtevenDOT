# phtevenDOT

Personal tmux, Neovim/LazyVim, Zsh/Powerlevel10k, and Amethyst-style Hyprland
configs. Clone this repo somewhere permanent, then ask your agent to integrate
it using `AGENTS.md`. There are no setup or collection scripts.

```sh
git clone https://github.com/phteven7/phtevenDOT.git ~/phtevenDOT
```

Suggested agent request:

> Integrate the configs in ~/phtevenDOT for this machine. Follow AGENTS.md,
> preserve my existing configs, and point their active paths into this repo.

| Config | Repo location | Active location |
| --- | --- | --- |
| tmux / Catppuccin Mocha | `tmux/tmux.conf` | `~/.tmux.conf` |
| Neovim / LazyVim / C# | `nvim/` | `~/.config/nvim` |
| Oh My Zsh | `zsh/zshrc` | `~/.zshrc` |
| Powerlevel10k | `zsh/p10k.zsh` | `~/.p10k.zsh` |
| macOS login PATH | `zsh/zprofile` | `~/.zprofile` on macOS |
| Amethyst keybindings | `config/hypr/bindings.lua` | `~/.config/hypr/bindings.lua` |
| Amethyst layout | `config/hypr/looknfeel.lua` | `~/.config/hypr/looknfeel.lua` |

`dependencies.json` records upstream dependency URLs, installation locations,
and known-working commits. Neovim's plugins are recorded in `nvim/lazy-lock.json`.
Upstream software, generated data, and machine-specific VM snapshots stay outside
this repo. Keep the checkout in place while its configs are linked.

Amethyst requires Lua-based Omarchy/Hyprland with the `hl` and `o` APIs. It uses
a centered master at 55% width; new windows become slaves. Omarchy's styling is
inherited. On an Apple keyboard, Option is Alt and Command is Super.

| Shortcut | Action |
| --- | --- |
| Alt + Shift + H/J/K/L | Focus left/down/up/right |
| Alt + Shift + Return | Swap with master |
| Alt + Ctrl + Shift + H/L | Shrink/grow master width |
| Alt + Ctrl + Shift + Return | Reset master width to 55% |
