#!/bin/bash
# Claude Code Notify - Task completion notification
# Sends desktop notification when Claude finishes a response (macOS only)

set -e

# Get the script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source configuration
source "$SCRIPT_DIR/config.sh"

# Check if notifications are enabled
if [ "$NOTIFY_ENABLED" != "true" ] || [ "$NOTIFY_ON_COMPLETE" != "true" ]; then
    exit 0
fi

# Verify we're on macOS
if [ "$(uname -s)" != "Darwin" ]; then
    echo "This plugin only supports macOS" >&2
    exit 1
fi

TITLE="${CUSTOM_TITLE:-Claude Code}"
MESSAGE="Task completed"

# macOS - use osascript for native notifications
if [ "$NOTIFY_SOUND_ENABLED" = "true" ] && [ -n "$MACOS_SOUND_COMPLETE" ]; then
  osascript -e "display notification \"$MESSAGE\" with title \"$TITLE\" sound name \"$MACOS_SOUND_COMPLETE\"" 2>/dev/null || true
else
  osascript -e "display notification \"$MESSAGE\" with title \"$TITLE\"" 2>/dev/null || true
fi

exit 0
