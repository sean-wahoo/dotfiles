-- ~/.config/nvim/lsp/vtsls.lua

-- Common Next.js/React project root markers
local root_pattern = vim.fs.root(0, {
	"next.config.js",
	"next.config.mjs",
	"next.config.ts",
	"tsconfig.json",
	"package.json",
	".git",
})

return {
	-- Establish the root directory context natively via Neovim utilities
	root_dir = root_pattern,

	settings = {
		-- 1. Core Engine Configurations
		vtsls = {
			-- Instantly detect and map the local Next.js 'node_modules/typescript' library
			autoUseWorkspaceTsdk = true,
			experimental = {
				completion = {
					enableServerSideFuzzyMatch = true,
				},
			},
			tsserver = {
				-- Forces vtsls to read auto-generated plugins in .next/types/
				pluginPaths = { "." },
			},
		},

		-- 2. TypeScript-Specific Logic (Matches VS Code Next.js behaviors)
		typescript = {
			tsserver = {
				experimental = {
					-- 🔥 PROJECT-WIDE CORRECTION:
					-- Forces the native language server to parse the entire tsconfig workspace.
					-- This streams errors from un-opened routing files directly into trouble.nvim.
					enableProjectDiagnostics = true,
				},
				maxTsServerMemory = 8192, -- Prevents crashes on intensive monorepo contexts
			},
			-- Restrict intrusive formatting/hinting behaviors
			inlayHints = {
				parameterNames = { enabled = "none" },
				parameterTypes = { enabled = false },
				variableTypes = { enabled = false },
				propertyDeclarationTypes = { enabled = false },
				functionLikeReturnTypes = { enabled = false },
				enumMemberValues = { enabled = false },
			},
			format = {
				enable = false, -- Disable default engine format rules to prevent Prettier conflicts
			},
		},

		-- 3. JavaScript Fallback Rules
		javascript = {
			tsserver = {
				experimental = {
					enableProjectDiagnostics = true,
				},
			},
			format = { enable = false },
		},
	},
}
