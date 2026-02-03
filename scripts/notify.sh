#!/bin/bash
# Claude Code Notify - Main notification script
# Sends desktop notifications when Claude needs attention

set -e

# Get the script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source configuration
source "$SCRIPT_DIR/config.sh"

# Check if notifications are enabled
if [ "$NOTIFY_ENABLED" != "true" ] || [ "$NOTIFY_ON_ATTENTION" != "true" ]; then
    exit 0
fi

TITLE="${CUSTOM_TITLE:-Claude Code}"
MESSAGE="Claude Code needs your attention"
ICON="dialog-information"

# Read input from stdin (hook provides JSON context)
INPUT=$(cat 2>/dev/null || echo "{}")

# Extract notification type if available
NOTIFICATION_TYPE=$(echo "$INPUT" | jq -r '.notification_type // empty' 2>/dev/null || echo "")

case "$NOTIFICATION_TYPE" in
  "permission_prompt")
    MESSAGE="Claude Code is waiting for permission"
    ICON="dialog-password"
    ;;
  "idle_prompt")
    MESSAGE="Claude Code is waiting for input"
    ICON="dialog-question"
    ;;
  "auth_success")
    MESSAGE="Authentication successful"
    ICON="dialog-information"
    ;;
  *)
    MESSAGE="Claude Code needs your attention"
    ;;
esac

# Detect OS and send notification
case "$(uname -s)" in
  Darwin)
    # macOS - use osascript for native notifications
    if [ "$NOTIFY_SOUND_ENABLED" = "true" ] && [ -n "$MACOS_SOUND_ATTENTION" ] && [ "$MACOS_SOUND_ATTENTION" != "default" ]; then
      osascript -e "display notification \"$MESSAGE\" with title \"$TITLE\" sound name \"$MACOS_SOUND_ATTENTION\"" 2>/dev/null || true
    else
      osascript -e "display notification \"$MESSAGE\" with title \"$TITLE\"" 2>/dev/null || true
    fi
    ;;
  Linux)
    # Linux - try notify-send first, then fall back to alternatives
    if command -v notify-send &>/dev/null; then
      notify-send "$TITLE" "$MESSAGE" --icon="$ICON" --urgency="$LINUX_URGENCY_ATTENTION" -t "$NOTIFY_TIMEOUT" 2>/dev/null || true
    elif command -v zenity &>/dev/null; then
      zenity --notification --text="$TITLE: $MESSAGE" 2>/dev/null || true
    elif command -v kdialog &>/dev/null; then
      kdialog --passivepopup "$MESSAGE" $((NOTIFY_TIMEOUT / 1000)) --title "$TITLE" 2>/dev/null || true
    fi
    # Play sound on Linux if enabled
    if [ "$NOTIFY_SOUND_ENABLED" = "true" ]; then
      if command -v paplay &>/dev/null; then
        paplay /usr/share/sounds/freedesktop/stereo/message.oga 2>/dev/null &
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
