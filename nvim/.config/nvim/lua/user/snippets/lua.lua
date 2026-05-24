local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

local fmt = require("luasnip.extras.fmt").fmt
local utils = require("user.snippets._utils")

local snippets = {
	s({
		trig = "prq",
		desc = "pcall a module",
	}, {
		t("local "),
		i(1, "module"),
		t("_ok, "),
		f(utils.copy, 1),
		t(" = pcall(require, '"),
		i(2, "module"),
		t({ "')", "if not " }),
		f(utils.copy, 1),
		t({ "_ok then", '\tprint("' }),
		f(utils.copy, 1),
		t({ ' oopsie!")', "\treturn", "end", "" }),
	}),
	s(
		"snipf",
		fmt(
			[=[

local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local f = ls.function_node
local sn = ls.snippet_node
local fmt = require("luasnip.format.helpers").fmt

-- Snippets for language: {}
local snippets = {{
    s("{}", fmt([[
    {}
    ]], {{
        {}
    }})),
}}

local autosnippets = {{
    -- Add automatic snippets here
}}

return snippets, autosnippets

  ]=],
			{
				f(utils.get_target_lang, {}),
				i(1, "trigger"),
				i(2, "body"),
				i(0, "i(1)"),
			}
		)
	),
}

local autosnippets = {}

return snippets, autosnippets
