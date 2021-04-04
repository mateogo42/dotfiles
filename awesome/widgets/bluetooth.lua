local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local command = "bash -c 'bluetoothctl show | grep Powered'"
local icon_path = os.getenv("HOME") .. "/.config/awesome/icons/"


local bluetooth_info = wibox.widget {
	layout = wibox.layout.fixed.horizontal,
	{
		{
			widget = wibox.widget.imagebox,
			image = icon_path .. "bluetooth.svg",
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
				markup = "<b>Bluetooth</b>",
				font = beautiful.custom_font .. "12"
			},
			{
				widget = wibox.widget.textbox,
				id = "status",
				markup = "Placeholder",
				font = beautiful.custom_font .. "10"
			}
		},
		widget = wibox.container.place,
		halign = left
	}
}


bluetooth_status = wibox.widget {
	{
		{
			awful.widget.watch(
			command, 
			5, 
			function(widget, stdout)
                if stdout:match("yes") == "yes" then
                    widget:get_children_by_id("status")[1]:set_markup("On")
                    widget:get_children_by_id("icon")[1]:set_image(icon_path .. "bluetooth.svg")
                else
                    widget:get_children_by_id("status")[1]:set_markup("Off")
                    widget:get_children_by_id("icon")[1]:set_image(icon_path .. "bluetooth_off.svg")
                end
			end,
			bluetooth_info),
			widget = wibox.container.margin,
			top = 10, bottom = 10
		},
		widget = wibox.container.background,
		shape = gears.shape.rounded_rect,
		bg = beautiful.blue,
        -- shape_border_width = 2,
		fg = "#fff"
	},
	widget = wibox.container.margin,
	margins = 10
} 


