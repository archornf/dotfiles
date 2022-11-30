#!/bin/bash
#$1 -e bash -c 'tmux attach || tmux' &
#tmux send-keys "python3" Enter

$1 -e bash -c 'python3'
