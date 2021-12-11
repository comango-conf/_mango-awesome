local awful = require("awful")
local wibox = require("wibox")
local scratchpad = require("scratchpad")
local gears = require("gears")
local naughty = require("naughty")
local beautiful = require("beautiful")

local text = wibox.widget {
    widget = wibox.widget.textbox
}




local tooltip = awful.tooltip {
    objects = { text },
}


local volume = ""
local volume_widget = awful.widget.watch("pamixer --get-volume-human", 0.2,
        function (widget, stdout)
            if stdout:gsub("\n", "") == "muted" then
                widget:set_text("")
                return
            end
            volume = tonumber(stdout:match("%d*"))
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

local function popup_widget_template (vol)
    return {
        layout = wibox.container.background,
        clip   = true,
        shape  = gears.shape.rounded_bar,
        forced_width = 400,
        forced_height = 300,
        {
            layout = wibox.container.place,
            {
                layout = wibox.layout.flex.vertical,
                spacing = 30,
                {
                    widget = wibox.widget.textbox,
                    text = "",
                    align  = "center",
                    font = "118"
                },
                {
                    layout = wibox.layout.constraint,
                    height = 5,
                    {
                        widget        = wibox.widget.progressbar,
                        max_value     = 100,
                        value         = vol or 100,
                        forced_height = 5,
                        forced_width  = 300,
                        shape         = gears.shape.rounded_bar,
                    },
                }
            }
        }
    }
end

local pop = awful.popup {
    widget =  popup_widget_template(),
    width        = 400,
    height       = 300,
    ontop        = true,
    placement    = awful.placement.centered,
    shape        = gears.shape.rounded_rect,
    visible      = false,
}
local timer = gears.timer({
    timeout = 1,
    callback = function ()
        pop.visible = false
    end,
    single_shot = true
})
text:connect_signal("button::press",
        function (_, _, _, button)

               if button == 1 then
                -- scratchpad.toggle("audio")
            elseif button == 4 then
                awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%")
            elseif button == 5 then
                awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%")
            end
            
            pop.widget = wibox.widget(popup_widget_template(volume))
            pop.visible = true
            timer:again()
        end
)




return volume_widget