-- Pull in the wezterm API
--
--TODO: Separate it into another file. This fails when only symlinking wezterm.lua without other files.
--      The Idea you can use is get the script path and use that for absolute paths.
function get_os_name()
	-- ask LuaJIT first
	if jit then
		return jit.os
	end

	-- Unix, Linux variants
	local fh, err = assert(io.popen("uname -o 2>/dev/null", "r"))
	if fh then
		osname = fh:read()
	end

	return osname or "Windows"
end

local wezterm = require("wezterm")

wezterm.on("toggle-opacity", function(window, pane)
	local overrides = window:get_config_overrides() or {}
	if not overrides.window_background_opacity then
		overrides.window_background_opacity = 0.7
	else
		overrides.window_background_opacity = nil
	end

	window:set_config_overrides(overrides)
end)

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- This is where you actually apply your config choices
-- For example, changing the color scheme:

-- local current_os = package.config:sub(1, 1) == "\\" and "win" or "unix"

local current_os = get_os_name()

-- Default shell
local default_shell = current_os ~= "Windows" and os.getenv("SHELL") or "nu.exe"
config.default_prog = { default_shell }

-- Colorscheme
config.color_scheme = "Catppuccin Mocha"

-- Font
config.font = wezterm.font_with_fallback({
	"JetBrainsMono Nerd Font",
	"CaskaydiaCove Nerd Font",
	"MesloLGS NF",
	"Noto Sans Mono CJK KR",
	"Menlo",
	"Monaco",
	"Courier New",
})
if current_os == "OSX" or current_os == "Darwin" then
	config.font_size = 18
else
	config.font_size = 13
end
-- Ligature
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }

-- FPS
config.max_fps = 144

-- Window
config.window_padding = {
	left = "3px",
	right = "3px",
	top = "3px",
	bottom = "3px",
}
config.window_background_image = wezterm.config_dir .. "/bg.jpg"
config.window_background_image_hsb = {
	brightness = 0.1,
}
config.window_background_opacity = 0.9

-- Windows
config.win32_system_backdrop = "Acrylic"

-- macOS
config.macos_window_background_blur = 10
config.native_macos_fullscreen_mode = true

-- Mouse
config.mouse_bindings = {
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "NONE",
		action = wezterm.action.Nop,
	},
}

-- Keybindings

-- Set a key binding to toggle the tab bar
-- @param key string: The key to bind
-- @param mods string: The modifiers to bind
-- @param action string: The action to bind
local function set_key_binding(key, mods, action)
	config.keys[#config.keys + 1] = { key = key, mods = mods, action = action }
end

-- config.disable_default_key_bindings = true
local act = wezterm.action
--
--  [ CTRL = CMD ]
--   [ ALT = OPT ]
config.keys = {
	{ key = "p", mods = "CTRL|ALT", action = act.ActivateCommandPalette },
	{ key = "r", mods = "CTRL|SHIFT", action = "ReloadConfiguration" },
	-- { key = "t", mods = "CTRL", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "w", mods = "ALT", action = act.CloseCurrentPane({ confirm = true }) },
	{ key = "Tab", mods = "CTRL|SHIFT", action = act.ActivateTabRelative(-1) },
	{ key = "Tab", mods = "CTRL", action = act.ActivateTabRelative(1) },
	{ key = "w", mods = "CTRL|SHIFT", action = act.CloseCurrentPane({ confirm = true }) },
	{ key = "Enter", mods = "CTRL|SHIFT", action = act.SpawnWindow },
	-- { key = "C", mods = "CTRL", action = act.CopyTo("ClipboardAndPrimarySelection") },
	-- { key = "V", mods = "CTRL", action = act.PasteFrom("Clipboard") },
	-- { key = "V", mods = "CTRL", action = act.PasteFrom("PrimarySelection") },
	{ key = "PageUp", mods = "SHIFT", action = act.ScrollByPage(-0.5) },
	{ key = "PageDown", mods = "SHIFT", action = act.ScrollByPage(0.5) },
	{ key = "x", mods = "CTRL|SHIFT", action = act.ActivateCopyMode },
	{ key = "B", mods = "CTRL", action = wezterm.action.EmitEvent("toggle-opacity") },
	{
		-- Select URL to open
		key = 'o', mods = 'CTRL|SHIFT', action = act.QuickSelectArgs {
			label = "open",
			patterns = { 'https?://\\S+'},
			action = wezterm.action_callback(function(window, pane)
				local url = window:get_selection_text_for_pane(pane)
				wezterm.open_with(url)
			end)
		}
	}
}

local dirs = { h = "Left", j = "Down", k = "Up", l = "Right" }

for key, direction in pairs(dirs) do
	-- -- Adjust pane size
	-- config.keys[#config.keys + 1] = { key = key, mods = "ALT", action = act.AdjustPaneSize({ direction, 5 }) }
	--
	-- config.keys[#config.keys + 1] = { key = key, mods = "CTRL", action = act.ActivatePaneDirection(direction) }

	config.keys[#config.keys + 1] = {
		key = key,
		mods = "CTRL|SHIFT",
		action = act.SplitPane({
			direction = direction,
			command = { domain = "CurrentPaneDomain" },
			size = { Percent = 50 },
		}),
	}
end

-- # Neovim-related

-- local smart_splits = require("modules.smart-splits")
-- for _, key in ipairs(smart_splits.get_keys(wezterm)) do
-- 	config.keys[#config.keys + 1] = key
-- end

-- and finally, return the configuration to wezterm
return config
