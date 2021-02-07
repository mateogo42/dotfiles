local wibox = require('wibox')
local awful = require('awful')
local gears = require('gears')
local theme = require('theme')

local volume_bar = wibox.widget {
    {
        id = 'volume',
        max_value = 100,
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

local volume_icon = wibox.widget {
    {
        id = "icon",
        widget = wibox.widget.imagebox,
        resize = false,
        image = theme.volume_on_icon,
    },
    widget = wibox.container.margin,
    left = 10
}

volume_widget = wibox.widget {
    {
        volume_icon,
        volume_bar,
        widget = wibox.layout.align.horizontal,
        expand = "inside",
        id = "volume_vertical"
    },
    widget = wibox.container.margin,
    margins = 10,
    top = 20
}

function update_volume(widget)
    local fd = io.popen("amixer sget Master | grep Mono: | awk -F'[][]' '{ print $2 }'")
    local volume_percentage = fd:read("all")
    fd:close()

    local fd = io.popen("amixer sget Master | grep Mono: | awk -F'[][]' '{ print $6 }'")
    local volume_status = fd:read("all")
    fd:close()

    local value = tonumber(volume_percentage:gsub("%%", ""), 10)

    widget.volume_vertical.second.volume:set_value(value)
    if value == 0 or volume_status == "off" then
        widget.volume_vertical.first.icon.image = theme.volume_off_icon
    else
        widget.volume_vertical.first.icon.image = theme.volume_on_icon
    end
end

update_volume(volume_widget)

mytimer = timer({
    timeout = 1
})
mytimer:connect_signal("timeout", function()
    update_volume(volume_widget)
end)
mytimer:start()
