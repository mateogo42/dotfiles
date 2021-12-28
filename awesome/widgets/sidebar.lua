local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local rubato = require("lib.rubato")
-- local naughty = require("naughty")
local buttons = require("widgets.buttons")
local awful = require("awful")
require("logout.logout")
local spotify_widget = require("widgets.spotify")

local image_path = os.getenv("HOME") .. "/Pictures/patrick_pinhead.jpg"
local logo_path = os.getenv("HOME") .. "/.config/awesome/images/arco.png"
local user = os.getenv("USER")

local spacing = dpi(8)

local ease_in_out = {
  easing = function(t)
    if t == 0 then
      return 0
    end
    if t == 1 then
      return 1
    end
    if t < 0.5 then
      return math.pow(2, 20 * t - 10) / 2
    end

    return 2 - math.pow(2, -20 * t + 10) / 2
  end,
  F = 1 + math.pow(2, -33) / math.log10(32)
}

local bluetooth_button =
  buttons.text_button(
  "",
  function()
    awful.spawn.with_shell("blueberry")
  end
)
local wifi_button =
  buttons.text_button(
  "直",
  function()
    awful.spawn.with_shell("nm-connection-editor")
  end
)

local slider =
  wibox.widget {
  bar_shape = gears.shape.rounded_rect,
  bar_height = 3,
  bar_color = beautiful.white,
  handle_shape = gears.shape.circle,
  handle_width = 10,
  handle_color = beautiful.white,
  handle_border_width = 1,
  minimum = 0,
  maximum = 100,
  forced_height = 50,
  forced_width = 50,
  value = 50,
  ontop = true,
  widget = wibox.widget.slider
}

local popup =
  awful.popup {
  widget = {
    slider,
    widget = wibox.container.background,
    bg = beautiful.black2,
    forced_height = 30,
    forced_width = 100
  },
  placement = awful.placement.centered,
  shape = gears.shape.rounded_rect,
  preferred_positions = "left",
  preferred_anchors = {"front", "back"},
  ontop = true,
  visible = false
}

slider:connect_signal(
  "widget::redraw_needed",
  function(c)
    local value = c.value
    awful.spawn.with_shell("amixer -D pulse set Master " .. tostring(value) .. "%")
  end
)

local volume_button =
  buttons.text_button(
  "墳",
  function(_, _, _, b)
    local value = "1%"
    if b == 4 then
      value = value .. "+"
    elseif b == 5 then
      value = value .. "-"
    else
      return
    end
    awful.spawn.with_shell("amixer -D pulse set Master " .. value)
  end
)

local brightness_button =
  buttons.text_button(
  "",
  function()
  end
)

local user_image =
  wibox.widget {
  {
    {
      {
        widget = wibox.widget.imagebox,
        image = image_path,
        forced_height = dpi(200)
      },
      widget = wibox.container.place
    },
    widget = wibox.container.background,
    shape = gears.shape.circle,
    shape_clip = true
  },
  widget = wibox.container.margin
}

local username =
  wibox.widget {
  {
    widget = wibox.widget.textbox,
    markup = "<b>" .. user .. "</b>",
    font = beautiful.custom_font .. "20",
    align = "center"
  },
  widget = wibox.container.background,
  fg = beautiful.white
}

function sidebar_widget(s)
  local sidebar =
    wibox(
    {
      position = beautiful.sidebar_position,
      screen = s,
      width = s.geometry.width * 0.8,
      height = s.workarea.height * 0.2,
      x = s.workarea.x,
      visible = true,
      ontop = true,
      bg = beautiful.transparent
    }
  )

  sidebar:setup {
    {
      {
        layout = wibox.layout.flex.horizontal,
        spacing = spacing,
        {
          {
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
              layout = wibox.layout.fixed.vertical
            },
            widget = wibox.container.place
          },
          widget = wibox.container.background,
          bg = beautiful.black2,
          shape = gears.shape.rounded_rect
        },
        {
          {
            {
              user_image,
              widget = wibox.layout.flex.horizontal,
              spacing = 10
            },
            widget = wibox.container.margin,
            top = 10,
            bottom = 10
          },
          widget = wibox.container.background,
          bg = beautiful.black2,
          shape = gears.shape.rounded_rect
        },
        {
          logoutmenu,
          {
            bluetooth_button,
            wifi_button,
            volume_button,
            brightness_button,
            layout = wibox.layout.flex.horizontal,
            spacing = spacing
          },
          layout = wibox.layout.flex.vertical,
          spacing = spacing
        },
        spotify_widget()
      },
      widget = wibox.container.background,
      bg = beautiful.transparent
    },
    widget = wibox.container.margin,
    top = 20,
    left = 10,
    right = 10
  }

  local opacity_timed =
    rubato.timed {
    intro = 0,
    prop_intro = true,
    duration = 0.1,
    pos = 0,
    easing = ease_in_out,
    subscribed = function(pos)
      sidebar.opacity = pos
    end
  }
  local pos_timed =
    rubato.timed {
    intro = 0,
    prop_intro = true,
    duration = 0.4,
    pos = s.geometry.height,
    easing = rubato.linear,
    subscribed = function(pos)
      sidebar:geometry(
        {
          y = s.workarea.y + pos
        }
      )
    end
  }

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
    bg = beautiful.black
  }

  button:connect_signal(
    "button::press",
    function(_, _, _, b)
      if b == 1 then
        if opacity_timed.target == 0 then
          opacity_timed.target = 1
          pos_timed.target = s.workarea.height * 0.8
        else
          opacity_timed.target = 0
          pos_timed.target = s.geometry.height
        end
      end
    end
  )

  return button
end
