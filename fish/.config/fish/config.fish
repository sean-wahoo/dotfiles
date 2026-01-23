if status is-interactive
  if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
    exec startx -- -keeptty
  end

  set -gx EDITOR "/usr/bin/nvim"
  set -gx STARSHIP_CONFIG "/home/sean/.config/starship/starship.toml"
  set -gx NVIM_MINUET_API_KEY "sk-c175f1176e1f40b284a44b2ac273595e"
  set -gx HOSTNAME (hostnamectl hostname)

  starship init fish | source
  if test -f /usr/bin/direnv
    direnv hook fish | source
  end

  if test -f /usr/bin/eza
    alias ls="eza -1lao --git --smart-group --group-directories-first --icons"
  end

end

# pnpm
set -gx PNPM_HOME "/home/sean/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
