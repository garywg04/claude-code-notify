# claude-code-notify

A Claude Code plugin that sends macOS notifications when Claude Code needs your attention.

## Features

- **Task Completion**: macOS notification when Claude finishes a task
- **Permission Request**: macOS notification when Claude needs permission approval
- **Tmux Integration**: Visual pane background colors
  - Green: task completed
  - Blue: permission approval needed

## Installation

### Option 1: Install from Marketplace (Recommended)

Install the plugin via the official Claude Code marketplace:

```bash
/plugin marketplace add garywg04/claude-code-notify
/plugin install claude-code-notify
```

The plugin will be automatically updated when new versions are released.

### Option 2: Install Locally

1. Clone this repository:
   ```bash
   git clone https://github.com/garywg04/claude-code-notify.git
   ```

2. Start Claude Code with the plugin:
   ```bash
   claude --plugin-dir /path/to/claude-code-notify
   ```

## Requirements

- macOS (uses `osascript` for notifications)
- Optional: tmux (for visual pane indicators)

## License

MIT License - see [LICENSE](LICENSE) for details.
