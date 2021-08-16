local status_widget = require("widgets.status_widget")
local command = "bash -c 'bluetoothctl show | grep Powered'"

bluetooth_widget =
  status_widget(
  command,
  5,
  function(widget, stdout)
    if stdout:match("yes") == "yes" then
      widget:get_children_by_id("name")[1]:set_markup("On")
      widget:get_children_by_id("icon")[1]:set_text("")
    else
      widget:get_children_by_id("status")[1]:set_markup("Off")
      widget:get_children_by_id("icon")[1]:set_text("")
    end
  end,
  "blue",
  {
    type = "<b>Bluetooth</b>"
  }
)
