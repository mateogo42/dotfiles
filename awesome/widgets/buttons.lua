local awful = require("awful")
local capi = {keygrabber = keygrabber }
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local function base_button(args)

    args = args or {}
    local content = args.content or nil
    local on_click = args.on_click or function() end
    local bg = args.bg or beautiful.transparent
    local fg = args.fg or beautiful.white
    local shape = args.shape or gears.shape.rounded_rect

    
    local widget = wibox.widget {
        content,
        widget = wibox.container.margin,
        margins = 8
    }
    
    local container = wibox.widget {
        {
            widget,
            widget = wibox.container.place,
            placement = "center"
        },
        shape_border_width = 2,
        shape = shape,
        bg = bg,
        fg = fg,
        widget = wibox.container.background,
    }
    local old_cursor, old_wibox

    container:connect_signal("mouse::enter", function(c)
        c.bg = fg
        local w = mouse.current_wibox
        old_cursor, old_wibox = w.cursor, w
        w.cursor = "hand2"
    end)

    container:connect_signal("mouse::leave", function(c)
        c.bg = bg
        if old_wibox then
            old_wibox.cursor = old_cursor
            old_wibox = nil
        end       
    end)

    container:connect_signal("button::press", function() on_click() end)

    return container
end


local function text_button(text, on_click)
    local widget = wibox.widget {
        text = text,
        widget = wibox.widget.textbox
    }

    return base_button {
        content = widget,
        on_click = on_click
    }

end

local function icon_button(icon, on_click)
    local icon = os.getenv("HOME") .. "/.config/awesome/icons/" .. icon .. '.svg'
    local widget = wibox.widget {
        widget = wibox.widget.imagebox,
        image = icon,
        resize = true,
        id = "button",
    }


    return base_button {
        content = widget,  
        shape=gears.shape.circle,
        on_click = on_click
    }
end


return {
    text_button = text_button,
    icon_button = icon_button
}