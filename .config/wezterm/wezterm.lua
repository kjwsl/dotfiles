-- Pull in the wezterm API
local utils = require("utils")
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

-- local current_os = package.config:sub(1, 1) == "\\" and "win" or "unix"

local current_os = utils.get_os_name()

-- Default shell
local default_shell = current_os ~= "Windows" and os.getenv("SHELL") or "pwsh.exe"
config.default_prog = { default_shell }

-- Colorscheme
config.color_scheme = "Catppuccin Mocha"

-- Font
config.font = wezterm.font_with_fallback({
    "CaskaydiaCove Nerd Font",
    "JetBrainsMono Nerd Font",
    "MesloLGS NF",
    "Noto Sans Mono CJK KR",
    "Menlo",
    "Monaco",
    "Courier New",
})
config.font_size = 18
-- Ligature
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }

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
    saturation = 1,
}
config.window_background_opacity = 0.9

-- Windows
config.win32_system_backdrop = "Acrylic"

-- macOS
config.macos_window_background_blur = 10
config.native_macos_fullscreen_mode = true

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
    { key = "p",        mods = "CTRL|ALT",   action = act.ActivateCommandPalette },
    { key = "r",        mods = "CTRL|SHIFT", action = "ReloadConfiguration" },
    -- { key = "t", mods = "CTRL", action = act.SpawnTab("CurrentPaneDomain") },
    { key = "w",        mods = "ALT",        action = act.CloseCurrentPane({ confirm = true }) },
    { key = "Tab",      mods = "CTRL|SHIFT", action = act.ActivateTabRelative(-1) },
    { key = "Tab",      mods = "CTRL",       action = act.ActivateTabRelative(1) },
    { key = "w",        mods = "CTRL|SHIFT", action = act.CloseCurrentPane({ confirm = true }) },
    { key = "Enter",    mods = "CTRL|SHIFT", action = act.SpawnWindow },
    -- { key = "C", mods = "CTRL", action = act.CopyTo("ClipboardAndPrimarySelection") },
    -- { key = "V", mods = "CTRL", action = act.PasteFrom("Clipboard") },
    -- { key = "V", mods = "CTRL", action = act.PasteFrom("PrimarySelection") },
    { key = "PageUp",   mods = "SHIFT",      action = act.ScrollByPage(-0.5) },
    { key = "PageDown", mods = "SHIFT",      action = act.ScrollByPage(0.5) },
    { key = "x",        mods = "CTRL|SHIFT", action = act.ActivateCopyMode },
}

local dirs = { Left = "h", Down = "j", Up = "k", Right = "l" }

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

-- # Neovim-related

-- Increase font size in Zen Mode
wezterm.on("user-var-changed", function(window, pane, name, value)
    local overrides = window:get_config_overrides() or {}
    if name == "ZEN_MODE" then
        local incremental = value:find("+")
        local number_value = tonumber(value)
        if incremental ~= nil then
            while number_value > 0 do
                window:perform_action(wezterm.action.IncreaseFontSize, pane)
                number_value = number_value - 1
            end
            overrides.enable_tab_bar = false
        elseif number_value < 0 then
            window:perform_action(wezterm.action.ResetFontSize, pane)
            overrides.font_size = nil
            overrides.enable_tab_bar = true
        else
            overrides.font_size = number_value
            overrides.enable_tab_bar = false
        end
    end
    window:set_config_overrides(overrides)
end)

-- and finally, return the configuration to wezterm
return config
