local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
require("volume")
require("brightness")

function sidebar(s)
    local sidebar = awful.wibar({
        position = beautiful.sidebar_position,
        screen = s,
        width = beautiful.sidebar_width,
        visible = false,
    })

    sidebar:setup{
        {
            {
                widget = wibox.layout.align.vertical,
                expand = "none",
                {
                    {
                        {
                            volume_widget,
                            brightness_widget,
                            widget = wibox.layout.flex.vertical,
                        },
                        widget = wibox.container.background,
                        bg = beautiful.black,
                        shape = gears.shape.rounded_rect,        
                    },
                    widget = wibox.container.margin,
                    margins = 10
                }
            },
            widget = wibox.container.background,
            bg = beautiful.white,
            fg = beautiful.black,
            shape = gears.shape.rounded_rect,
        },
        widget = wibox.container.margin,
        top = 20,
        bottom = 20,
    }

    return sidebar
end