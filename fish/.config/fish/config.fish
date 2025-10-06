if status is-interactive
  if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
    exec startx -- -keeptty
  end

  set EDITOR "/usr/bin/nvim"
  set STARSHIP_CONFIG "~/.config/starship/starship.toml"
  set XDG_CONFIG_DIR "/home/sean"
  set XINITRC "/home/sean/.xinitrc"
  set -gx NVIM_MINUET_API_KEY "sk-c175f1176e1f40b284a44b2ac273595e"

  #direnv hook fish | source
  #starship init fish | source

  if test -f /usr/bin/eza
    alias ls="eza -1 -l --icons=auto -h -g -o --total-size --time-style 'relative' --group-directories-first --no-permissions"
  end
end

# pnpm
set -gx PNPM_HOME "/home/sean/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
