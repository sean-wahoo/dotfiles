return {
	root_markers = { "tsconfig.json", "jsconfig.json", "package.json" },
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
	},
	settings = {
		complete_function_calls = true,
		vtsls = {
			enableMoveToFileCodeAction = false,
			autoUseWorkspaceTsdk = true,
			experimental = {
				maxInlayHintLength = 30,
				completion = {
					enableServerSideFuzzyMatch = true,
				},
			},
		},
		typescript = {
			updateImportsOnFileMove = { enabled = "always " },
			suggest = {
				completeFunctionCalls = true,
			},
			inlayHints = {
				enumNumberValues = {
					enabled = true,
				},
				functionLikeReturnTypes = { enabled = true },
				parameterNames = { enabled = "literals" },
				parameterTypes = { enabled = true },
				propertyDeclarationTypes = { enabled = true },
				variableTypes = { enabled = false },
			},
		},
	},
}
