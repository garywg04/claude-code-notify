#!/bin/bash

if [[ "$(uname)" != "Darwin" ]]; then
    exit 0
fi

if ! command -v osascript &> /dev/null; then
    exit 0
fi

osascript -e "display notification \"Permission approval needed!!!\" with title \"🤖 Claude Code\""

# If in tmux session, change pane border color to blue (attention needed)
if [[ -n "$TMUX" ]] && [[ -n "$TMUX_PANE" ]]; then
    tmux select-pane -t "$TMUX_PANE"
    tmux select-pane -P 'bg=colour17'
    tmux last-pane
fi
