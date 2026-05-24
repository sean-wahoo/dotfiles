local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local sn = ls.snippet_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt

local copy = require("user.snippets._utils").copy

local snippets = {

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
	s(
		{ trig = "tc", desc = "try/catch" },
		fmt(
			[=[
try {
    {}
} catch (error) {
    if (error instanceof Error) {
        console.error(error.message);
    } else {
        console.error("An unknown error occurred:", error);
    }
    {}
}
]=],
			{
				i(1, "// code to run"),
				i(0),
			}
		)
	),

	s(
		{ trig = "tca", desc = "try/catch (actions)" },
		fmt(
			[=[
try {
    {}
} catch (error) {
    const message = error instanceof Error ? error.message : "Internal Server Error";
    console.error(message);
    return {{ error: message, success: false }};
}
]=],
			{
				i(0),
			}
		)
	),
}

local autosnippets = {}

return snippets, autosnippets
