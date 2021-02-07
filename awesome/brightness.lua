local wibox = require('wibox')
local awful = require('awful')
local gears = require('gears')
local theme = require('theme')

local fd = io.popen("cat /sys/class/backlight/intel_backlight/max_brightness")
local max_brightness = tonumber(fd:read("all"))
fd:close()

local brightness_bar = wibox.widget {
    {
        id = 'brightness',
        max_value = 1,
        value = 0,
        widget = wibox.widget.progressbar,
        forced_width = 100,
        forced_height = 20,
        direction = 'east',
        shape = gears.shape.rounded_rect,
        color = theme.blue,
        background_color = theme.white
    },
    widget = wibox.container.margin,
    left = 10,
    right = 10

}

local brightness_icon = wibox.widget {
    {
        id = "icon",
        widget = wibox.widget.imagebox,
    resize = false,
    image = theme.brightness_icon,
    },
    widget = wibox.container.margin,
    left = 10
}

brightness_widget = wibox.widget {
    {
        brightness_icon,
        brightness_bar,
        widget = wibox.layout.align.horizontal,
        expand = "inside",
        id = "brightness_vertical"
    },
    widget = wibox.container.margin,
    margins = 10,
    bottom = 20
}

function update_brightness(widget)
    local fd = io.popen("cat /sys/class/backlight/intel_backlight/actual_brightness")
    local brightness = tonumber(fd:read("all"))
    local value = brightness / max_brightness
    fd:close()

    widget.brightness_vertical.second.brightness:set_value(value)
end

update_brightness(brightness_widget)

mytimer = timer({
    timeout = 1
})
mytimer:connect_signal("timeout", function()
    update_brightness(brightness_widget)
end)
mytimer:start()
