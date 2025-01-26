require("format")
require("status")

-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
config.color_scheme = "Solarized Dark (Gogh)"

config.font = wezterm.font("HackGen Console NF")
config.font_size = 18.0
config.window_frame = {
	font = wezterm.font({ family = "HackGen Console NF", weight = "Bold" }),
	font_size = 14.0,
}

-- Window config
-- see: https://wezfurlong.org/wezterm/config/appearance.html?h=opacity#window-background-opacity
config.window_background_opacity = 0.75

-- Keybinds
-- see: https://wezfurlong.org/wezterm/config/default-keys.html?h=disable_default
config.disable_default_key_bindings = true
local keybind = require("keybinds")
config.keys = keybind.keys
-- see: https://wezfurlong.org/wezterm/config/key-tables.html
-- cojnfig file: keybinds.lua
config.key_tables = keybind.key_tables
config.leader = { key = "z", mods = "CTRL", timeout_milliseconds = 2000 }

-- status
config.status_update_interval = 1000

-- Kitty Image Protocol Support
-- see: https://github.com/wez/wezterm/issues/986
config.enable_kitty_graphics = true

-- and finally, return the configuration to wezterm
return config
