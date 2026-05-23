local ls_ok, ls = pcall(require, "luasnip")
if not ls_ok then
	print("luasnip oopsie")
	return
end
local l_ok, l = pcall(require, "luasnip.loaders.from_vscode")
if not l_ok then
	print("uh oh luasnip custom json snippets")
else
	-- l.lazy_load({ paths = { "~/.config/nvim/snippets" } })
end

local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node

local l = require("luasnip.extras").lambda
local rep = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.conditions")
local conds_expand = require("luasnip.extras.conditions.expand")

local function copy(args)
	return args[1][1]
end

ls.add_snippets("lua", {
	s({
		trig = "prq",
		desc = "pcall a module",
	}, {
		t("local "),
		i(1, "module"),
		t("_ok, "),
		f(copy, 1),
		t(" = pcall(require, '"),
		i(2, "module"),
		t({ "')", "if not " }),
		f(copy, 1),
		t({ "_ok then", '\tprint("' }),
		f(copy, 1),
		t({ ' oopsie!")', "\treturn", "end", "" }),
	}),
})

ls.add_snippets("typescriptreact", {
	s("use", {
		t({ "useEffect(() => {", "\t" }),
		i(0),
		t({ "", "}, [" }),
		i(1, ""),
		t("]);"),
	}),
	s("usr", {
		t("const "),
		i(1, "ref"),
		t(" = useRef<"),
		i(2, "HTMLDivElement"),
		t(">(null)"),
	}),
	s("ust", {
		sn(1, {
			t("const ["),
			i(1, "state"),
			t(", "),
			d(2, function(args)
				args = args[1]
				local first = string.sub(args[1], 1, 1)
				local rest = string.sub(args[1], 2)
				local text = "set" .. string.upper(first) .. rest
				return sn(nil, {
					i(1, text),
				})
			end, { 1 }),
			t("] = useState<"),
			i(3, "string"),
			t(">("),
			i(4),
			t(");"),
		}),
	}),
})
ls.add_snippets("typescriptreact", {
	s("ust", {
		sn(1, {
			t("const ["),
			i(1, "state"),
			t(", "),
			d(2, function(args)
				args = args[1]
				local first = string.sub(args[1], 1, 1)
				local rest = string.sub(args[1], 2)
				local text = "set" .. string.upper(first) .. rest
				return sn(nil, {
					i(1, text),
				})
			end, { 1 }),
			t("] = useState<"),
			i(3, "string"),
			t(">("),
			i(4),
			t(");"),
		}),
	}),
})

-- c(omponent)c(lient)c(hildren)
-- c(omponent)c(lient)n(o children)
-- c(omponent)s(server)c(hildren)
-- c(omponent)s(server)(o children)

ls.add_snippets("typescriptreact", {
	s({
		trig = "ccc",
		desc = "client component with children",
	}, {
		t({ '"use client"', "", "" }),
		sn(1, {
			t("const "),
			i(1, "Component"),
			t({ " = ({ children }: PropsWithChildren) => {", "" }),
			t({ "\treturn (", "" }),
			i(2),
			t({ "\t\t<></>", "" }),
			t({ "\t)", "" }),
			t({ "}", "" }),
			t("export default "),
			f(copy, 1),
			t(";"),
		}),
	}),
})

ls.add_snippets("typescriptreact", {
	s({
		trig = "ccn",
		desc = "client component without children",
	}, {
		t({ '"use client"', "", "" }),
		sn(1, {
			t("const "),
			i(1, "Component"),
			t({ " = () => {", "" }),
			t({ "\treturn (", "" }),
			i(2),
			t({ "\t\t<></>", "" }),
			t({ "\t)", "" }),
			t({ "}", "" }),
			t("export default "),
			f(copy, 1),
			t(";"),
		}),
	}),
})
