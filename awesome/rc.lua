-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout libraryd
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
naughty.config.defaults['icon_size'] = 150
naughty.config.defaults['width'] = 400
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget
-- Freedesktop menu
local freedesktop = require("freedesktop")
-- Enable VIM help for hotkeys widget when client with matching name is opened:
require("awful.hotkeys_popup.keys.vim")
-- Spotify integration
local spotify_widget = require("spotify")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors
    })
end
-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function(err)
        -- Make sure we don't go into an endless error loop
        if in_error then
            return
        end
        in_error = true
        naughty.notify({
            preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err)
        })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
-- Chosen colors and buttons look alike adapta maia theme
beautiful.init("/home/mateo/.config/awesome/theme.lua")

-- This is used later as the default terminal and editor to run.
browser = "google-chrome-stable"
filemanager = "exo-open --launch FileManager" or "thunar"
gui_editor = "mousepad"
terminal = "alacritty"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {awful.layout.suit.tile, awful.layout.suit.floating, awful.layout.suit.tile.bottom,
-- awful.layout.suit.tile.top,
                        awful.layout.suit.fair, awful.layout.suit.fair.horizontal, awful.layout.suit.max,
-- awful.layout.suit.max.fullscreen,
                        awful.layout.suit.magnifier}
-- }}}

-- {{{ Helper functions
local function client_menu_toggle_fn()
    local instance = nil
    return function()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({
                theme = {
                    width = 250
                }
            })
        end
    end
end
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {{"hotkeys", function()
    return false, hotkeys_popup.show_help
end, menubar.utils.lookup_icon("preferences-desktop-keyboard-shortcuts")},
                 {"manual", terminal .. " -e man awesome", menubar.utils.lookup_icon("system-help")},
                 {"edit config", gui_editor .. " " .. awesome.conffile,
                  menubar.utils.lookup_icon("accessories-text-editor")},
                 {"restart", awesome.restart, menubar.utils.lookup_icon("system-restart")}}
myexitmenu = {{"log out", function()
    awesome.quit()
end, menubar.utils.lookup_icon("system-log-out")},
              {"suspend", "systemctl suspend", menubar.utils.lookup_icon("system-suspend")},
              {"hibernate", "systemctl hibernate", menubar.utils.lookup_icon("system-suspend-hibernate")},
              {"reboot", "systemctl reboot", menubar.utils.lookup_icon("system-reboot")},
              {"shutdown", "poweroff", menubar.utils.lookup_icon("system-shutdown")}}
mymainmenu = freedesktop.menu.build({
    icon_size = 32,
    before = {{"Terminal", terminal, menubar.utils.lookup_icon("utilities-terminal")},
              {"Browser", browser, menubar.utils.lookup_icon("internet-web-browser")},
              {"Files", filemanager, menubar.utils.lookup_icon("system-file-manager")}},
    after = {{"Awesome", myawesomemenu, "/usr/share/awesome/icons/awesome32.png"},
             {"Exit", myexitmenu, menubar.utils.lookup_icon("system-shutdown")}}
})
mylauncher = awful.widget.launcher({
    image = beautiful.awesome_icon,
    menu = mymainmenu
})
-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock("%H:%M ")
mytextdate = wibox.widget.textclock("<b>%d %b %Y </b>")
-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

darkblue = beautiful.bg_focus
blue = "#9EBABA"
red = "#EB8F8F"
separator = wibox.widget.textbox(' <span color="' .. blue .. '">| </span>')
spacer = wibox.widget.textbox(' <span color="' .. blue .. '"> </span>')

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(awful.button({}, 1, function(t)
    t:view_only()
end), awful.button({modkey}, 1, function(t)
    if client.focus then
        client.focus:move_to_tag(t)
    end
end), awful.button({}, 3, awful.tag.viewtoggle), awful.button({modkey}, 3, function(t)
    if client.focus then
        client.focus:toggle_tag(t)
    end
end), awful.button({}, 4, function(t)
    awful.tag.viewnext(t.screen)
end), awful.button({}, 5, function(t)
    awful.tag.viewprev(t.screen)
end))

local tasklist_buttons = gears.table.join(awful.button({}, 1, function(c)
    if c == client.focus then
        c.minimized = true
    else
        -- Without this, the following
        -- :isvisible() makes no sense
        c.minimized = false
        if not c:isvisible() and c.first_tag then
            c.first_tag:view_only()
        end
        -- This will also un-minimize
        -- the client, if needed
        client.focus = c
        c:raise()
    end
end), awful.button({}, 3, client_menu_toggle_fn()), awful.button({}, 4, function()
    awful.client.focus.byidx(1)
end), awful.button({}, 5, function()
    awful.client.focus.byidx(-1)
end))

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)
    local l = awful.layout.suit -- Alias to save time :)
    
    local layouts = {l.tile, l.max, l.tile, l.max, l.max, l.tile}
    -- Each screen has its own tag table.
    awful.tag({"", "", "", "", "", ""}, s, layouts)
    -- awful.tag({ "term", "web", "code", "music", "chat", "pass" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.layouttimer = gears.timer({
        timeout = 2
    })
    s.set_active_tag = function(self, c3, index, objects)
        local selected_tag = s.selected_tags[1]
        local clients = s.tags[index]:clients()
        if index == selected_tag.index then
            self:get_children_by_id("underline")[1].bg = beautiful.red
        elseif #clients > 0 then
            self:get_children_by_id("underline")[1].bg = beautiful.yellow
        else
            self:get_children_by_id("underline")[1].bg = beautiful.black
        end
    end
    s.layoutlist = awful.widget.layoutlist {
        base_layout = wibox.widget {
            spacing = 5,
            forced_num_cols = 4,
            layout = wibox.layout.grid.vertical
        },
        widget_template = {
            {
                {
                    id = 'icon_role',
                    forced_height = 40,
                    forced_width = 40,
                    widget = wibox.widget.imagebox
                },
                margins = 4,
                widget = wibox.container.margin
            },
            id = 'background_role',
            forced_width = 60,
            forced_height = 60,
            shape = gears.shape.rounded_rect,
            widget = wibox.container.background

        }
    }
    s.layoutpopup = awful.popup {
        widget = wibox.widget {
            s.layoutlist,
            margins = 4,
            widget = wibox.container.margin
        },
        border_width = 5,
        border_color = beautiful.red,
        fg = beautiful.red,
        maximum_height = #awful.layout.layouts * 18,
        minimum_height = #awful.layout.layouts * 18,
        placement = awful.placement.centered,
        ontop = true,
        visible = false,
        shape = gears.shape.rounded_rect,
				screen = s
    }
    s.layouttimer:connect_signal("timeout", function()
        s.layoutpopup.visible = false
        screen.layouttimer:stop()
    end)
    s.layoutpopup:connect_signal("mouse::enter", function()
        s.layouttimer:stop()
    end)
    s.layoutpopup:connect_signal("mouse::leave", function()
        s.layouttimer:start()
    end)
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen = s,
        filter = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
        widget_template = {
            {
                layout = wibox.layout.align.vertical,
                expand = "none",
                nil,
                {
                    {
                        {
                            id = 'text_role',
                            widget = wibox.widget.textbox
                        },
                        layout = wibox.layout.fixed.horizontal
                    },
                    left = 20,
                    right = 20,
                    widget = wibox.container.margin
                },
                {
                    {
                        left = 20,
                        right = 20,
                        top = 5,
                        widget = wibox.container.margin
                    },
                    id = 'underline',
                    shape = gears.shape.rectangle,
                    widget = wibox.container.background
                }
            },
            id = "background_role",
            widget = wibox.container.background,
            bg = beautiful.red,
            create_callback = s.set_active_tag,
            update_callback = s.set_active_tag
        }
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

    -- Create the wibox
    s.mywibox = awful.wibar({
        position = beautiful.wibar_position,
        screen = s
    })

    s.systray = wibox.widget.systray()
    s.systray.set_base_size(25)

    -- Add widgets to the wibox
    s.mywibox:setup{
        {
            layout = wibox.layout.align.horizontal,
            expand = "none",
            {
                layout = wibox.layout.fixed.horizontal,
                spacing = 10,
                { -- Left widgets
                    { 
                        layout = wibox.layout.fixed.horizontal,
                        s.mytaglist
                    },
                    widget = wibox.container.background,
                    bg = beautiful.black,
                    shape = gears.shape.rounded_rect
                },
                {
                    {
                        s.mytasklist,
                        widget = wibox.container.margin,
                        left = 20,
                        right = 20
                    },
                    widget = wibox.container.background,
                    bg = beautiful.black,
                    shape = gears.shape.rounded_rect
                },
            },
            nil,
            {
                layout = wibox.layout.fixed.horizontal,
                spacing = 10,
                {
                    { -- Middle widget
                        {
                            spotify_widget({
                                max_length = -1
                            }),
                            widget = wibox.container.margin,
                            right = 20,
                            left = 20
                        },
                        widget = wibox.container.background,
                        bg = beautiful.green,
                        fg = beautiful.black,
                        shape = gears.shape.rounded_rect
                    },
                    {
                        {
                            s.systray,
                            widget = wibox.container.margin,
                            left = 20,
                            right = 20,
                            top = 3
                        },
                        widget = wibox.container.background,
                        bg = beautiful.black,
                        shape = gears.shape.rounded_rect
                    },
                    layout = wibox.layout.fixed.horizontal,
                    spacing = 10
                },
                {
                    {
                        mytextclock,
                        widget = wibox.container.margin,
                        left = 10,
                        right = 10,
                        top = 3
                    },
                    widget = wibox.container.background,
                    bg = beautiful.black,
                    shape = gears.shape.rounded_rect
                },
                {
                    {
                        mytextdate,
                        widget = wibox.container.margin,
                        left = 10,
                        right = 10,
                        top = 3
                    },
                    widget = wibox.container.background,
                    bg = beautiful.blue,
                    fg = beautiful.black,
                    shape = gears.shape.rounded_rect
                }
            }
        },
        widget = wibox.container.margin,
        top = 10,
        left = beautiful.useless_gap * 2,
        right = beautiful.useless_gap * 2
    }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(awful.button({}, 1, function()
    mymainmenu:hide()
end), awful.button({}, 3, function()
    mymainmenu:toggle()
end), awful.button({}, 4, awful.tag.viewnext), awful.button({}, 5, awful.tag.viewprev)))
-- }}}

-- {{{ Key bindings
require('keys')

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {{
    rule = {},
    properties = {
        border_width = beautiful.border_width,
        border_color = beautiful.border_normal,
        focus = awful.client.focus.filter,
        raise = true,
        keys = clientkeys,
        buttons = clientbuttons,
        size_hints_honor = false, -- Remove gaps between terminals
        screen = awful.screen.preferred,
        callback = awful.client.setslave,
        placement = awful.placement.no_overlap + awful.placement.no_offscreen
    }
}, {
    rule = {
        name = {"Microsoft Teams Notification"}
    },
    properties = {
        focus = false,
        ontop = true,
        floating = true
    }
}, {
    rule_any = {
        instance = {"DTA", -- Firefox addon DownThemAll.
        "copyq" -- Includes session name in class.
        },
        class = {"Arandr", "Gpick", "Kruler", "MessageWin", -- kalarm.
        "Sxiv", "Wpa_gui", "pinentry", "veromix", "xtightvncviewer"},

        name = {"Event Tester" -- xev.
        },
        role = {"AlarmWindow", -- Thunderbird's calendar.
        "pop-up" -- e.g. Google Chrome's (detached) Developer Tools.
        }
    },
    properties = {
        floating = true
    }
}, {
    rule_any = {
        type = {"normal", "dialog"}
    },
    properties = {
        titlebars_enabled = false,
        shape = gears.shape.rounded_rect
    }
}, {
    rule = {
        class = "Alacritty"
    },
    properties = {
        screen = awful.screen.focused(),
        tag = awful.screen.focused().tags[1]
    }
}, {
    rule = {
        role = "^browser$"
    },
    properties = {
        screen = awful.screen.focused(),
        tag = awful.screen.focused().tags[2]
    }
}, {
    rule = {
        class = "Slack"
    },
    properties = {
        screen = awful.screen.focused(),
        tag = awful.screen.focused().tags[5]
    }
}, {
    rule = {
        class = "Microsoft Teams - Preview"
    },
    properties = {
        screen = awful.screen.focused(),
        tag = awful.screen.focused().tags[5]
    }
}}
-- }}}

-- {{{ Signals

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

client.connect_signal("focus", function(c)
    c.border_color = beautiful.border_focus
end)
client.connect_signal("unfocus", function(c)
    c.border_color = beautiful.border_normal
end)

-- Disable borders on lone windows
-- Handle border sizes of clients.
for s = 1, screen.count() do
    screen[s]:connect_signal("arrange", function()
        local clients = awful.client.visible(s)
        local layout = awful.layout.getname(awful.layout.get(s))

        for _, c in pairs(clients) do
            -- No borders with only one humanly visible client
            if c.maximized then
                -- NOTE: also handled in focus, but that does not cover maximizing from a
                -- tiled state (when the client had focus).
                c.border_width = 0
            elseif c.floating or layout == "floating" then
                c.border_width = beautiful.border_width
            elseif layout == "max" or layout == "fullscreen" then
                c.border_width = 0
            else
                local tiled = awful.client.tiled(c.screen)
                if #tiled == 1 then -- and c == tiled[1] then
                    tiled[1].border_width = 0
                    -- if layout ~= "max" and layout ~= "fullscreen" then
                    -- XXX: SLOW!
                    -- awful.client.moveresize(0, 0, 2, 0, tiled[1])
                    -- end
                else
                    c.border_width = beautiful.border_width
                end
            end
        end
    end)
end

-- }}}

-- client.connect_signal("property::floating", function (c)
--    if c.floating then
--        awful.titlebar.show(c)
--    else
--        awful.titlebar.hide(c)
--    end
-- end)

awful.spawn.with_shell("~/.config/awesome/autorun.sh")

