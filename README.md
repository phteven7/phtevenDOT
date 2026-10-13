![phtevenDOT — Good colors. Real tabs. Keys that feel right.](assets/banner.svg)

<div align="center">

**A personal terminal setup, ready to make your own.**

[Bring it home](#bring-it-home) · [The configs](#the-configs) · [Key moves](#key-moves) · [Agent guide](AGENTS.md)

</div>

## The configs

Catppuccin Mocha, Vim motions, a two-line shell prompt, and an Amethyst-style
centered master layout. Small, readable configs with their dependencies kept
outside the checkout.

| | What you get | Source → active path |
| --- | --- | --- |
| **Neovim** | LazyVim, transparent Mocha, C# tooling, real tabs | [`nvim/`](nvim/) → `~/.config/nvim` |
| **tmux** | Rounded Mocha tabs, top status bar, Vim pane navigation | [`tmux/tmux.conf`](tmux/tmux.conf) → `~/.tmux.conf` |
| **Zsh** | Oh My Zsh, autosuggestions, syntax highlighting | [`zsh/zshrc`](zsh/zshrc) → `~/.zshrc` |
| **Prompt** | Powerlevel10k, Git status, contextual right prompt | [`zsh/p10k.zsh`](zsh/p10k.zsh) → `~/.p10k.zsh` |
| **macOS** | Homebrew and optional Toolbox paths | [`zsh/zprofile`](zsh/zprofile) → `~/.zprofile` |
| **Hyprland** | Amethyst bindings and centered master at 55% | [`config/hypr/`](config/hypr/) → matching files in `~/.config/hypr/` |

## Bring it home

Clone somewhere permanent:

```sh
git clone https://github.com/phteven7/phtevenDOT.git ~/phtevenDOT
```

Then give your agent this request:

> Integrate ~/phtevenDOT for this machine. Follow AGENTS.md, back up existing
> configs, and link the active paths to this checkout. Keep my machine-specific
> settings and verify that the applications load correctly.

Edit here; the active configs point back here. Keep the checkout in place.
Integration is guided by [`AGENTS.md`](AGENTS.md); this repo has no setup scripts.

**macOS & Linux:** Git, Neovim, tmux, Zsh, and a Nerd Font. Neovim also uses
ripgrep, fd, a C compiler, and gitui; C# tooling needs a .NET SDK. Upstream URLs,
expected paths, and known-working revisions live in [`dependencies.json`](dependencies.json).
Neovim installs its plugins from [`lazy-lock.json`](nvim/lazy-lock.json).

**Omarchy:** The Hyprland overrides require a Lua-based installation with the
`hl` and `o` APIs. They load after Omarchy's defaults. Monitor, input, autostart,
and VM settings belong to the host installation.

## Key moves

<details>
<summary><strong>Neovim · editing and buffers</strong></summary>

`Leader` is Space. These are personal additions to LazyVim's default keymaps.

| Keys | Action |
| --- | --- |
| Visual `<` / `>` | Indent and keep the selection |
| Visual `J` / `K` | Move selected lines down / up |
| `Leader b n` / `Leader b p` | Next / previous buffer |
| `Esc` | Clear search highlighting |

Real tab characters are the editor default: two columns normally, four for C#.
Project EditorConfig and formatter settings take precedence. For CSharpier,
set [`"useTabs": true`](https://csharpier.com/docs/Configuration) in a project's
`.csharpierrc.json` when you want formatted C# to keep tabs too. The repo's
EditorConfig and StyLua settings use tabs for Lua.

</details>

<details>
<summary><strong>tmux · panes and sessions</strong></summary>

`Prefix` is Ctrl + Space. Press it before these keys.

| Keys | Action |
| --- | --- |
| `h` / `j` / `k` / `l` | Focus a pane |
| `H` / `J` / `K` / `L` | Resize a pane |
| `\|` / `-` | Split side by side / top and bottom |
| `,` / `$` | Rename window / session |
| `r` | Reload the config |

Mouse support and Vim copy mode are enabled. Window names stay as you set them.

</details>

<details>
<summary><strong>Amethyst · centered master</strong></summary>

On Apple keyboards, Option is Alt and Command is Super. New windows become
slaves; the master centers with at least two slaves and otherwise sits left.

| Keys | Action |
| --- | --- |
| Alt + Shift + H/J/K/L | Focus left / down / up / right |
| Alt + Shift + Return | Swap with master |
| Alt + Ctrl + Shift + H/L | Shrink / grow master by 5 percentage points |
| Alt + Ctrl + Shift + Return | Reset master width to 55% |

Check for conflicts with existing bindings before integrating. Reload with
`hyprctl reload` and verify with `hyprctl configerrors`.

</details>

---

Built on [LazyVim](https://github.com/LazyVim/LazyVim),
[Catppuccin](https://github.com/catppuccin),
[Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh), and
[Powerlevel10k](https://github.com/romkatv/powerlevel10k).
Neovim's inherited [Apache 2.0 license](nvim/LICENSE) is preserved.
