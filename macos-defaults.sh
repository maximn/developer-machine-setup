#!/usr/bin/env bash
# Optional macOS settings that suit development. Read through and delete what you don't want.
# Some settings (key repeat) only apply after you log out and back in.
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

killall Finder Dock SystemUIServer 2>/dev/null || true
echo "Done. Log out and back in for the keyboard settings to take effect."
