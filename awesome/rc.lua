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
-- naughty.config.defaults["icon_size"] = 150
-- naughty.config.defaults["width"] = 400
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget
-- Freedesktop menu
local freedesktop = require("freedesktop")
-- Enable VIM help for hotkeys widget when client with matching name is opened:
require("awful.hotkeys_popup.keys.vim")

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
-- Chosen colors and buttons look alike adapta maia theme
beautiful.init("/home/mateo/.config/awesome/theme.lua")

require("sidebar")
require("logout.logout")

local tagnames = {"", "", "阮", "", "漣"}

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
  naughty.notify(
    {
      preset = naughty.config.presets.critical,
      title = "Oops, there were errors during startup!",
      text = awesome.startup_errors
    }
  )
end
-- Handle runtime errors after startup
do
  local in_error = false
  awesome.connect_signal(
    "debug::error",
    function(err)
      -- Make sure we don't go into an endless error loop
      if in_error then
        return
      end
      in_error = true
      naughty.notify(
        {
          preset = naughty.config.presets.critical,
          title = "Oops, an error happened!",
          text = tostring(err)
        }
      )
      in_error = false
    end
  )
end
-- }}}

-- This is used later as the default terminal and editor to run.
browser = "firefox"
filemanager = "dolphin"
gui_editor = "mousepad"
terminal = "kitty"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
  awful.layout.suit.tile,
  awful.layout.suit.floating,
  awful.layout.suit.tile.bottom,
  -- awful.layout.suit.tile.top,
  awful.layout.suit.fair,
  awful.layout.suit.fair.horizontal,
  awful.layout.suit.max,
  -- awful.layout.suit.max.fullscreen,
  awful.layout.suit.magnifier
}
-- }}}

-- {{{ Helper functions
local function client_menu_toggle_fn()
  local instance = nil
  return function()
    if instance and instance.wibox.visible then
      instance:hide()
      instance = nil
    else
      instance =
        awful.menu.clients(
        {
          theme = {
            width = 250
          }
        }
      )
    end
  end
end
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
  {
    "hotkeys",
    function()
      return false, hotkeys_popup.show_help
    end,
    menubar.utils.lookup_icon("preferences-desktop-keyboard-shortcuts")
  },
  {"manual", terminal .. " -e man awesome", menubar.utils.lookup_icon("system-help")},
  {
    "edit config",
    gui_editor .. " " .. awesome.conffile,
    menubar.utils.lookup_icon("accessories-text-editor")
  },
  {"restart", awesome.restart, menubar.utils.lookup_icon("system-restart")}
}
myexitmenu = {
  {
    "log out",
    function()
      awesome.quit()
    end,
    menubar.utils.lookup_icon("system-log-out")
  },
  {"suspend", "systemctl suspend", menubar.utils.lookup_icon("system-suspend")},
  {"hibernate", "systemctl hibernate", menubar.utils.lookup_icon("system-suspend-hibernate")},
  {"reboot", "systemctl reboot", menubar.utils.lookup_icon("system-reboot")},
  {"shutdown", "poweroff", menubar.utils.lookup_icon("system-shutdown")}
}
mymainmenu =
  freedesktop.menu.build(
  {
    icon_size = 32,
    before = {
      {"Terminal", terminal, menubar.utils.lookup_icon("utilities-terminal")},
      {"Browser", browser, menubar.utils.lookup_icon("internet-web-browser")},
      {"Files", filemanager, menubar.utils.lookup_icon("system-file-manager")}
    },
    after = {
      {"Awesome", myawesomemenu, "/usr/share/awesome/icons/awesome32.png"},
      {"Exit", myexitmenu, menubar.utils.lookup_icon("system-shutdown")}
    }
  }
)
mylauncher =
  awful.widget.launcher(
  {
    image = beautiful.awesome_icon,
    menu = mymainmenu
  }
)
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
local taglist_buttons =
  gears.table.join(
  awful.button(
    {},
    1,
    function(t)
      t:view_only()
    end
  ),
  awful.button(
    {modkey},
    1,
    function(t)
      if client.focus then
        client.focus:move_to_tag(t)
      end
    end
  ),
  awful.button({}, 3, awful.tag.viewtoggle),
  awful.button(
    {modkey},
    3,
    function(t)
      if client.focus then
        client.focus:toggle_tag(t)
      end
    end
  ),
  awful.button(
    {},
    4,
    function(t)
      awful.tag.viewnext(t.screen)
    end
  ),
  awful.button(
    {},
    5,
    function(t)
      awful.tag.viewprev(t.screen)
    end
  )
)

local tasklist_buttons =
  gears.table.join(
  awful.button(
    {},
    1,
    function(c)
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
    end
  ),
  awful.button({}, 3, client_menu_toggle_fn()),
  awful.button(
    {},
    4,
    function()
      awful.client.focus.byidx(1)
    end
  ),
  awful.button(
    {},
    5,
    function()
      awful.client.focus.byidx(-1)
    end
  )
)

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

awful.screen.connect_for_each_screen(
  function(s)
    -- Wallpaper
    set_wallpaper(s)
    local l = awful.layout.suit -- Alias to save time :)

    local layouts = {l.tile, l.max, l.max, l.max, l.tile}
    -- Each screen has its own tag table.
    awful.tag(tagnames, s, layouts)

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    -- Create a taglist widget
    s.mytaglist =
      awful.widget.taglist {
      screen = s,
      filter = awful.widget.taglist.filter.all,
      buttons = taglist_buttons,
      style = {
        shape = gears.shape.circle,
        fg_focus = beautiful.black,
        bg_focus = beautiful.white,
        bg_occupied = beautiful.black,
        bg_empty = beautiful.black
      },
      layout = wibox.layout.fixed.horizontal,
      widget_template = {
        {
          {
            id = "text_role",
            widget = wibox.widget.textbox
          },
          left = 20,
          right = 20,
          widget = wibox.container.margin
        },
        id = "background_role",
        widget = wibox.container.background
      }
    }

    -- Create the wibox
    s.mywibox =
      awful.wibar(
      {
        position = beautiful.wibar_position,
        screen = s
      }
    )

    s.sidebar = sidebar(s)

    -- Add widgets to the wibox
    s.mywibox:setup {
      {
        layout = wibox.layout.align.horizontal,
        expand = "none",
        nil,
        {
          {
            layout = wibox.layout.flex.horizontal,
            s.mytaglist
          },
          widget = wibox.container.background,
          bg = beautiful.transparent
        },
        nil
      },
      widget = wibox.container.margin
    }
  end
)
-- }}}

-- {{{ Mouse bindings
root.buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      function()
        mymainmenu:hide()
      end
    ),
    awful.button(
      {},
      3,
      function()
        mymainmenu:toggle()
      end
    ),
    awful.button({}, 4, awful.tag.viewnext),
    awful.button({}, 5, awful.tag.viewprev)
  )
)
-- }}}

-- {{{ Key bindings
require("keys")

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
  {
    rule = {},
    properties = {
      focus = awful.client.focus.filter,
      raise = true,
      keys = clientkeys,
      buttons = clientbuttons,
      size_hints_honor = false, -- Remove gaps between terminals
      callback = awful.client.setslave,
      placement = awful.placement.no_overlap + awful.placement.no_offscreen
    }
  },
  {
    rule = {
      class = "kitty"
    },
    properties = {
      tag = tagnames[1]
    }
  },
  {
    rule = {
      class = "firefox"
    },
    properties = {
      tag = tagnames[2]
    }
  },
  {
    rule = {
      class = "[Ss]potify"
    },
    properties = {
      tag = tagnames[3]
    }
  }
}
-- }}}

-- {{{ Signals

-- Signal function to execute when a new client appears.
client.connect_signal(
  "manage",
  function(c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end
    c:connect_signal("property::class", awful.rules.apply)
    if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
      -- Prevent clients from being unreachable after screen count changes.
      awful.placement.no_offscreen(c)
    end

    local screen = mouse.screen.index
    local tag = mouse.screen.tags[c.first_tag.index] or mouse.screen.selected_tags[1]

    c.shape = gears.shape.rounded_rect
    c:move_to_screen(screen)
    c:move_to_tag(tag)
  end
)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal(
  "mouse::enter",
  function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier and awful.client.focus.filter(c) then
      client.focus = c
    end
  end
)

-- client.connect_signal(
--   "focus",
--   function(c)
--     c.border_color = beautiful.border_focus
--   end
-- )
-- client.connect_signal(
--   "unfocus",
--   function(c)
--     c.border_color = beautiful.border_normal
--   end
-- )

-- Disable borders on lone windows
-- Handle border sizes of clients.
for s = 1, screen.count() do
  screen[s]:connect_signal(
    "arrange",
    function()
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
            -- if layout ~= "max" and layout ~= "fullscreen" then
            -- XXX: SLOW!
            -- awful.client.moveresize(0, 0, 2, 0, tiled[1])
            -- end
            tiled[1].border_width = 0
          else
            c.border_width = 0
          end
        end
      end
    end
  )
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
