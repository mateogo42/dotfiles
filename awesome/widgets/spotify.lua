local status_widget = require("widgets.status_widget")
local command = "sp current"

spotify_widget =
  status_widget(
  command,
  1,
  function(widget, stdout, _, _, _)
    if string.find(stdout, "Error: Spotify is not running.") ~= nil then
      widget:set_text("", "")
      widget:set_visible(false)
      return
    end
    local escaped = string.gsub(stdout, "&", "&amp;")
    local album, _, artist, title =
      string.match(escaped, "Album%s*(.*)\nAlbumArtist%s*(.*)\nArtist%s*(.*)\nTitle%s*(.*)\n")
    if album ~= nil and title ~= nil and artist ~= nil then
      widget:get_children_by_id("type")[1]:set_markup("<b>" .. artist .. "</b> ")
      widget:get_children_by_id("name")[1]:set_markup(title)
      widget:set_visible(true)
    end
  end,
  "green",
  {
    icon = "阮"
  }
)

local function ellipsize(text, length)
  return (text:len() > length and length > 0) and text:sub(0, length - 3) .. "..." or text
end
