#!/bin/bash
# Claude Code Notify - Task completion notification
# Sends desktop notification when Claude finishes a response

set -e

TITLE="Claude Code"
MESSAGE="Task completed"
ICON="dialog-ok"

# Detect OS and send notification
case "$(uname -s)" in
  Darwin)
    # macOS - use osascript for native notifications
    osascript -e "display notification \"$MESSAGE\" with title \"$TITLE\" sound name \"Glass\"" 2>/dev/null || true
    ;;
  Linux)
    # Linux - try notify-send first, then fall back to alternatives
    if command -v notify-send &>/dev/null; then
      notify-send "$TITLE" "$MESSAGE" --icon="$ICON" --urgency=low 2>/dev/null || true
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
