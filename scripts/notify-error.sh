#!/bin/bash
# Claude Code Notify - Error notification
# Sends desktop notification when a tool execution fails

set -e

# Get the script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source configuration
source "$SCRIPT_DIR/config.sh"

# Check if notifications are enabled
if [ "$NOTIFY_ENABLED" != "true" ] || [ "$NOTIFY_ON_ERROR" != "true" ]; then
    exit 0
fi

TITLE="${CUSTOM_TITLE:-Claude Code}"
MESSAGE="A tool execution failed"
ICON="dialog-error"

# Read input from stdin (hook provides JSON context)
INPUT=$(cat 2>/dev/null || echo "{}")

# Try to extract tool name from input
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty' 2>/dev/null || echo "")
if [ -n "$TOOL_NAME" ]; then
  MESSAGE="Tool '$TOOL_NAME' failed"
fi

# Detect OS and send notification
case "$(uname -s)" in
  Darwin)
    # macOS - use osascript for native notifications
    if [ "$NOTIFY_SOUND_ENABLED" = "true" ] && [ -n "$MACOS_SOUND_ERROR" ]; then
      osascript -e "display notification \"$MESSAGE\" with title \"$TITLE\" sound name \"$MACOS_SOUND_ERROR\"" 2>/dev/null || true
    else
      osascript -e "display notification \"$MESSAGE\" with title \"$TITLE\"" 2>/dev/null || true
    fi
    ;;
  Linux)
    # Linux - try notify-send first, then fall back to alternatives
    if command -v notify-send &>/dev/null; then
      notify-send "$TITLE" "$MESSAGE" --icon="$ICON" --urgency="$LINUX_URGENCY_ERROR" -t "$NOTIFY_TIMEOUT" 2>/dev/null || true
    elif command -v zenity &>/dev/null; then
      zenity --notification --text="$TITLE: $MESSAGE" 2>/dev/null || true
    elif command -v kdialog &>/dev/null; then
      kdialog --passivepopup "$MESSAGE" $((NOTIFY_TIMEOUT / 1000)) --title "$TITLE" 2>/dev/null || true
    fi
    # Play error sound on Linux if enabled
    if [ "$NOTIFY_SOUND_ENABLED" = "true" ]; then
      if command -v paplay &>/dev/null; then
        paplay /usr/share/sounds/freedesktop/stereo/dialog-error.oga 2>/dev/null &
      elif command -v aplay &>/dev/null; then
        aplay /usr/share/sounds/alsa/Front_Center.wav 2>/dev/null &
      fi
    fi
    ;;
  CYGWIN*|MINGW*|MSYS*)
    # Windows (Git Bash, Cygwin, etc.)
    if command -v powershell.exe &>/dev/null; then
      powershell.exe -Command "
        [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
        [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null
        \$template = '<toast><visual><binding template=\"ToastText02\"><text id=\"1\">$TITLE</text><text id=\"2\">$MESSAGE</text></binding></visual></toast>'
        \$xml = New-Object Windows.Data.Xml.Dom.XmlDocument
        \$xml.LoadXml(\$template)
        \$toast = [Windows.UI.Notifications.ToastNotification]::new(\$xml)
        [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier('Claude Code').Show(\$toast)
      " 2>/dev/null || true
    fi
    ;;
esac

exit 0
