local status_widget = require("widgets.status_widget")

local command = "nmcli -t -f name,type connection show --active"

wifi_widget =
  status_widget(
  command,
  5,
  function(widget, stdout)
    if stdout == "" then
      widget:get_children_by_id("icon")[1]:set_text("睊")
      widget:get_children_by_id("type")[1]:set_markup("<b>Off</b>")
      widget:get_children_by_id("name")[1]:set_markup("")
      return
    end
    local conns = stdout:gmatch("[^\r\n]+")

    local curr_conn = conns()
    local conn_info = curr_conn:gmatch("[^:]+")
    local conn_name = conn_info()
    local conn_type = conn_info():gmatch("[^-][A-Za-z]+$")()
    if conn_type == "wireless" then
      widget:get_children_by_id("icon")[1]:set_text("直")
    else
      widget:get_children_by_id("icon")[1]:set_text("")
    end
    conn_type = conn_type:gsub("^%l", string.upper)
    widget:get_children_by_id("type")[1]:set_markup("<b>" .. conn_type .. "</b>")
    widget:get_children_by_id("name")[1]:set_markup(conn_name)
  end,
  "blue",
  {
    icon = "睊"
  }
)
