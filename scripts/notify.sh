#!/bin/bash
# Claude Code Notify - Main notification script
# Sends desktop notifications when Claude needs attention (macOS only)

set -e

# Get the script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source configuration
source "$SCRIPT_DIR/config.sh"

# Check if notifications are enabled
if [ "$NOTIFY_ENABLED" != "true" ] || [ "$NOTIFY_ON_ATTENTION" != "true" ]; then
    exit 0
fi

# Verify we're on macOS
if [ "$(uname -s)" != "Darwin" ]; then
    echo "This plugin only supports macOS" >&2
    exit 1
fi

TITLE="${CUSTOM_TITLE:-Claude Code}"
MESSAGE="Claude Code needs your attention"

# Read input from stdin (hook provides JSON context)
INPUT=$(cat 2>/dev/null || echo "{}")

# Extract notification type if available
NOTIFICATION_TYPE=$(echo "$INPUT" | jq -r '.notification_type // empty' 2>/dev/null || echo "")

case "$NOTIFICATION_TYPE" in
  "permission_prompt")
    MESSAGE="Claude Code is waiting for permission"
    ;;
  "idle_prompt")
    MESSAGE="Claude Code is waiting for input"
    ;;
  "auth_success")
    MESSAGE="Authentication successful"
    ;;
  *)
    MESSAGE="Claude Code needs your attention"
    ;;
esac

# macOS - use osascript for native notifications
osascript -e "display notification \"$MESSAGE\" with title \"$TITLE\"" 2>/dev/null || true

exit 0
