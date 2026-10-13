# Choose your setup

[← Back to phtevenDOT](../README.md)

Clone the repo and ask an agent to integrate it. The agent asks what you want,
checks your machine, and installs the selected configs. This is a conversational
workflow described in [`AGENTS.md`](../AGENTS.md); there is no installer script.

## 1. Full or Custom?

> **How would you like to integrate phtevenDOT?**
>
> **Full** — every config compatible with this machine.
>
> **Custom** — choose just the pieces you want.

Full on macOS covers Neovim, tmux, Zsh + Powerlevel10k, and macOS login paths.
On Linux it covers the terminal/editor configs, plus phteven bindings when a
compatible Lua-based Omarchy/Hyprland installation is present. Unsupported
components are explained and skipped; Full does not install an OS or desktop.

Already know your selection? Say **"tmux only"** or **"Neovim and Hyprland"**
in your initial request. The agent uses that scope directly.

## 2. Pick your pieces

For Custom, the agent presents the available components and accepts multiple
choices or a typed list.

| Component | What it integrates | Requirements and boundaries |
| --- | --- | --- |
| **Hyprland / phteven bindings** | Focus, Swap, resize, reset, centered-master layout | Existing Lua-based Omarchy with the `hl`/`o` APIs. Links two override files; preserves monitor, input, and autostart settings. |
| **tmux** | Mocha status bar, pane navigation, splits, copy mode | tmux and its Catppuccin theme. No shell/editor replacement. |
| **Neovim** | LazyVim, tab indentation, editor keys, theme controls | Neovim and editor dependencies. C# tools are useful when you have a .NET SDK; ask about that separately if needed. |
| **Zsh + Powerlevel10k** | Oh My Zsh, custom plugins, prompt configuration | Zsh and its recorded dependencies. Links `.zshrc` and `.p10k.zsh`; does not change the default login shell. |
| **macOS login paths** | Homebrew initialization and optional Toolbox/personal paths | macOS only. Links `.zprofile`; does not install Homebrew or JetBrains Toolbox. |
| **Powerlevel10k only** | The prompt, integrated with your existing Zsh | Existing Zsh. Links `.p10k.zsh` and merges the required theme/source references into the current shell config. Leaves unrelated shell preferences intact. |

Zsh + Powerlevel10k already includes the prompt. The prompt-only choice is an
alternative for people keeping their existing shell setup.

## 3. Choose your Neovim theme

If Neovim is selected and an Omarchy palette is available, the agent asks:

> **Should Neovim keep a fixed theme or follow Omarchy?**
>
> **Fixed** — keep a favorite installed colorscheme; starts with Mocha.
>
> **Follow Omarchy** — update with the active system palette.

An existing preference is retained unless you ask to change it. On machines
without an Omarchy palette, Fixed is the default. You can change your choice
later with `:PhtevenTheme`; it is saved locally, outside this shared repo.

## 4. The agent integrates your selection

Before changing anything, the agent explains the concrete plan: selected
components, destinations, missing dependencies, and where originals will be
backed up. Your selection authorizes that scope; the agent proceeds without
asking you to approve the same choice again.

It installs only the selected components and their dependencies, preserves
existing configs in backups, and points the active files into this checkout.
If a component is incompatible, the agent explains the issue and continues
with the independent selected components. It asks before expanding the scope
to a different setup.

The finish report lists what was integrated, what was skipped, anything still
blocked, backup locations, and the relevant verification results.

## Example requests

**Let the agent guide me:**

> Integrate ~/phtevenDOT for this machine. Follow AGENTS.md and ask me whether
> I want a Full or Custom setup before installing anything.

**Only the window workflow:**

> Integrate only the Hyprland/phteven bindings from ~/phtevenDOT. Keep my
> terminal, shell, and Neovim configs as they are.

**Editor and multiplexer:**

> Integrate Neovim and tmux from ~/phtevenDOT. Use a fixed Neovim theme.

**Everything compatible:**

> Do a Full integration of ~/phtevenDOT. Follow Omarchy's palette in Neovim
> if it is available. Back up my current configs first.

**Just inspect:**

> Inspect ~/phtevenDOT and show a Custom integration plan for tmux only.
> Do not install or modify anything yet.
