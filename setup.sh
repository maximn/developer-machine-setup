#!/usr/bin/env bash
# Sets up a new Mac from this repo. Safe to re-run: each step checks before it changes anything.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

step() { printf '\n\033[1;34m==> %s\033[0m\n' "$*"; }
note() { printf '    %s\n' "$*"; }

# Writes through symlinks, so dotfiles managed elsewhere stay linked.
prepend_to_file() {  # prepend_to_file <file> <text>
  local file="$1" text="$2" tmp
  tmp="$(mktemp)"
  { printf '%s\n' "$text"; cat "$file"; } > "$tmp"
  cat "$tmp" > "$file"
  rm -f "$tmp"
}

find_brew() {
  command -v brew 2>/dev/null && return
  local candidate
  for candidate in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    [[ -x "$candidate" ]] && { echo "$candidate"; return; }
  done
  return 1
}

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "This script is for macOS." >&2
  exit 1
fi

step "Xcode Command Line Tools"
if xcode-select -p >/dev/null 2>&1; then
  note "already installed"
else
  xcode-select --install
  echo "Finish the Command Line Tools install in the dialog that opened, then re-run ./setup.sh"
  exit 1
fi

step "Homebrew"
if BREW="$(find_brew)"; then
  note "already installed"
else
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  BREW="$(find_brew)"
fi
eval "$("$BREW" shellenv)"
touch "$HOME/.zprofile"
if ! grep -q 'brew shellenv' "$HOME/.zprofile"; then
  # shellcheck disable=SC2016  # $(...) is meant to be written literally
  printf '\neval "$(%s shellenv)"\n' "$BREW" >> "$HOME/.zprofile"
  note "added Homebrew to ~/.zprofile"
fi

step "Apps and tools from the Brewfile"
brew bundle --file="$REPO_DIR/Brewfile"

step "Shell config"
ZSHRC_LINE="source \"$REPO_DIR/dotfiles/zshrc\""
touch "$HOME/.zshrc"
if grep -qxF "$ZSHRC_LINE" "$HOME/.zshrc"; then
  note "already sourced from ~/.zshrc"
else
  printf '\n%s\n' "$ZSHRC_LINE" >> "$HOME/.zshrc"
  note "added to the end of ~/.zshrc"
fi

step "Git config"
GIT_INCLUDE="$REPO_DIR/dotfiles/gitconfig"
touch "$HOME/.gitconfig"
if git config --global --get-all include.path 2>/dev/null | grep -qxF "$GIT_INCLUDE"; then
  note "already included from ~/.gitconfig"
else
  # At the top, so anything already in ~/.gitconfig takes precedence.
  prepend_to_file "$HOME/.gitconfig" "$(printf '[include]\n\tpath = "%s"\n' "$GIT_INCLUDE")"
  note "included at the top of ~/.gitconfig"
fi

SSH_KEY="$HOME/.ssh/id_ed25519.pub"
if [[ -n "$(git config --global user.signingkey || true)" ]]; then
  note "commit signing already configured"
elif [[ -f "$SSH_KEY" ]]; then
  git config --global gpg.format ssh
  git config --global user.signingkey "$SSH_KEY"
  git config --global commit.gpgsign true
  note "commits will be signed with $SSH_KEY"
  note "add it to GitHub as a signing key: gh ssh-key add $SSH_KEY --type signing"
else
  note "no SSH key yet, so commit signing is off. Create one, then re-run ./setup.sh:"
  note "  ssh-keygen -t ed25519 -C \"you@example.com\""
fi

step "Docker CLI plugins (compose, buildx)"
DOCKER_CONFIG_FILE="$HOME/.docker/config.json"
PLUGIN_DIR="$HOMEBREW_PREFIX/lib/docker/cli-plugins"
if ! command -v docker >/dev/null; then
  note "docker CLI not installed, skipping"
elif [[ ! -f "$DOCKER_CONFIG_FILE" ]]; then
  mkdir -p "$HOME/.docker"
  printf '{\n  "cliPluginsExtraDirs": ["%s"]\n}\n' "$PLUGIN_DIR" > "$DOCKER_CONFIG_FILE"
  note "created $DOCKER_CONFIG_FILE"
elif grep -qF "$PLUGIN_DIR" "$DOCKER_CONFIG_FILE"; then
  note "already configured"
elif command -v jq >/dev/null; then
  tmp="$(mktemp)"
  jq --arg dir "$PLUGIN_DIR" '.cliPluginsExtraDirs = ((.cliPluginsExtraDirs // []) + [$dir])' \
    "$DOCKER_CONFIG_FILE" > "$tmp"
  cat "$tmp" > "$DOCKER_CONFIG_FILE"
  rm -f "$tmp"
  note "added $PLUGIN_DIR to $DOCKER_CONFIG_FILE"
else
  note "add \"cliPluginsExtraDirs\": [\"$PLUGIN_DIR\"] to $DOCKER_CONFIG_FILE"
fi

step "Done. Next steps:"
note "- Open a new terminal (Ghostty) to load the shell config"
note "- Log in to GitHub: gh auth login"
note "- Start Docker: colima start (or open OrbStack if you use it instead)"
note "- Optional macOS tweaks: ./macos-defaults.sh"
if [[ -z "$(git config --global user.email || true)" ]]; then
  note "- Set your git identity: git config --global user.name \"Your Name\""
  note "                         git config --global user.email \"you@example.com\""
fi
