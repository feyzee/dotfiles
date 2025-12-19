local wezterm = require("wezterm")
local config = wezterm.config_builder()
local action = wezterm.action

local fontFamily = "VictorMono Nerd Font"
local fontWeight = "Medium"

wezterm.on("update-right-status", function(window, pane)
	-- Each element holds the text for a cell in a "powerline" style << fade
	local cells = {}

	-- Figure out the cwd and host of the current pane.
	-- This will pick up the hostname for the remote host if your
	-- shell is using OSC 7 on the remote host.
	local cwd_uri = pane:get_current_working_dir()
	if cwd_uri then
		local cwd = ""

		if type(cwd_uri) == "userdata" then
			-- Running on a newer version of wezterm and we have
			-- a URL object here, making this simple!

			cwd = cwd_uri.file_path
		else
			-- an older version of wezterm, 20230712-072601-f4abf8fd or earlier,
			-- which doesn't have the Url object
			cwd_uri = cwd_uri:sub(8)
			local slash = cwd_uri:find("/")
			if slash then
				-- and extract the cwd from the uri, decoding %-encoding
				cwd = cwd_uri:sub(slash):gsub("%%(%x%x)", function(hex)
					return string.char(tonumber(hex, 16))
				end)
			end
		end

		table.insert(cells, cwd)
	end

	-- I like my date/time in this style: "Wed Mar 3 08:14"
	local date = wezterm.strftime("%a %b %-d %I:%M %p")
	table.insert(cells, date)

	local cwd_workspace = window:active_workspace()
	table.insert(cells, cwd_workspace)

	-- The powerline < symbol
	local LEFT_ARROW = utf8.char(0xe0b3)
	-- The filled in variant of the < symbol
	local SOLID_LEFT_ARROW = utf8.char(0xe0b2)

	-- Color palette for the backgrounds of each cell
	local colors = {
		"#3c1361",
		"#52307c",
		"#663a82",
		"#7c5295",
		"#b491c8",
	}

	-- Foreground color for the text across the fade
	local text_fg = "#c0c0c0"

	-- The elements to be formatted
	local elements = {}
	-- How many cells have been formatted
	local num_cells = 0

	-- Translate a cell into elements
	function push(text, is_last)
		local cell_no = num_cells + 1
		table.insert(elements, { Foreground = { Color = text_fg } })
		table.insert(elements, { Background = { Color = colors[cell_no] } })
		table.insert(elements, { Text = " " .. text .. " " })
		if not is_last then
			table.insert(elements, { Foreground = { Color = colors[cell_no + 1] } })
			table.insert(elements, { Text = SOLID_LEFT_ARROW })
		end
		num_cells = num_cells + 1
	end

	while #cells > 0 do
		local cell = table.remove(cells, 1)
		push(cell, #cells == 0)
	end

	window:set_right_status(wezterm.format(elements))
end)

-- Font
config.font_size = 14
config.font = wezterm.font_with_fallback({
	{ family = fontFamily, weight = fontWeight },
	{ family = "JetBrainsMono Nerd Font", weight = fontWeight },
})

config.font_rules = {
	{ -- italic
		intensity = "Normal",
		italic = true,
		font = wezterm.font({
			family = fontFamily,
			weight = fontWeight,
			italic = true,
		}),
	},
	{ -- bold
		intensity = "Bold",
		italic = false,
		font = wezterm.font({
			family = fontFamily,
			weight = "Bold",
		}),
	},
	{ -- italic bold
		intensity = "Bold",
		italic = true,
		font = wezterm.font({
			family = fontFamily,
			weight = "Bold",
			italic = true,
		}),
	},
}

config.freetype_load_target = "Normal"

-- Theme
-- config.color_scheme = 'Catppuccin Latte'
config.color_scheme = "Catppuccin Macchiato"

-- UI Config
config.inactive_pane_hsb = {
	saturation = 0.9,
	brightness = 0.8,
}
config.front_end = "WebGpu"
config.animation_fps = 1
config.default_cursor_style = "BlinkingBar"
config.cursor_blink_rate = 500
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"
config.cursor_thickness = "1.5px"
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = "RESIZE"
config.tab_bar_at_bottom = true
config.tab_max_width = 100

-- Session managment
local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")
local workspace_resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")

workspace_switcher.zoxide_path = "/usr/bin/zoxide" -- set path to zoxide

-- Keyboard shortcuts
config.keys = {
	{ key = "t", mods = "ALT|SHIFT", action = action.ShowTabNavigator },
	{ key = "z", mods = "ALT|SHIFT", action = action.ToggleFullScreen },
	{ -- split horizontal
		key = "_",
		mods = "ALT|SHIFT",
		action = wezterm.action.SplitPane({
			direction = "Down",
			size = { Percent = 50 },
			top_level = true,
		}),
	},
	{ -- split vertical
		key = "|",
		mods = "ALT|SHIFT",
		action = wezterm.action.SplitPane({
			direction = "Right",
			size = { Percent = 50 },
			top_level = true,
		}),
	},
	{
		key = "R",
		mods = "ALT|SHIFT",
		action = action.PromptInputLine({
			description = "Enter new name for tab",
			action = wezterm.action_callback(function(window, _, line)
				-- line will be `nil` if they hit escape without entering anything
				-- An empty string if they just hit enter
				-- Or the actual line of text they wrote
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
	-- session managment shortcuts
	{ key = "p", mods = "ALT|SHIFT", action = workspace_switcher.switch_workspace() },
	{ key = "n", mods = "ALT|SHIFT", action = action.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
	{
		key = "s",
		mods = "ALT|SHIFT",
		action = wezterm.action_callback(function(win, pane)
			workspace_resurrect.state_manager.save_state(workspace_resurrect.workspace_state.get_workspace_state())
			workspace_resurrect.window_state.save_window_action()
		end),
	},
	{
		key = "w",
		mods = "ALT|SHIFT",
		action = wezterm.action_callback(function(win, pane)
			workspace_resurrect.fuzzy_loader.fuzzy_load(win, pane, function(id, label)
				local type = string.match(id, "^([^/]+)") -- match before '/'
				id = string.match(id, "([^/]+)$") -- match after '/'
				id = string.match(id, "(.+)%..+$") -- remove file extention
				local opts = {
					relative = true,
					restore_text = true,
					on_pane_restore = workspace_resurrect.tab_state.default_on_pane_restore,
				}
				if type == "workspace" then
					local state = workspace_resurrect.state_manager.load_state(id, "workspace")
					workspace_resurrect.workspace_state.restore_workspace(state, opts)
				elseif type == "window" then
					local state = workspace_resurrect.state_manager.load_state(id, "window")
					workspace_resurrect.window_state.restore_window(pane:window(), state, opts)
				elseif type == "tab" then
					local state = workspace_resurrect.state_manager.load_state(id, "tab")
					workspace_resurrect.tab_state.restore_tab(pane:tab(), state, opts)
				end
			end)
		end),
	},
}

return config
