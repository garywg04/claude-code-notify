#!/bin/bash
# Claude Code Notify - Test Script
# Tests all notification types to verify they work on your system

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Claude Code Notify - Notification Test"
echo "======================================="
echo ""

# Detect OS
OS="$(uname -s)"
case "$OS" in
  Darwin)
    echo "Detected OS: macOS"
    ;;
  Linux)
    echo "Detected OS: Linux"
    if command -v notify-send &>/dev/null; then
      echo "Notification tool: notify-send (libnotify)"
    elif command -v zenity &>/dev/null; then
      echo "Notification tool: zenity"
    elif command -v kdialog &>/dev/null; then
      echo "Notification tool: kdialog"
    else
      echo "WARNING: No notification tool found!"
      echo "Please install libnotify-bin, zenity, or kdialog"
    fi
    ;;
  CYGWIN*|MINGW*|MSYS*)
    echo "Detected OS: Windows (via $OS)"
    ;;
  *)
    echo "Detected OS: Unknown ($OS)"
    ;;
esac

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
echo "If notifications didn't appear, check the troubleshooting section in README.md"
echo ""
