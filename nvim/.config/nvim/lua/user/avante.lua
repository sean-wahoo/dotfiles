local avante_ok, avante = pcall(require, 'avante')
if not avante_ok then
  print("avante oopsie!")
  return
end
avante.setup {

  -- rag_service = {
  --   enabled = true,
  --   llm = {
  --     provider = "ollama",
  --     endpoint = "http://localhost:11434/v1",
  --     model = "qwen2.5-coder:7b"
  --   },
  --   embed = {
  --     provider = "ollama",
  --     endpoint = "http://localhost:11434/v1",
  --     model = "nomic-embed-text"
  --   }
  -- },
  -- acp_providers = {
  --   ["ollama"] = {
  --     -- command = ""
  --   }
  -- },
  provider = "ollama",
  acp_providers = {

    providers = {
      ollama = {
        model = "qwen2.5-coder:7b",
        is_env_set = false
      }
    },
  },
  providers = {
    ollama = {
      model = "qwen2.5-coder:7b",
      is_env_set = false
    }
  },
  input = {
    provider = "snacks",
    provider_opts = {
      title = "Avante Input",
      icon = " ",
      placeholder = "api key..."
    }
  }
}
--   rag_service = {
--     enabled = true,
--     llm = {
--       provider = "ollama",
--       endpoint = "http://localhost:11434/v1",
--       model = "qwen2.5-coder:7b"
--     },
--     embed = {
--       provider = "ollama",
--       endpoint = "http://localhost:11434/v1",
--       model = "nomic-embed-text"
--     }
--   },
--   acp_providers = {
--     ["ollama"] = {
--       -- command = ""
--     }
--   },
--   provider = "ollama",
--   providers = {
--     ollama = {
--       model = "qwen2.5-coder:7b",
--       is_env_set = true
--     }
--   }
-- },
