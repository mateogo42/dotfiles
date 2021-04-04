local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local buttons = require("widgets.buttons")

local command = "nmcli -t -f name,type connection show --active"
local icon_path = os.getenv("HOME") .. "/.config/awesome/icons/"


local wifi_info = wibox.widget {
	layout = wibox.layout.fixed.horizontal,
	{
		{
			widget = wibox.widget.imagebox,
			image = icon_path .. "wireless.svg",
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
				markup = "Placeholder",
				font = beautiful.custom_font .. "12"
			},
			{
				widget = wibox.widget.textbox,
				id = "name",
				markup = "Placeholder",
				font = beautiful.custom_font .. "10"
			}
		},
		widget = wibox.container.place,
		halign = left
	}
}


wifi_status = wibox.widget {
	{
		{
			awful.widget.watch(
			command, 
			5, 
			function(widget, stdout)
				if stdout == "" then
					widget:get_children_by_id("icon")[1]:set_image(icon_path .. "wifi_off.svg")
					widget:get_children_by_id("type")[1]:set_markup("<b>Off</b>")
					widget:get_children_by_id("name")[1]:set_markup("")
					return
				end
				local conns = stdout:gmatch("[^\r\n]+")

				local curr_conn = conns()
				local conn_info = curr_conn:gmatch("[^:]+")
				local conn_name = conn_info()
				local conn_type = conn_info():gmatch("[^-][A-Za-z]+$")()
				widget:get_children_by_id("icon")[1]:set_image(icon_path .. conn_type .. ".svg")
				conn_type = conn_type:gsub("^%l", string.upper)
				widget:get_children_by_id("type")[1]:set_markup("<b>" .. conn_type .. "</b>")
				widget:get_children_by_id("name")[1]:set_markup(conn_name) 
			end,
			wifi_info),
			widget = wibox.container.margin,
			top = 10, bottom = 10
		},
		widget = wibox.container.background,
		shape = gears.shape.rounded_rect,
		bg = beautiful.green,
		fg = "#fff"
	},
	widget = wibox.container.margin,
	margins = 10
} 


