-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- This is where you actually apply your config choices
-- For example, changing the color scheme:

local current_os = package.config:sub(1, 1) == "\\" and "win" or "unix"
-- Default shell
local default_shell = current_os == "unix" and "/usr/bin/fish" or "pwsh.exe"
config.default_prog = { default_shell }

-- Colorscheme
config.color_scheme = "Catppuccin Mocha"

-- Font
config.font = wezterm.font_with_fallback({
	"CaskaydiaCove Nerd Font",
	"Helvetica",
	"Arial",
})
config.font_size = 13.0
-- Ligature
config.harfbuzz_features = { "calt=0", "clig=0", "liga=1" }

-- Window
config.window_padding = {
	left = "0px",
	right = "0px",
	top = "0px",
	bottom = "0px",
}
config.window_background_opacity = 0.9

-- Keybindings

-- Set a key binding to toggle the tab bar
-- @param key string: The key to bind
-- @param mods string: The modifiers to bind
-- @param action string: The action to bind
local function set_key_binding(key, mods, action)
	config.keys[#config.keys + 1] = { key = key, mods = mods, action = action }
end

config.disable_default_key_bindings = true
local act = wezterm.action
local dirs = { Left = "h", Down = "j", Up = "k", Right = "l" }
config.keys = {
	{ key = "p", mods = "CTRL|ALT", action = act.ActivateCommandPalette },
	{ key = "r", mods = "CTRL|SHIFT", action = "ReloadConfiguration" },
	{ key = "t", mods = "CTRL", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "w", mods = "ALT", action = act.CloseCurrentPane({ confirm = true }) },
	{ key = "Tab", mods = "CTRL|SHIFT", action = act.ActivateTabRelative(-1) },
	{ key = "Tab", mods = "CTRL", action = act.ActivateTabRelative(1) },
	{ key = "w", mods = "CTRL|SHIFT", action = act.CloseCurrentPane({ confirm = true }) },
	{ key = "Enter", mods = "CTRL", action = act.SpawnWindow },
	{ key = "C", mods = "CTRL", action = act.CopyTo("ClipboardAndPrimarySelection") },
	{ key = "V", mods = "CTRL", action = act.PasteFrom("Clipboard") },
	{ key = "V", mods = "CTRL", action = act.PasteFrom("PrimarySelection") },
	{ key = "PageUp", mods = "SHIFT", action = act.ScrollByPage(-0.5) },
	{ key = "PageDown", mods = "SHIFT", action = act.ScrollByPage(0.5) },
}

for direction, key in pairs(dirs) do
	-- Adjust pane size
	config.keys[#config.keys + 1] =
		{ key = key, mods = "CTRL|SHIFT|ALT", action = act.AdjustPaneSize({ direction, 5 }) }

	config.keys[#config.keys + 1] = { key = key, mods = "ALT", action = act.ActivatePaneDirection(direction) }

	config.keys[#config.keys + 1] = {
		key = key,
		mods = "CTRL|ALT",
		action = act.SplitPane({
			direction = direction,
			command = { domain = "CurrentPaneDomain" },
			size = { Percent = 50 },
		}),
	}
end

-- and finally, return the configuration to wezterm
return config
