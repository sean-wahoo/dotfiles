if status is-interactive
    # Commands to run in interactive sessions can go here
end

# pnpm
set -gx PNPM_HOME "/home/sean/.local/share/pnpm"
set -gx PATH "$PNPM_HOME" $PATH
# pnpm end

alias ls='exa --oneline --long --icons --classify --color-scale --all --color=always --git --group-directories-first --sort Name --no-time --no-filesize --header --octal-permissions --no-permissions --group --extended'
