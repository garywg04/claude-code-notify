#!/bin/bash
# Claude Code Notify - Test Script (macOS only)
# Tests all notification types to verify they work on your system

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Claude Code Notify - Notification Test"
echo "======================================="
echo ""

# Verify we're on macOS
if [ "$(uname -s)" != "Darwin" ]; then
    echo "ERROR: This plugin only supports macOS"
    exit 1
fi

echo "Detected OS: macOS"
echo ""
echo "Testing notifications..."
echo ""

# Test attention notification
echo "1. Testing attention notification..."
echo '{"notification_type": "permission_prompt"}' | "$SCRIPT_DIR/notify.sh"
echo "   Sent: 'Claude Code is waiting for permission'"
sleep 2

# Test completion notification
echo "2. Testing completion notification..."
"$SCRIPT_DIR/notify-complete.sh"
echo "   Sent: 'Task completed'"
sleep 2

# Test error notification
echo "3. Testing error notification..."
echo '{"tool_name": "TestTool"}' | "$SCRIPT_DIR/notify-error.sh"
echo "   Sent: 'Tool TestTool failed'"

echo ""
echo "======================================="
echo "Test complete!"
echo ""
echo "If you saw 3 notifications, the plugin is working correctly."
echo "If notifications didn't appear, check System Preferences > Notifications"
echo "and ensure your terminal app has notification permissions enabled."
echo ""
