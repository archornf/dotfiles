# Setup fzf
# ---------
if [[ ! "$PATH" == */home/jonas/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/jonas/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/jonas/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/jonas/.fzf/shell/key-bindings.bash"
