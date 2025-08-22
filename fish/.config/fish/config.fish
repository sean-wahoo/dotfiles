if status is-interactive
  if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
    exec startx -- -keeptty
  end

  set EDITOR "nvim"
  set STARSHIP_CONFIG "~/.config/starship/starship.toml"
  set XDG_CONFIG_HOME "/home/sean/.config"
  set XINITRC "/home/sean/.xinitrc"
  set XCURSOR_THEME "pixelfun2"
  set XDG_CONFIG_HOME "/home/sean/.config"

  #direnv hook fish | source
  #starship init fish | source

  if test -f /usr/bin/eza
    alias ls="eza -1 -l --icons=auto -h -g -o --total-size --time-style 'relative' --group-directories-first --no-permissions"
  end
end
