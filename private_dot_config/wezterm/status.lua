local wezterm = require("wezterm")

-- left status
local DEFAULT_FG = { Color = "#9a9eab" }
local DEFAULT_BG = { Color = "#333333" }

local one_space = " "
local three_spaces = "   "

local HEADER_KEY_NORMAL = { Foreground = DEFAULT_FG, Text = "" }
local HEADER_LEADER = { Foreground = { Color = "#ffffff" }, Text = "" }
local HEADER_IME = { Foreground = DEFAULT_FG, Text = "あ" }

local function AddIcon(elems, icon)
	table.insert(elems, { Foreground = icon.Foreground })
	table.insert(elems, { Background = DEFAULT_BG })
	table.insert(elems, { Text = one_space .. icon.Text .. three_spaces })
end

local function GetKeyboard(elems, window)
	if window:leader_is_active() then
		AddIcon(elems, HEADER_LEADER)
		return
	end

	AddIcon(elems, window:composition_status() and HEADER_IME or HEADER_KEY_NORMAL)
end

local HEADER_WORKSPACE = { Foreground = { Color = "#c3a6ff" }, Text = "" }

local function GetWorkspace(elems, window)
	local name = window:active_workspace()
	if name and name ~= "default" then
		AddIcon(elems, HEADER_WORKSPACE)
		table.insert(elems, { Foreground = DEFAULT_FG })
		table.insert(elems, { Background = DEFAULT_BG })
		table.insert(elems, { Text = name .. three_spaces })
	end
end

local function LeftUpdate(window, pane)
	local elems = {}

	GetKeyboard(elems, window)
	GetWorkspace(elems, window)

	window:set_left_status(wezterm.format(elems))
end

-- right status
local HEADER_HOST = { Foreground = { Color = "#75b1a9" }, Text = "" }
local HEADER_CWD = { Foreground = { Color = "#92aac7" }, Text = "" }
local HEADER_DATE = { Foreground = { Color = "#ffccac" }, Text = "󱪺" }
local HEADER_TIME = { Foreground = { Color = "#bcbabe" }, Text = "" }
local HEADER_BATTERY = { Foreground = { Color = "#dfe166" }, Text = "" }

local function AddElement(elems, header, str)
	table.insert(elems, { Foreground = header.Foreground })
	table.insert(elems, { Background = DEFAULT_BG })
	table.insert(elems, { Text = header.Text .. one_space })

	table.insert(elems, { Foreground = DEFAULT_FG })
	table.insert(elems, { Background = DEFAULT_BG })
	table.insert(elems, { Text = str .. three_spaces })
end

local function GetHostAndCwd(elems, pane)
	local url = pane:get_current_working_dir()

	if not url then
		return
	end

	-- url は URL オブジェクト: .host, .file_path プロパティを使用
	local host = url.host or ""
	local cwd  = url.file_path or ""

	-- 末尾スラッシュを除去
	if cwd:sub(-1) == "/" then
		cwd = cwd:sub(1, -2)
	end

	local dot = host:find("[.]")
	AddElement(elems, HEADER_HOST, dot and host:sub(1, dot - 1) or host)
	AddElement(elems, HEADER_CWD, cwd)
end

local function GetDate(elems)
	AddElement(elems, HEADER_DATE, wezterm.strftime("%a %b %-d"))
end

local function GetTime(elems)
	AddElement(elems, HEADER_TIME, wezterm.strftime("%H:%M"))
end

local function GetBattery(elems, window)
	if not window:get_dimensions().is_full_screen then
		return
	end

	for _, b in ipairs(wezterm.battery_info()) do
		AddElement(elems, HEADER_BATTERY, string.format("%.0f%%", b.state_of_charge * 100))
	end
end

local function RightUpdate(window, pane)
	local elems = {}

	GetHostAndCwd(elems, pane)
	GetDate(elems)
	GetBattery(elems, window)
	GetTime(elems)

	window:set_right_status(wezterm.format(elems))
end

wezterm.on("update-status", function(window, pane)
	LeftUpdate(window, pane)
	RightUpdate(window, pane)
end)
