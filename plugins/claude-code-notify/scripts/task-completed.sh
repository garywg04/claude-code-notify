#!/bin/bash

if [[ "$(uname)" != "Darwin" ]]; then
    exit 0
fi

if ! command -v osascript &> /dev/null; then
    exit 0
fi

osascript -e 'display notification "Task completed!" with title "🤖 Claude Code"'

# If in tmux session, change pane border color to green (success)
if [[ -n "$TMUX" ]] && [[ -n "$TMUX_PANE" ]]; then
    tmux select-pane -t "$TMUX_PANE"
    tmux select-pane -P 'bg=colour22'
    tmux last-pane
fi
