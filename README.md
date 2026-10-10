# developer-machine-setup

[![Sponsor](https://readme.cash/i/i8wm8qc91d.svg)](https://readme.cash/c/i8wm8qc91d)

My recommended developer setup for a new Mac (Apple Silicon or Intel), installable with one script.

*Generally, I prefer free/open-source software if there's one available.*

## Quick start

1. Install Apple's Command Line Tools (this also gives you `git`):

   ```sh
   xcode-select --install
   ```

2. Clone this repo and run the setup script:

   ```sh
   git clone https://github.com/maximn/developer-machine-setup.git ~/developer-machine-setup
   cd ~/developer-machine-setup
   ./setup.sh
   ```

3. Optional: apply developer-friendly macOS settings (read [the script](macos-defaults.sh) first, it's short):

   ```sh
   ./macos-defaults.sh
   ```

Want a different selection? Edit the [`Brewfile`](Brewfile) before running `./setup.sh`: comment out what you don't want, uncomment what you do.

### What `setup.sh` does

- Installs [Homebrew](https://brew.sh/) if it's missing and adds it to your `PATH` in `~/.zprofile`
- Installs everything in the [`Brewfile`](Brewfile) with `brew bundle`. Apps you already installed yourself, like Chrome, are handed over to Homebrew rather than installed again
- Adds one `source` line to the end of `~/.zshrc` that loads [`dotfiles/zshrc`](dotfiles/zshrc)
- Adds a `config-file` line to `~/.config/ghostty/config` that loads [`dotfiles/ghostty`](dotfiles/ghostty), which makes **Cmd+K** clear the screen inside herdr and tmux too, and makes the left Option key work as Alt
- Creates `~/.config/herdr/config.toml` from [`dotfiles/herdr.toml`](dotfiles/herdr.toml) if you don't have one, or adds the tab shortcut to the one you have
- Adds an include to the top of `~/.gitconfig` that loads [`dotfiles/gitconfig`](dotfiles/gitconfig)
- Turns on commit signing with your SSH key, if you have one and haven't set up signing already
- Lets the Homebrew `docker` CLI find the `compose` and `buildx` plugins

If something in the `Brewfile` fails to install, the other steps still run and the failures are listed at the end. It never overwrites your existing files, and it's safe to run again: that's also how you install anything you add to the `Brewfile` later. Your own settings in `~/.zshrc` and `~/.gitconfig` still apply, and those in `~/.gitconfig` take precedence. The config is loaded from the cloned repo, so keep it where you cloned it.

## What gets installed

### Terminal and shell

| Tool | What it's for |
| --- | --- |
| [Ghostty](https://ghostty.org/) | Fast, native, GPU-accelerated terminal (replaces iTerm) |
| [Starship](https://starship.rs/) | Fast, informative prompt. Replaces oh-my-zsh themes without the slow startup |
| [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) | Suggests commands from your history as you type. Press → to accept |
| [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) | Colors commands as you type, so typos show up red before you press Enter |

zsh is already the default shell on macOS, so there's nothing to install for it.

### Command-line tools

| Tool | What it's for |
| --- | --- |
| [git](https://git-scm.com/) | Newer than the version Apple ships |
| [gh](https://cli.github.com/) | GitHub from the terminal: PRs, issues, `gh auth login` |
| [delta](https://github.com/dandavison/delta) | Readable, syntax-highlighted `git diff` and `git log -p` |
| [fzf](https://github.com/junegunn/fzf) | Fuzzy finder. **Ctrl-R** searches history, **Ctrl-T** finds files |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | A smarter `cd`: jump with `z <partial-name>`, or pick interactively with `zi` |
| [btop](https://github.com/aristocratos/btop) | A better `top` |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | Very fast code search: `rg` |
| [fd](https://github.com/sharkdp/fd) | A simpler, faster `find` |
| [bat](https://github.com/sharkdp/bat) | `cat` with syntax highlighting |
| [eza](https://github.com/eza-community/eza) | Modern `ls` (`ls`, `ll` and `la` use it) |
| [jq](https://jqlang.org/) | Query and format JSON |
| [mise](https://mise.jdx.dev/) | Installs and switches Node, Python, Java and other runtime versions per project: `mise use node@22` |

### Containers

Both replace Docker Desktop: they run a small Linux VM so `docker` commands work. Pick one.

| Tool | What it's for |
| --- | --- |
| [Colima](https://github.com/abiosoft/colima) | **Installed by default.** Open source and free for everyone. Command line only: `colima start` |
| [OrbStack](https://orbstack.dev/) | Polished Mac app that starts faster and uses less memory and battery. Free for personal use, paid for commercial use. To use it instead, uncomment `orbstack` in the `Brewfile` and comment out the `colima` and `docker*` lines |

### AI coding agents

| Tool | What it's for |
| --- | --- |
| [herdr](https://herdr.dev/) | Keeps your AI coding agents running in the background across projects, even when you disconnect |

The `Brewfile` also has commented-out lines for the Claude Code and Codex CLI agents.

herdr works like tmux: press **Ctrl+b**, let go, then the action key. Press **Ctrl+b ?** to list them all. The ones you'll use most:

| Keys | What it does |
| --- | --- |
| **Ctrl+b c** | Create a new tab |
| **Ctrl+b n** / **Ctrl+b p** | Next / previous tab |
| **Option+1** … **Option+9** | Jump straight to tab 1-9 (set up by `setup.sh`; uses the left Option key) |
| **Ctrl+b v** | Split into two panes side by side |
| **Ctrl+b -** | Split into two panes, one above the other |
| **Ctrl+b h** / **j** / **k** / **l** | Move to the pane left / below / above / right |
| **Ctrl+b z** | Zoom the current pane to fill the tab; press again to restore the layout |

macOS uses **Ctrl+1** … **Ctrl+9** for switching desktops, which is why tab switching uses Option. For that, `setup.sh` makes Ghostty treat the left Option key as Alt; the right Option key still types characters like € and ñ.

### Apps

| App | What it's for |
| --- | --- |
| [Chrome](https://www.google.com/chrome/) | Browser. I also like [Arc](https://arc.net/), but it only gets maintenance updates since its developer moved on to Dia |
| [Raycast](https://www.raycast.com/) | A Spotlight killer: app launcher, snippets, and much more |
| [Maccy](https://maccy.app/) | Clipboard history manager |
| [Rectangle](https://rectangleapp.com/) | Snap windows into halves and thirds, and move them between monitors with keyboard shortcuts |
| [Loom](https://www.loom.com/) | Record your screen while narrating. Great for async explanations that are more complex than a quick video |
| [Bitwarden](https://bitwarden.com/) | Open-source password manager |
| [IntelliJ IDEA](https://www.jetbrains.com/idea/download/) | Code editor. For a lighter editor, [Zed](https://zed.dev/) and [VS Code](https://code.visualstudio.com/) are commented out in the `Brewfile` |

Installed by hand, since it isn't available through Homebrew:

- [Monosnap](https://monosnap.ai/download/mac) - screenshots and short videos with annotations. For quick captures, macOS's built-in **Cmd+Shift+5** also works.

## Git commit signing

`setup.sh` signs commits with your SSH key (`~/.ssh/id_ed25519`), which is simpler than GPG. If you don't have a key yet:

```sh
ssh-keygen -t ed25519 -C "you@example.com"
./setup.sh                                                  # turns on signing
gh ssh-key add ~/.ssh/id_ed25519.pub --type authentication  # for git push over SSH
gh ssh-key add ~/.ssh/id_ed25519.pub --type signing         # "Verified" badge on GitHub
```

## Keeping up to date

```sh
brew update && brew upgrade   # upgrade everything installed with Homebrew
git pull && ./setup.sh        # pick up changes to this repo
```
