if status is-interactive
  if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
    exec startx -- -keeptty
  end

  set -gx XDG_CONFIG_DIR "$HOME/.config"
  set -gx EDITOR "/usr/bin/nvim"
  set -gx STARSHIP_CONFIG "/home/sean/.config/starship/starship.toml"
  set -gx NVIM_MINUET_API_KEY "sk-c175f1176e1f40b284a44b2ac273595e"
  if type -q hostname;
    set -gx HOSTNAME (hostname)
  else
    set -gx HOSTNAME (hostnamectl hostname)
  end

  set -gx MPD_HOST "$XDG_RUNTIME_DIR/mpd/socket"
  set -gx ANDROID_HOME "$HOME/Android/Sdk"

  starship init fish | source
  if test -f /usr/bin/direnv
    direnv hook fish | source
  end

  if test -f /usr/bin/zoxide
    zoxide init fish | source
  end

  if test -f /usr/bin/eza
    alias ls="eza -1lao --git --smart-group --group-directories-first --icons=auto "
  end
  function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    command yazi $argv --cwd-file="$tmp"
    if read -z cwd < "$tmp"; and [ "$cwd" != "$PWD" ]; and test -d "$cwd"
      builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
  end
end

function fish_greeting
  /bin/bash ~/.config/fish/scripts/greeting.sh
end

# pnpm
set -gx PNPM_HOME "/home/sean/.local/share/pnpm"
if not string match -q -- "$PNPM_HOME/bin" $PATH
  set -gx PATH "$PNPM_HOME/bin" $PATH
end
# pnpm end

# opencode
fish_add_path /home/sean/.opencode/bin
