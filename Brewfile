# Everything setup.sh installs. Run on its own with: brew bundle --file=Brewfile
# Comment out anything you don't want before running.

# Take over apps you already installed by hand (like Chrome) instead of failing
# with "It seems there is already an App at ...".
cask_args adopt: true

# --- Shell & terminal ---
cask "ghostty"                  # fast, native, GPU-accelerated terminal
brew "starship"                 # fast, minimal prompt (replaces oh-my-zsh themes)
brew "zsh-autosuggestions"      # fish-style suggestions from your history
brew "zsh-syntax-highlighting"  # highlights commands as you type

# --- Command-line tools ---
brew "git"
brew "gh"                       # GitHub CLI
brew "git-delta"                # readable, syntax-highlighted git diffs
brew "fzf"                      # fuzzy finder (Ctrl-R history, Ctrl-T files)
brew "zoxide"                   # smarter cd: `z <partial-name>`
brew "btop"                     # a better top
brew "ripgrep"                  # fast grep: `rg`
brew "fd"                       # fast, friendly find
brew "bat"                      # cat with syntax highlighting
brew "eza"                      # modern ls
brew "jq"                       # JSON on the command line
brew "mise"                     # Node/Python/Java/... version manager
brew "pam-reattach"             # Touch ID for sudo inside herdr and tmux (see macos-defaults.sh)

# --- Containers (pick one) ---
brew "colima"                   # open-source Docker runtime (CLI only)
brew "docker"                   # docker CLI, used with Colima
brew "docker-compose"
brew "docker-buildx"
# cask "orbstack"               # polished alternative to Colima; free for personal use only

# --- AI coding agents ---
brew "herdr"                    # keeps coding agents running in the background
# cask "claude-code"
# cask "codex"

# --- Apps ---
cask "google-chrome"
# cask "arc"                    # maintenance mode since 2025
cask "raycast"                  # Spotlight replacement
cask "maccy"                    # clipboard manager
cask "rectangle"                # window snapping
cask "loom"                     # narrated screen recordings
cask "bitwarden"                # open-source password manager
cask "tailscale-app"            # private network to reach your other machines
cask "intellij-idea"
# cask "zed"                    # lightweight open-source editor
# cask "visual-studio-code"
