if status is-interactive
    # Commands to run in interactive sessions can go here
    set EDITOR "/usr/bin/nvim"
    set XDG_CONFIG_HOME "/home/user/.config"
		set SSH_AUTH_SOCK "/home/user/.SSH_AGENT_ssh-key-vault"
		direnv hook fish | source
end
