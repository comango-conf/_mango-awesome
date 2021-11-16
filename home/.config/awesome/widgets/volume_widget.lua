local awful = require("awful")
local wibox = require("wibox")
local scratchpad = require("scratchpad")
local gears = require("gears")
local naughty = require("naughty")


local text = wibox.widget {
    widget = wibox.widget.textbox
}




local tooltip = awful.tooltip {
    objects = { text },
}


local volume = ""
local volume_widget = awful.widget.watch("pactl get-sink-volume @DEFAULT_SINK@", 0.2,
        function (widget, stdout)
            volume = tonumber(stdout:match("%d*%%"):sub(1, -2))

            local icon
            if volume < 20 then
                icon = ""
            elseif volume < 40 then
                icon = ""
            elseif volume < 80 then
                icon = ""
            else
                icon = ""
            end

            tooltip.text = volume .. "%"
            widget:set_text(icon)
        end,
        text
)


text:connect_signal("button::press",
        function (_, _, _, button)

               if button == 1 then
                -- scratchpad.toggle("audio")
            elseif button == 4 then
                awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%")
            elseif button == 5 then
                awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%")
            end

            local pop = awful.popup {
                widget =  {
                    widget = wibox.widget.background,
                    clip   = true,
                    shape  = gears.shape.rounded_bar,
                    forced_width = 400,
                    forced_height = 300,
                    {
                        text   = 'foobar',
                        widget = wibox.widget.textbox
                    },
                },
                width        = 400,
                height       = 300,
                ontop        = true,
                placement    = awful.placement.centered,
                shape        = gears.shape.rounded_rect
            }

            gears.timer.start_new(1, function ()
                    pop.visible = false
                end)
        end
)




return volume_widget