# claude-code-notify

Desktop notifications for Claude Code events on macOS. Get notified when Claude needs your attention, completes tasks, or encounters errors.

## Features

- **Attention Notifications**: Get alerted when Claude Code needs your input or permission
- **Task Completion**: Know when Claude finishes responding to your request
- **Error Alerts**: Be notified immediately when a tool execution fails
- **Sound Notifications**: Audio alerts with customizable sounds
- **Configurable**: Customize notification behavior to your preferences

## Requirements

- macOS 10.10 or later
- Terminal app with notification permissions enabled

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

# Toggle specific notification types
NOTIFY_ON_ATTENTION=true
NOTIFY_ON_COMPLETE=true
NOTIFY_ON_ERROR=true

# Custom notification title
CUSTOM_TITLE="My Project"

# macOS sound names (see /System/Library/Sounds for options)
# Available: Basso, Blow, Bottle, Frog, Funk, Glass, Hero, Morse, Ping, Pop, Purr, Sosumi, Submarine, Tink
MACOS_SOUND_ATTENTION="default"  # Use "default" for no sound
MACOS_SOUND_COMPLETE="Glass"
MACOS_SOUND_ERROR="Basso"
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

### Notifications not appearing

1. Check System Preferences > Notifications and ensure your terminal app (Terminal, iTerm2, etc.) has notification permissions enabled.

2. Test notifications directly:
   ```bash
   osascript -e 'display notification "Test" with title "Test"'
   ```

3. Make sure "Do Not Disturb" mode is not enabled.

### No sound with notifications

1. Check that your system volume is not muted.

2. Verify the sound name is valid. Available sounds are in `/System/Library/Sounds`:
   ```bash
   ls /System/Library/Sounds
   ```

3. Test a sound directly:
   ```bash
   osascript -e 'display notification "Test" with title "Test" sound name "Glass"'
   ```

### Disabling notifications temporarily

Set `NOTIFY_ENABLED=false` in your config file at `~/.claude-code-notify/config.sh`

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

MIT License - see [LICENSE](LICENSE) for details.
