if status is-interactive
  echo "hehe d=$DISPLAY x=$XDG_VTNR"

  if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
    exec startx -- -keeptty
  end
    # Commands to run in interactive sessions can go here
    set EDITOR="/usr/bin/nvim"

    direnv hook fish | source
end
