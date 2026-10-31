-- Adjust font_size dynamically according to the display the window is on.
local wezterm = require("wezterm")

local M = {}

-- Fallback when screen info is unavailable
M.default = 16.0

-- Rules are evaluated top to bottom; the first one whose max_width
-- (logical width in points, e.g. "looks like 1440x900" -> 1440) is >= the
-- active screen's logical width wins.
local RULES = {
  { max_width = 1600,      font_size = 14.0 }, -- MacBook built-in (1440x900, 1512x982 ...)
  { max_width = 2200,      font_size = 16.0 }, -- FHD class external (1920x1080 ...)
  { max_width = math.huge, font_size = 18.0 }, -- WQHD / 4K class external (2560x1440 ...)
}

-- wezterm reports screen size in physical pixels. effective_dpi is
-- 72 * backing scale on macOS and 96 * scale elsewhere.
local BASE_DPI = wezterm.target_triple:find("darwin") and 72 or 96

local function logical_width(screen)
  local dpi = screen.effective_dpi or BASE_DPI
  return screen.width * BASE_DPI / dpi
end

local function font_size_for(width)
  for _, rule in ipairs(RULES) do
    if width <= rule.max_width then
      return rule.font_size
    end
  end
  return M.default
end

local function apply(window)
  -- gui.screens().active is the screen holding the focused window,
  -- so only the focused window can judge which display it is on.
  if not window:is_focused() then
    return
  end

  local ok, screens = pcall(wezterm.gui.screens)
  if not ok or not screens or not screens.active then
    return
  end

  local screen = screens.active
  local size = font_size_for(logical_width(screen))

  local overrides = window:get_config_overrides() or {}
  -- set_config_overrides re-fires window-config-reloaded; skip if unchanged
  if overrides.font_size == size then
    return
  end

  wezterm.log_info(string.format(
    "font_size: %s (%dx%d px, dpi=%s) -> %.1f",
    screen.name, screen.width, screen.height, tostring(screen.effective_dpi), size
  ))
  overrides.font_size = size
  window:set_config_overrides(overrides)
end

-- Initial apply, moving to a display with a different scale, focus change,
-- and periodic check (status_update_interval) for same-scale display moves
wezterm.on("window-config-reloaded", apply)
wezterm.on("window-resized", apply)
wezterm.on("window-focus-changed", apply)
wezterm.on("update-status", apply)

return M
