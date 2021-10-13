local awful = require("awful")
local capi = {keygrabber = keygrabber}
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local buttons = require("widgets.buttons")

logoutmenu =
  wibox.widget {
  buttons.text_button(
    "  ",
    function()
      awesome.quit()
    end
  ),
  buttons.text_button(
    "  ",
    function()
      awful.spawn.with_shell("dm-tool lock")
    end
  ),
  buttons.text_button(
    " ⏾ ",
    function()
      awful.spawn.with_shell("systemctl suspend")
    end
  ),
  buttons.text_button(
    " ﰇ ",
    function()
      awful.spawn.with_shell("reboot")
    end
  ),
  buttons.text_button(
    " 襤 ",
    function()
      awful.spawn.with_shell("shutdown now")
    end
  ),
  spacing = 10,
  layout = wibox.layout.flex.horizontal,
  expand = "none"
}

local exit_popup =
  awful.popup {
  widget = logoutmenu,
  border_width = 5,
  border_color = beautiful.red,
  bg = beautiful.black,
  maximum_height = #awful.layout.layouts * 10,
  minimum_height = #awful.layout.layouts * 10,
  placement = awful.placement.centered,
  ontop = true,
  visible = false,
  shape = gears.shape.rounded_rect
}

local exit_screen =
  wibox {
  widget = wibox.widget {
    nil,
    {
      nil,
      logoutmenu,
      nil,
      layout = wibox.layout.fixed.horizontal,
      expand = "none"
    },
    buttons.text_button(
      "Cancel",
      function()
        awesome.emit_signal("module::logout:hide")
      end
    ),
    layout = wibox.layout.align.vertical,
    expand = "none"
  },
  ontop = true,
  bg = beautiful.black .. "AA",
  fg = beautiful.white,
  visible = false,
  height = 1,
  width = 1,
  type = "splash",
  placement = awful.placement.centered
}

local exit_screen_grabber =
  awful.keygrabber {
  auto_start = true,
  stop_event = "release",
  keypressed_callback = function(self, mod, key, command)
    if key == "Escape" then
      awesome.emit_signal("module::logout:hide")
    end
  end
}

awesome.connect_signal(
  "module::logout:show",
  function()
    local s = awful.screen.focused()
    exit_screen.height = s.geometry.height
    exit_screen.width = s.geometry.width
    exit_screen.visible = true
    exit_screen_grabber:start()
  end
)

awesome.connect_signal(
  "module::logout:hide",
  function()
    exit_screen.visible = false
    exit_screen_grabber:stop()
  end
)
