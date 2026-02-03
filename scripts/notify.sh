#!/bin/bash
# Claude Code Notify - Main notification script
# Sends desktop notifications when Claude needs attention

set -e

TITLE="Claude Code"
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
    osascript -e "display notification \"$MESSAGE\" with title \"$TITLE\"" 2>/dev/null || true
    ;;
  Linux)
    # Linux - try notify-send first, then fall back to alternatives
    if command -v notify-send &>/dev/null; then
      notify-send "$TITLE" "$MESSAGE" --icon="$ICON" 2>/dev/null || true
    elif command -v zenity &>/dev/null; then
      zenity --notification --text="$TITLE: $MESSAGE" 2>/dev/null || true
    elif command -v kdialog &>/dev/null; then
      kdialog --passivepopup "$MESSAGE" 5 --title "$TITLE" 2>/dev/null || true
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
