local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local c = ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep
local expand_cond = require("luasnip.extras.conditions.expand")

return {
	-- main function
	s({ trig = "main", name = "main function" }, {
		t("if __name__ == '__main__':"),
		t("<0>"),
		i(0),
	}),

	-- Read CSV file with encoding
	s(
		{ trig = "csv", name = "read csv file with encoding" },
		fmta(
			[[with open(<1>, mode="r", encoding="<0>") as file:]]
				.. "\n"
				.. [[    reader = csv.reader(file)]]
				.. "\n"
				.. [[    for row in reader:]]
				.. "\n"
				.. [[        print(row)]],
			{
				[1] = i(1),
				[0] = i(0),
			}
		)
	),
	-- Measuring time
	s(
		{ trig = "time", name = "measuring time include sleep time" },
		fmta(
			[[import time]]
				.. "\n"
				.. [[start_time = time.perf_counter()]]
				.. "\n"
				.. [[<1>]]
				.. "\n"
				.. [[end_time = time.perf_counter()]]
				.. "\n"
				.. [[print(f"Time taken: {end_time - start_time} ms", )]],
			{
				[1] = i(1),
			}
		)
	),
	s(
		{ trig = "time", name = "measuring time exclude sleep time" },
		fmta(
			[[import time]]
				.. "\n"
				.. [[start_time = time.process_time()]]
				.. "\n"
				.. [[<1>]]
				.. "\n"
				.. [[end_time = time.process_time()]]
				.. "\n"
				.. [[print(f"Time taken: {end_time - start_time} ms", )]],
			{
				[1] = i(1),
			}
		)
	),
}
