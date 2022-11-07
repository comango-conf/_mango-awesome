local awful = require("awful")
local wibox = require("wibox")
local scratchpad = require("scratchpad")
local gears = require("gears")
local naughty = require("naughty")
local beautiful = require("beautiful")


-- current volume object
local curr = nil

local volume_widget = wibox.widget {
    widget = wibox.widget.textbox
}
volume_widget:connect_signal("button::press",
        function (_, _, _, button)
            if button == 1 then
                scratchpad.toggle("audio")
            elseif button == 4 then
                awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%")
            elseif button == 5 then
                awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%")
            end
        end
)


local tooltip = awful.tooltip {
    objects = { volume_widget },
}

local function select_icon (audio)
    if not audio then return "" end

    if audio.muted then
        return ""
    end

    if audio.volume < 20 then
        return ""
    elseif audio.volume < 40 then
        return ""
    elseif audio.volume < 80 then
        return ""
    else
        return ""
    end

    return ""
end

local function popup_widget_template (audio)
    return {
        layout = wibox.container.background,
        clip   = true,
        forced_width = 400,
        forced_height = 300,
        {
            layout = wibox.container.place,
            {
                layout = wibox.layout.fixed.vertical,
                spacing = 0,
                max_widget_size = 100,
                {
                    widget = wibox.widget.textbox,
                    text   = select_icon(audio),
                    align  = "center",
                    font   = "116"
                },
                {
                    widget = wibox.widget.textbox,
                    text   = audio and audio.sink:sub(1, 20) or "Nothing",
                    align  = "center",
                    font   = "Noto Sans 24"
                },
                {
                    layout = wibox.container.margin,
                    top = 10,
                    {
                        widget        = wibox.widget.progressbar,
                        max_value     = 100,
                        value         = audio and audio.volume or 100,
                        forced_height = 40,
                        forced_width  = 300,
                        shape         = gears.shape.rounded_bar,
                    },
                }
            }
        }
    }
end

local pop = awful.popup {
    widget    =  popup_widget_template(),
    width     = 400,
    height    = 300,
    ontop     = true,
    placement = awful.placement.centered,
    shape     = gears.shape.rounded_rect,
    visible   = false,
}
local timer = gears.timer({
    timeout = 1,
    callback = function ()
        pop.visible = false
    end,
    single_shot = true
})

awesome.connect_signal("volume::change", function (new, _)

    tooltip.text = new.volume

    volume_widget:set_text(select_icon(new))

    if curr ~= nil then
        pop.widget = wibox.widget(popup_widget_template(new))
        pop.visible = true
        timer:again()
    end

    curr = new
end)




return volume_widget