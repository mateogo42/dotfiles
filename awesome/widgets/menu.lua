local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local naughty = require("naughty")
local beautiful = require("beautiful")
local os = require("os")

local icon_path = os.getenv("HOME") .. "/.config/awesome/icons/"
local logo_path = os.getenv("HOME") .. "/.config/awesome/images/arco.png"

function menu()
  local menu_items = {
    {
      "Log Out",
      function()
        awesome.quit()
      end,
      icon_path .. "logout.svg"
    },
    {"Suspend", "systemctl suspend", icon_path .. "lock.svg"},
    {"Hibernate", "systemctl hibernate", icon_path .. "sleep.svg"},
    {"Reboot", "systemctl reboot", icon_path .. "restart.svg"},
    {"Shutdown", "poweroff", icon_path .. "power.svg"}
  }
  local logout_menu = awful.menu(menu_items)

  local button =
    wibox.widget {
    {
      {
        widget = wibox.widget.imagebox,
        image = logo_path
      },
      widget = wibox.container.margin,
      margins = 5
    },
    widget = wibox.container.background,
    shape = gears.shape.circle,
    bg = beautiful.black,
    hide = function()
      logout_menu:hide()
    end
  }

  button:connect_signal(
    "button::press",
    function(c, _, _, button)
      -- local screen = button.screen
      naughty.notify {text = tostring(c.bg)}
      if button == 1 then
        logout_menu:toggle()
      end
    end
  )

  return button
end
