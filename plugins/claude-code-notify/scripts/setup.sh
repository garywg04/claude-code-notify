#!/bin/bash

# If in tmux session, enable focus events and reset color hook
if [[ -n "$TMUX" ]]; then
    tmux set-option focus-events on
    tmux set-hook pane-focus-in 'select-pane -P bg=default'
fi