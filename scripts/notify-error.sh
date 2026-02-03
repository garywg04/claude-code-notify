#!/bin/bash
# Claude Code Notify - Error notification
# Sends desktop notification when a tool execution fails (macOS only)

set -e

# Get the script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source configuration
source "$SCRIPT_DIR/config.sh"

# Check if notifications are enabled
if [ "$NOTIFY_ENABLED" != "true" ] || [ "$NOTIFY_ON_ERROR" != "true" ]; then
    exit 0
fi

# Verify we're on macOS
if [ "$(uname -s)" != "Darwin" ]; then
    echo "This plugin only supports macOS" >&2
    exit 1
fi

TITLE="${CUSTOM_TITLE:-Claude Code}"
MESSAGE="A tool execution failed"

# Read input from stdin (hook provides JSON context)
INPUT=$(cat 2>/dev/null || echo "{}")

# Try to extract tool name from input
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty' 2>/dev/null || echo "")
if [ -n "$TOOL_NAME" ]; then
  MESSAGE="Tool '$TOOL_NAME' failed"
fi

# macOS - use osascript for native notifications
osascript -e "display notification \"$MESSAGE\" with title \"$TITLE\"" 2>/dev/null || true

exit 0
