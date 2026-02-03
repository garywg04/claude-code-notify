# claude-code-notify

Desktop notifications for Claude Code events. Get notified when Claude needs your attention, completes tasks, or encounters errors.

## Features

- **Attention Notifications**: Get alerted when Claude Code needs your input or permission
- **Task Completion**: Know when Claude finishes responding to your request
- **Error Alerts**: Be notified immediately when a tool execution fails
- **Cross-Platform**: Works on macOS, Linux, and Windows
- **Sound Notifications**: Audio alerts on all platforms
- **Configurable**: Customize notification behavior to your preferences

## Installation

### Via Claude Code Plugin System

```bash
# Add the plugin marketplace
/plugin marketplace add garywg04/claude-code-notify

# Install the plugin
/plugin install claude-code-notify
```

### Manual Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/garywg04/claude-code-notify.git
   ```

2. Use the plugin directory flag when starting Claude Code:
   ```bash
   claude --plugin-dir /path/to/claude-code-notify
   ```

## Testing

After installation, run the test script to verify notifications work on your system:

```bash
./scripts/test-notifications.sh
```

This will send three test notifications (attention, completion, error) so you can verify everything is working correctly.

## How It Works

This plugin uses Claude Code's hook system to trigger desktop notifications at key events:

| Event | Notification | Description |
|-------|-------------|-------------|
| `Notification` | Attention needed | Claude is waiting for permission or input |
| `Stop` | Task completed | Claude finished responding |
| `PostToolUseFailure` | Error alert | A tool execution failed |

## Configuration

### Custom Configuration File

Create a configuration file at `~/.claude-code-notify/config.sh` to customize notification behavior:

```bash
#!/bin/bash
# ~/.claude-code-notify/config.sh

# Enable/disable all notifications
NOTIFY_ENABLED=true

# Enable/disable sound effects
NOTIFY_SOUND_ENABLED=true

# Notification timeout in milliseconds (Linux only)
NOTIFY_TIMEOUT=5000

# Toggle specific notification types
NOTIFY_ON_ATTENTION=true
NOTIFY_ON_COMPLETE=true
NOTIFY_ON_ERROR=true

# Custom notification title
CUSTOM_TITLE="My Project"

# macOS sound names (see /System/Library/Sounds for options)
MACOS_SOUND_ATTENTION="default"  # Use "default" for no sound
MACOS_SOUND_COMPLETE="Glass"
MACOS_SOUND_ERROR="Basso"

# Linux urgency levels: low, normal, critical
LINUX_URGENCY_ATTENTION="normal"
LINUX_URGENCY_COMPLETE="low"
LINUX_URGENCY_ERROR="critical"
```

### Customizing Hooks

You can override the default hooks by creating your own hook configuration in your project's `.claude/settings.json`:

```json
{
  "hooks": {
    "Notification": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "your-custom-notification-script.sh"
          }
        ]
      }
    ]
  }
}
```

### Disabling Specific Notifications

To disable completion notifications while keeping others:

```json
{
  "hooks": {
    "Stop": []
  }
}
```

## Platform Requirements

### macOS
No additional setup required. Uses native `osascript` for notifications.

Available sounds: Basso, Blow, Bottle, Frog, Funk, Glass, Hero, Morse, Ping, Pop, Purr, Sosumi, Submarine, Tink

### Linux
Requires one of the following notification tools:
- `notify-send` (libnotify) - Most common, works with GNOME, KDE, etc.
- `zenity` - GTK-based alternative
- `kdialog` - KDE-specific alternative

For sound support (optional):
- `paplay` (PulseAudio) - Most common
- `aplay` (ALSA) - Fallback

Install on Debian/Ubuntu:
```bash
sudo apt install libnotify-bin pulseaudio-utils
```

Install on Fedora:
```bash
sudo dnf install libnotify pulseaudio-utils
```

Install on Arch:
```bash
sudo pacman -S libnotify pulseaudio
```

### Windows
Works with Windows 10/11 through PowerShell toast notifications. No additional setup required when using Git Bash, Cygwin, or WSL.

## Plugin Structure

```
claude-code-notify/
├── .claude-plugin/
│   └── plugin.json              # Plugin manifest
├── hooks/
│   └── hooks.json               # Hook configuration
├── scripts/
│   ├── config.sh                # Configuration defaults
│   ├── notify.sh                # Main notification script
│   ├── notify-complete.sh       # Task completion notifications
│   ├── notify-error.sh          # Error notifications
│   └── test-notifications.sh    # Test script
├── package.json
├── LICENSE
└── README.md
```

## Troubleshooting

### Notifications not appearing on Linux

1. Check if `notify-send` is installed:
   ```bash
   which notify-send
   ```

2. Test notifications directly:
   ```bash
   notify-send "Test" "This is a test notification"
   ```

3. Ensure your notification daemon is running (e.g., `dunst`, `mako`, or your DE's built-in daemon)

### No sound on Linux

1. Check if PulseAudio is running:
   ```bash
   pactl info
   ```

2. Test sound directly:
   ```bash
   paplay /usr/share/sounds/freedesktop/stereo/message.oga
   ```

### Notifications not appearing on macOS

1. Check System Preferences > Notifications and ensure Terminal (or your terminal app) has notification permissions enabled.

2. Test notifications directly:
   ```bash
   osascript -e 'display notification "Test" with title "Test"'
   ```

### Notifications not appearing on Windows

1. Ensure you're using a compatible shell (Git Bash, Cygwin, or WSL)
2. Check Windows notification settings for your terminal application

### Disabling notifications temporarily

Set `NOTIFY_ENABLED=false` in your config file at `~/.claude-code-notify/config.sh`

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

MIT License - see [LICENSE](LICENSE) for details.
