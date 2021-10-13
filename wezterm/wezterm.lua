local wezterm = require("wezterm")

local colors = {
  normal = {"#282c34", "#e06c75", "#98c379", "#e5c07b", "#61afef", "#c678dd", "#56b6c2", "#abb2bf"},
  bright = {"#3e4452", "#be5046", "#98c379", "#e5c07b", "#61afef", "#c678dd", "#56b6c2", "#5c6370"}
}

wezterm.on(
  "format-tab-title",
  function(tab)
    local name = " " .. string.gmatch(tab.active_pane.title, "%w+ ")()
    return {
      {Text = name}
    }
  end
)

return {
  font = wezterm.font("JetBrainsMono Nerd Font"),
  font_size = 14,
  colors = {
    background = "#282c34",
    foreground = "#abb2bf",
    cursor_fg = "#282c34",
    cursor_bg = "#abb2bf",
    cursor_border = "#abb2bf",
    ansi = colors.normal,
    brights = colors.bright,
    tab_bar = {
      background = colors.normal[1],
      active_tab = {
        bg_color = colors.normal[3],
        fg_color = colors.normal[1],
        intensity = "Bold"
      },
      inactive_tab = {
        bg_color = colors.normal[1],
        fg_color = colors.normal[8]
      },
      inactive_tab_hover = {
        bg_color = colors.normal[1],
        fg_color = colors.normal[3],
        intensity = "Bold"
      },
      new_tab = {
        bg_color = colors.normal[1],
        fg_color = colors.normal[8]
      },
      new_tab_hover = {
        bg_color = colors.normal[3],
        fg_color = colors.normal[1]
      }
    }
  },
  window_padding = {
    left = 10,
    right = 10,
    top = 10,
    bottom = 10
  },
  tab_bar_at_bottom = true,
  show_tab_index_in_tab_bar = false,
  keys = {
    {key = "C", mods = "CTRL|SHIFT", action = wezterm.action {CopyTo = "Clipboard"}},
    {key = "V", mods = "CTRL|SHIFT", action = wezterm.action {PasteFrom = "Clipboard"}},
    {key = "LeftArrow", mods = "CTRL|SHIFT", action = wezterm.action {ActivateTabRelative = -1}},
    {key = "RightArrow", mods = "CTRL|SHIFT", action = wezterm.action {ActivateTabRelative = 1}},
    {key = "H", mods = "CTRL|SHIFT", action = wezterm.action {SplitHorizontal = {domain = "CurrentPaneDomain"}}},
    {key = "E", mods = "CTRL|SHIFT", action = wezterm.action {SplitVertical = {domain = "CurrentPaneDomain"}}},
    {key = "RightArrow", mods = "CTRL|ALT", action = wezterm.action {ActivatePaneDirection = "Right"}},
    {key = "LeftArrow", mods = "CTRL|ALT", action = wezterm.action {ActivatePaneDirection = "Left"}},
    {key = "UpArrow", mods = "CTRL|ALT", action = wezterm.action {ActivatePaneDirection = "Up"}},
    {key = "DownArrow", mods = "CTRL|ALT", action = wezterm.action {ActivatePaneDirection = "Down"}}
  }
}
