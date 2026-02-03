#!/bin/bash
# Claude Code Notify - Configuration
# Users can override these settings by creating ~/.claude-code-notify/config.sh

# Notification settings
NOTIFY_ENABLED=true
NOTIFY_SOUND_ENABLED=true
NOTIFY_TIMEOUT=5000  # milliseconds (Linux only)

# Which notifications to show
NOTIFY_ON_ATTENTION=true
NOTIFY_ON_COMPLETE=true
NOTIFY_ON_ERROR=true

# Custom titles (leave empty for defaults)
CUSTOM_TITLE=""

# Sound settings (macOS)
MACOS_SOUND_ATTENTION="default"
MACOS_SOUND_COMPLETE="Glass"
MACOS_SOUND_ERROR="Basso"

# Urgency levels (Linux: low, normal, critical)
LINUX_URGENCY_ATTENTION="normal"
LINUX_URGENCY_COMPLETE="low"
LINUX_URGENCY_ERROR="critical"

# Load user configuration if it exists
if [ -f "$HOME/.claude-code-notify/config.sh" ]; then
    source "$HOME/.claude-code-notify/config.sh"
fi
