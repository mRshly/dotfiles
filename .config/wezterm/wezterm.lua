require 'format'
require 'status'

-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'iceberg-dark'
config.window_background_opacity = 0.93
config.font = wezterm.font 'HackGen Console NF'
config.font_size = 14.0
config.window_frame = {
  font = wezterm.font { family = 'HackGen Console NF', weight = 'Bold' },
  font_size = 12.0,
}

-- Window config
config.window_background_opacity = 0.75

-- keybinds
-- デフォルトのkeybinds を無効化
config.disable_default_key_bindings = true
-- `keybinds.lua` を読み込み
local keybind = require 'keybinds'
-- keybind の設定
config.keys = keybind.keys
config.key_tables = keybind.key_tables
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 2000 }

-- status
config.status_update_interval = 1000

-- and finally, return the configuration to wezterm
return config
