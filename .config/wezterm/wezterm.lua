local wezterm = require 'wezterm'

-- wezterm.on('format-window-title', function(tab, pane, tabs, panes, config)
--   local zoomed = ''
--   if tab.active_pane.is_zoomed then
--     zoomed = '[Z] '
--   end

--   local index = ''
--   if #tabs > 1 then
--     index = string.format('[%d/%d] ', tab.tab_index + 1, #tabs)
--   end

--   return zoomed .. index .. tab.active_pane.title
-- end)


return {
  -- font = wezterm.font 'Victor Mono',
  -- You can specify some parameters to influence the font selection;
  -- for example, this selects a Bold, Italic font variant.
  font = wezterm.font('Victor Mono', { weight = 'Medium' }),
  font_size = 16,
  color_scheme = "Catppuccin Mocha",
  tab_bar_at_bottom = true,
  -- window_decorations = "RESIZE",
}
