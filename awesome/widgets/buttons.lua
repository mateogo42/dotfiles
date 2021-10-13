local awful = require("awful")
local capi = {keygrabber = keygrabber}
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local default_args = {
  content = nil,
  onclick = function()
  end,
  bg = beautiful.transparent,
  fg = beautiful.white,
  shape = gears.shape.rounded_rect,
  width = 50,
  height = 50
}

local function base_button(args)
  args = args or {}
  local content = args.content or default_args.content
  local on_click = args.on_click or default_args.onclick
  local bg = args.bg or default_args.bg
  local fg = args.fg or default_args.fg
  local shape = args.shape or default_args.shape
  local width = args.width or default_args.width
  local height = args.height or default_args.height

  local widget =
    wibox.widget {
    content,
    widget = wibox.container.margin,
    margins = 8
  }

  local container =
    wibox.widget {
    {
      widget,
      widget = wibox.container.place,
      placement = "center"
    },
    shape = shape,
    bg = bg,
    fg = fg,
    widget = wibox.container.background,
    forced_width = width,
    forced_height = height
  }
  local old_cursor, old_wibox

  container:connect_signal(
    "mouse::enter",
    function(c)
      c.bg = fg
      c.fg = bg
      local w = mouse.current_wibox
      old_cursor, old_wibox = w.cursor, w
      w.cursor = "hand2"
    end
  )

  container:connect_signal(
    "mouse::leave",
    function(c)
      c.bg = bg
      c.fg = fg
      if old_wibox then
        old_wibox.cursor = old_cursor
        old_wibox = nil
      end
    end
  )

  container:connect_signal(
    "button::press",
    function(...)
      on_click(...)
    end
  )

  return container
end

local function text_button(text, on_click)
  local widget =
    wibox.widget {
    text = text,
    widget = wibox.widget.textbox
  }

  return base_button {
    content = widget,
    on_click = on_click,
    bg = beautiful.black2
  }
end

local function icon_button(icon, on_click)
  local icon_path = os.getenv("HOME") .. "/.config/awesome/icons/" .. icon .. ".svg"
  local widget =
    wibox.widget {
    widget = wibox.widget.imagebox,
    image = icon_path,
    resize = true,
    id = "button"
  }

  return base_button {
    content = widget,
    on_click = on_click,
    bg = beautiful.black2
  }
end

return {
  text_button = text_button,
  icon_button = icon_button
}
