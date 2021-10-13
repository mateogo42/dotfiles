local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local watch = require("awful.widget.watch")
local naughty = require("naughty")
local spawn = require("awful.spawn")
local io = require("io")
local os = require("os")
local math = require("math")

local spotify_widget = {}
local status_cmd = "playerctl --player=spotify status"
local metadata_cmd = "playerctl --player=spotify metadata"
local default_icon_path = string.format("%s/.config/awesome/images/music.png", os.getenv("HOME"))

local function new()
  local function update_status(widget, stdout)
    local status = string.match(stdout, "(.*)\n")
    if status == "Playing" or status == "Paused" then
      widget.visible = true
    else
      widget.visible = false
    end
  end

  local function update_metadata(widget, stdout)
    local title = string.match(stdout, "spotify xesam:title%s*([^\n]*)")
    local artist = string.match(stdout, "spotify xesam:artist%s*([^\n]*)")
    local album_art_widget = widget.children[1].widget.widget
    local artist_widget = widget.children[2].children[1].widget
    local title_widget = widget.children[2].children[2]

    local art_url = string.match(stdout, "spotify mpris:artUrl%s([^\n]*)")
    local art_url_id = string.match(art_url, "/([%w%d]*)$")
    local art_path = string.format("/tmp/%s", art_url_id)

    if not gears.filesystem.file_readable(art_path) then
      local cmd = string.format("curl -f -s -m 10 -o %s %s", art_path, art_url)
      spawn.easy_async(
        cmd,
        function(_)
          title_widget:set_markup_silently(string.format("<b>%s</b>", title) or "Song")
          artist_widget:set_markup_silently(artist or "Artist")
          album_art_widget.image = art_path
        end
      )
    else
      title_widget:set_markup_silently(title)
      artist_widget:set_markup_silently(artist)
      album_art_widget.image = art_path
    end
  end

  local player =
    wibox.widget {
    {
      {
        {
          widget = wibox.widget.imagebox,
          image = default_icon_path,
          resize = true
        },
        widget = wibox.container.background,
        shape_clip = true,
        shape = gears.shape.rounded_rect
      },
      widget = wibox.container.margin
    },
    {
      {
        {
          markup = "",
          widget = wibox.widget.textbox,
          align = "left",
          valign = "bottom",
          font = beautiful.custom_font .. "12"
        },
        widget = wibox.container.background,
        fg = beautiful.cyan
      },
      {
        text = "",
        widget = wibox.widget.textbox,
        align = "left",
        valign = "top",
        font = beautiful.custom_font .. "10",
        id = "titlew"
      },
      layout = wibox.layout.flex.vertical
    },
    layout = wibox.layout.fixed.horizontal,
    spacing = 10
  }
  spotify_widget =
    wibox.widget {
    {
      player,
      widget = wibox.container.margin
    },
    widget = wibox.container.background,
    bg = beautiful.black2,
    shape = gears.shape.rounded_rect
  }

  watch(status_cmd, 1, update_status, spotify_widget)
  watch(metadata_cmd, 1, update_metadata, player)

  return spotify_widget
end

return setmetatable(
  spotify_widget,
  {
    __call = function()
      return new()
    end
  }
)
