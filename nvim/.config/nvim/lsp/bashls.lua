return {
  cmd = { "bash-language-server", "start" },
  filetypes = { "bash", "sh", "dash" },
  root_markers = ".git",
  settings = {
    bashIde = {
      globPattern = "*@(.sh|.inc|.bash|.command|.dash)"
    }
  }
}
