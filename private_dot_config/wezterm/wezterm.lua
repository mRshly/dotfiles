-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Side-effect modules (event handlers) are loaded after config_builder()
require("format")
require("status")

-- Color scheme
config.color_scheme = "Solarized Osaka"

-- Font
config.font = wezterm.font_with_fallback({
  { family = "Intel One Mono",         weight = "Medium" },
  { family = "Symbols Nerd Font Mono", weight = "Regular" },
  { family = "HackGen Console NF",     weight = "Regular" },
  { family = "Noto Color Emoji",       weight = "Regular" },
  { family = "Noto Emoji",             weight = "Medium" },
})
config.font_size = 16.0
config.window_frame = {
  font = wezterm.font_with_fallback({
    { family = "Intel One Mono",     weight = "Bold" },
    { family = "HackGen Console NF", weight = "Bold" },
  }),
  font_size = 14.0,
}

-- Rendering performance
-- WebGpu uses Metal on macOS (OpenGL is deprecated on macOS 10.14+)
config.front_end = "WebGpu"
config.max_fps = 120
config.animation_fps = 60

-- Window config
-- see: https://wezfurlong.org/wezterm/config/appearance.html?h=opacity#window-background-opacity
config.window_background_opacity = 0.85
-- Remove native title bar, keep resize handles
config.window_decorations = "RESIZE"

-- Padding for readability
config.window_padding = {
  left   = 8,
  right  = 8,
  top    = 4,
  bottom = 0,
}

-- Tab bar
-- use_fancy_tab_bar = false is required for format-tab-title event to fire
config.use_fancy_tab_bar = false
-- config.hide_tab_bar_if_only_one_tab = true

-- Scrollback
config.scrollback_lines = 10000

-- Double-click word selection boundary (adds code/URL-friendly chars)
config.selection_word_boundary = " \t\n{}[]()\"'`"

-- Hyperlink detection
config.hyperlink_rules = wezterm.default_hyperlink_rules()
table.insert(config.hyperlink_rules, {
  regex  = [[\b(https?://github\.com/[\w./-]+/(?:issues|pull)/\d+)\b]],
  format = "$1",
})

-- Keybinds
-- see: https://wezfurlong.org/wezterm/config/default-keys.html?h=disable_default
config.disable_default_key_bindings = true
local keybind = require("keybinds")
config.keys = keybind.keys
-- see: https://wezfurlong.org/wezterm/config/key-tables.html
config.key_tables = keybind.key_tables
config.leader = { key = "z", mods = "CTRL", timeout_milliseconds = 2000 }

-- Status
config.status_update_interval = 1000

-- Kitty Image Protocol Support
-- see: https://github.com/wez/wezterm/issues/986
config.enable_kitty_graphics = true

-- and finally, return the configuration to wezterm
return config
