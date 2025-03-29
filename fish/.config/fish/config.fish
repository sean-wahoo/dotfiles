if status is-interactive
  echo "hehe d=$DISPLAY x=$XDG_VTNR"

  if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
    exec startx -- -keeptty
  end
  set EDITOR "/usr/bin/nvim"
  direnv hook fish | source
  starship init fish | source

  if test -f /usr/bin/eza
    alias ls="eza -1 -l --icons=auto -h -g -o --total-size --time-style 'relative' --group-directories-first --no-permissions"
  end
end
