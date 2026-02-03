#!/bin/bash
# Claude Code Notify - Configuration (macOS only)
# Users can override these settings by creating ~/.claude-code-notify/config.sh

# Notification settings
NOTIFY_ENABLED=true
NOTIFY_SOUND_ENABLED=true

# Which notifications to show
NOTIFY_ON_ATTENTION=true
NOTIFY_ON_COMPLETE=true
NOTIFY_ON_ERROR=true

# Custom title (leave empty for default "Claude Code")
CUSTOM_TITLE=""

# macOS sound names (see /System/Library/Sounds for options)
# Available: Basso, Blow, Bottle, Frog, Funk, Glass, Hero, Morse, Ping, Pop, Purr, Sosumi, Submarine, Tink
MACOS_SOUND_ATTENTION="default"  # Use "default" for no sound
MACOS_SOUND_COMPLETE="Glass"
MACOS_SOUND_ERROR="Basso"

# Load user configuration if it exists
if [ -f "$HOME/.claude-code-notify/config.sh" ]; then
    source "$HOME/.claude-code-notify/config.sh"
fi
