---------------------------
-- Default awesome theme --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local gears = require("gears")
local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()
local dir = os.getenv("HOME") .. "/.config/awesome/icons/"

local theme = {}

theme.black = "#282c34"
theme.black2 = "#0e1013"
theme.red = "#e06c75"
theme.dark_red = "#be5046"
theme.green = "#98c379"
theme.yellow = "#e5c07b"
theme.dark_yellow = "#d19a66"
theme.blue = "#61afef"
theme.magenta = "#c678dd"
theme.cyan = "#56b6c2"
theme.white = "#abb2bf"
theme.transparent = "#00000000"

theme.font = "JetBrainsMono Nerd Font Mono 18"
theme.font_normal = "JetBrainsMono Nerd Font 18"
theme.custom_font = "JetBrainsMono Nerd Font Mono "

theme.bg_normal = theme.black
theme.bg_focus = theme.red
theme.bg_urgent = theme.red
theme.bg_minimize = "#444444"

theme.bg_systray = theme.black2
theme.systray_icon_spacing = dpi(20)

theme.fg_normal = theme.white
theme.fg_focus = theme.white
theme.fg_urgent = "#ffffff"
theme.fg_minimize = "#ffffff"

theme.useless_gap = dpi(10)
theme.border_width = dpi(3)
theme.border_normal = theme.green
theme.border_focus = theme.red
theme.border_marked = "#91231c"

-- progress bar
theme.progressbar_bg = theme.black
theme.progressbar_fg = theme.red

-- cpu meter
theme.cpu_meter_color = theme.cyan
theme.memory_meter_color = theme.yellow
theme.hdd_meter_color = theme.magenta
theme.ssd_meter_color = theme.white

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
theme.taglist_bg_focus = theme.black

theme.tasklist_bg_normal = theme.black
theme.tasklist_bg_focus = theme.black
-- Generate taglist squares:
-- local taglist_square_size = dpi(4)
-- theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
--     taglist_square_size, theme.fg_normal
-- )
-- theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
--     taglist_square_size, theme.fg_normal
-- )

-- Variables set for theming notifications:
theme.notification_bg = theme.black2
theme.notification_border_width = 0
theme.notification_border_color = theme.black2
theme.notification_font = theme.custom_font .. "8"
theme.notification_icon_size = 50
theme.notification_shape = gears.shape.rounded_rect
theme.notification_width = 300
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_font = theme.custom_font .. "12"
theme.menu_submenu_icon = themes_path .. "default/submenu.png"
theme.menu_height = dpi(30)
theme.menu_width = dpi(170)
theme.menu_border_width = 0
theme.menu_border_color = theme.transparent
theme.menu_bg_normal = theme.black2
theme.menu_fg_normal = "#ffffff"
theme.menu_fg_focus = "#ffffff"
theme.menu_bg_focus = "#1f2329"

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
theme.wallpaper = os.getenv("HOME") .. "/Pictures/wallpapers/earth.jpg"

-- Define the image to load
theme.titlebar_close_button_normal = themes_path .. "default/titlebar/close_normal.png"
theme.titlebar_close_button_focus = themes_path .. "default/titlebar/close_focus.png"

theme.titlebar_minimize_button_normal = themes_path .. "default/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus = themes_path .. "default/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive = themes_path .. "default/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive = themes_path .. "default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = themes_path .. "default/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active = themes_path .. "default/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = themes_path .. "default/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive = themes_path .. "default/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = themes_path .. "default/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active = themes_path .. "default/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = themes_path .. "default/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive = themes_path .. "default/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = themes_path .. "default/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active = themes_path .. "default/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = themes_path .. "default/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive = themes_path .. "default/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = themes_path .. "default/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active = themes_path .. "default/titlebar/maximized_focus_active.png"

-- You can use your own layout icons like this:
theme.layout_fairh = themes_path .. "default/layouts/fairhw.png"
theme.layout_fairv = themes_path .. "default/layouts/fairvw.png"
theme.layout_floating = themes_path .. "default/layouts/floatingw.png"
theme.layout_magnifier = themes_path .. "default/layouts/magnifierw.png"
theme.layout_max = themes_path .. "default/layouts/maxw.png"
theme.layout_fullscreen = themes_path .. "default/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path .. "default/layouts/tilebottomw.png"
theme.layout_tileleft = themes_path .. "default/layouts/tileleftw.png"
theme.layout_tile = themes_path .. "default/layouts/tilew.png"
theme.layout_tiletop = themes_path .. "default/layouts/tiletopw.png"
theme.layout_spiral = themes_path .. "default/layouts/spiralw.png"
theme.layout_dwindle = themes_path .. "default/layouts/dwindlew.png"
theme.layout_cornernw = themes_path .. "default/layouts/cornernww.png"
theme.layout_cornerne = themes_path .. "default/layouts/cornernew.png"
theme.layout_cornersw = themes_path .. "default/layouts/cornersww.png"
theme.layout_cornerse = themes_path .. "default/layouts/cornersew.png"

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(theme.menu_height, theme.bg_focus, theme.fg_focus)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

-- wibar theme
theme.wibar_position = "top"
theme.wibar_bg = "#00000000"
theme.wibar_height = 40

-- sidebar theme
theme.sidebar_position = "left"
theme.sidebar_bg = theme.white .. "1F"
theme.sidebar_width = 500

-- icons
theme.volume_on_icon = dir .. "volume_up.svg"
theme.volume_off_icon = dir .. "volume_off.svg"
theme.brightness_icon = dir .. "brightness.svg"

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
