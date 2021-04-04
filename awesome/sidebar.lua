local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
require("logout.logout")
require("widgets.wifi")
require("widgets.bluetooth")
local spotify = require("spotify")

local image_path = os.getenv("HOME") .. "/.config/awesome/images/arch.png"
local user = os.getenv("USER"):gsub("^%l", string.upper)

local user_image = wibox.widget {
    {
        {
            widget = wibox.widget.imagebox,
            image = image_path,
            resize = true,
            forced_height = dpi(200)
        },
        widget = wibox.container.place
    },
    widget = wibox.container.margin,
    top = 10
}

local username = wibox.widget {
    {
        widget = wibox.widget.textbox,
        markup = "<b>" .. user .. "</b>",
        font = beautiful.custom_font .. "20",
        align = "center"
    },
    widget = wibox.container.background,
    fg = beautiful.white
}

function sidebar(s)
    local sidebar = awful.wibar({
        position = beautiful.sidebar_position,
        screen = s,
        width = s.geometry.width * 0.20,
        visible = false
    })

    sidebar:setup{
        {
            {
                layout = wibox.layout.fixed.vertical,
                spacing = 25,
                spacing_widget = {
                    widget = wibox.widget.separator,
                    color = beautiful.white,
                    span_ratio = 0.75,
                    thickness = 3
                },
                {
                    user_image,
                    username,
                    widget = wibox.layout.fixed.vertical
                },
                logoutmenu,
                {
                    {
                        {
                            format = "<b>%H:%M</b>",
                            widget = wibox.widget.textclock,
                            font = beautiful.custom_font .. "30"
                        },
                        widget = wibox.container.place
                    },
                    {
                        {
                            format = "<b>%B %d %Y</b>",
                            widget = wibox.widget.textclock,
                            font = beautiful.custom_font .. "15"

                        },
                        widget = wibox.container.place
                    },
                    {
                        bluetooth_status,
                        wifi_status,
                        layout = wibox.layout.flex.horizontal
                    },
                    -- spotify(),
                    layout = wibox.layout.fixed.vertical
                }

            },
            widget = wibox.container.background,
            bg = beautiful.black,
            fg = beautiful.white,
            shape = gears.shape.rounded_rect
        },
        widget = wibox.container.margin,
        top = 20,
        bottom = 20
    }

    return sidebar
end
