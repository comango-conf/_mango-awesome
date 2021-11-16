local awful = require("awful")
local wibox = require("wibox")

local watch = awful.widget.watch(
    'cat /sys/class/power_supply/BAT0/capacity /sys/class/power_supply/AC/online',
    15,
    function(widget, stdout)
        local cap, status = stdout:match("^(%d+)\n(%w+)")

        local text = cap
        -- if status == "1" then
        --     text = ""
        -- end



        -- local cap = tonumber(stdout)

        -- local icon = ""
        -- if cap < 20 then
        --     icon = ""
        -- elseif cap < 50 then
        --     icon = ""
        -- elseif cap < 80 then
        --     icon = ""
        -- else
        --     icon = ""
        -- end

        -- widget:set_text(icon .. " " .. cap .. "%")

        widget:get_children_by_id("progressbar")[1].value = tonumber(cap)
        widget:get_children_by_id("text")[1]:set_text(text)
    end,
    wibox.widget
    {
        layout = wibox.layout.stack,
        {
            layout = wibox.container.mirror,
            reflection = {
                vertical = true,
                horizontal = true,
            },
            {
                id = "progressbar",
                layout = wibox.container.radialprogressbar,
                min_value = 0,
                max_value = 100,
                value = 70,
                forced_width = 21,
                forced_height = 21,
            }
        },
        {
            layout = wibox.container.margin,
            right = 1,
            bottom = 1,
            {
                id = "text",
                widget = wibox.widget.textbox,
                font = "Font Awesome Pro Solid 6",
                align  = "center",
                valign = "center",
            }
        }
    }
)

return {
    layout = wibox.container.margin,
    top = 1,
    bottom = 1,
    watch
}