require 'neorg'.setup {
  load = {
    ["core.defaults"] = {},
    ['core.norg.dirman'] = {
      config = {
        workspaces = {
          projects = "~/notes/projects"
        }
      }
    },
    ["core.norg.completion"] = {
      config = {
        engine = "nvim-cmp"
      }
    },
    ["core.norg.concealer"] = {
      config = {

      }
    }
  }
}
