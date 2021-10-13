local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local widget_info = function(defaults)
  local icon = defaults.icon or "Placeholder"
  local type = defaults.type or "Placeholder"
  local name = defaults.name or "Placeholder"
  return wibox.widget {
    layout = wibox.layout.fixed.horizontal,
    {
      {
        widget = wibox.widget.textbox,
        text = icon,
        font = beautiful.custom_font .. "40",
        resize = true,
        forced_height = 50,
        forced_width = 50,
        id = "icon"
      },
      widget = wibox.container.margin,
      margins = 10
    },
    {
      {
        layout = wibox.layout.fixed.vertical,
        {
          widget = wibox.widget.textbox,
          id = "type",
          markup = type,
          font = beautiful.custom_font .. "12"
        },
        {
          widget = wibox.widget.textbox,
          id = "name",
          markup = name,
          font = beautiful.custom_font .. "10"
        }
      },
      widget = wibox.container.place,
      halign = "left"
    }
  }
end

return function(command, interval, callback, background_color, defaults)
  return wibox.widget {
    awful.widget.watch(command, interval, callback, widget_info(defaults)),
    widget = wibox.container.background,
    shape = gears.shape.rounded_rect,
    bg = beautiful[background_color] or background_color,
    fg = "#fff"
  }
end
