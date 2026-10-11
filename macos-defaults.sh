#!/usr/bin/env bash
# Optional macOS settings that suit development. Read through and delete what you don't want.
# Some settings (key repeat) only apply after you log out and back in. Turning on
# Touch ID for sudo asks for your password.
set -euo pipefail

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "This script is for macOS." >&2
  exit 1
fi

# Keyboard: fast key repeat, and hold a key to repeat it instead of showing accents
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Keyboard: no "smart" quotes and dashes, which break code pasted into terminals
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Finder: show hidden files, all file extensions, the path bar, and list view by default
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder FXPreferredViewStyle -string Nlsv

# Don't leave .DS_Store files on network and USB drives
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Dock: auto-hide, and no "recent apps" section
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock show-recents -bool false

# Screenshots go to ~/Screenshots instead of the Desktop
mkdir -p "$HOME/Screenshots"
defaults write com.apple.screencapture location -string "$HOME/Screenshots"

# Touch ID for sudo. sudo_local survives macOS updates, unlike /etc/pam.d/sudo. pam-reattach, from the Brewfile, makes it work inside herdr and tmux.
SUDO_LOCAL=/etc/pam.d/sudo_local
REATTACH=""
for prefix in "${HOMEBREW_PREFIX:-}" /opt/homebrew /usr/local; do
  if [[ -n "$prefix" && -f "$prefix/lib/pam/pam_reattach.so" ]]; then
    REATTACH="$prefix/lib/pam/pam_reattach.so"
    break
  fi
done
if ! grep -qs sudo_local /etc/pam.d/sudo; then
  echo "Touch ID for sudo needs macOS 14 (Sonoma) or newer, skipped."
else
  if ! grep -qsE '^[[:space:]]*auth.*pam_tid\.so' "$SUDO_LOCAL"; then
    echo 'auth       sufficient     pam_tid.so' | sudo tee -a "$SUDO_LOCAL" >/dev/null
    echo "sudo now accepts Touch ID."
  fi
  if [[ -z "$REATTACH" ]]; then
    echo "For Touch ID inside herdr and tmux: brew install pam-reattach, then re-run this script."
  elif ! grep -qsE '^[[:space:]]*auth.*pam_reattach\.so' "$SUDO_LOCAL"; then
    # It has to come before pam_tid.so, so it goes at the top.
    tmp="$(mktemp)"
    { printf 'auth       optional       %s ignore_ssh\n' "$REATTACH"; cat "$SUDO_LOCAL"; } > "$tmp"
    # shellcheck disable=SC2024  # only the write needs sudo; the temp file is ours
    sudo tee "$SUDO_LOCAL" < "$tmp" >/dev/null
    rm -f "$tmp"
    echo "Touch ID for sudo now works inside herdr and tmux too."
  fi
fi

killall Finder Dock SystemUIServer 2>/dev/null || true
echo "Done. Log out and back in for the keyboard settings to take effect."
