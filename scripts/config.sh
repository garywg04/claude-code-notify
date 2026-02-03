#!/bin/bash
# Claude Code Notify - Configuration (macOS only)
# Users can override these settings by creating ~/.claude-code-notify/config.sh

# Notification settings
NOTIFY_ENABLED=true

# Which notifications to show
NOTIFY_ON_ATTENTION=true
NOTIFY_ON_COMPLETE=true
NOTIFY_ON_ERROR=true

# Custom title (leave empty for default "Claude Code")
CUSTOM_TITLE=""

# Load user configuration if it exists
if [ -f "$HOME/.claude/notify-config.sh" ]; then
    source "$HOME/.claude/notify-config.sh"
fi
