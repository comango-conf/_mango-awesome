local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local tags = require("tags")

local battery_indicator = require("widgets.battery_indicator")
local volume_widget = require("widgets.volume_widget")

local dock = {}


-- {{{ Wibar
-- Create a textclock widget
local mytextclock = wibox.widget.textclock()

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
        awful.button({}, 1, function(t) t:view_only() end),
        awful.button({ MODKEY }, 1, function(t)
                                        if client.focus then
                                            client.focus:move_to_tag(t)
                                        end
                                    end),
        awful.button({}, 3, awful.tag.viewtoggle),
        awful.button({ MODKEY }, 3, function(t)
                                        if client.focus then
                                            client.focus:toggle_tag(t)
                                        end
                                    end),
        awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
        awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = gears.table.join(
        awful.button({}, 1, function (c)
                                if c == client.focus then
                                    c.minimized = true
                                else
                                    c:emit_signal(
                                        "request::activate",
                                        "tasklist",
                                        {raise = true}
                                    )
                                end
                            end),
        awful.button({}, 3, function()
                                awful.menu.client_list({ theme = { width = 250 } })
                            end),
        awful.button({}, 4, function ()
                                awful.client.focus.byidx(1)
                            end),
        awful.button({}, 5, function ()
                                awful.client.focus.byidx(-1)
                            end)
)


local ssid = ''

local wifidisplay = awful.widget.watch('iw ' .. WIFIDEVICE .. ' link', 5,
        function(widget, stdout)
            if stdout:match ".*Not connected.*" then
                widget:set_text("")
                return
            end

            ssid =   stdout:match "SSID: [%w%s%p]*%c":sub(6, -2)
            local signal = tonumber(stdout:match "signal: %p%d*":sub(8, -1))

            local icon = ""
            if signal >= -50 then
                icon = ""
            elseif signal >= -70 then
                icon = ""
            else
                icon = ""
            end
            widget:set_text(icon .. ' ')
        end)

awful.tooltip {
    objects = { wifidisplay },
    timer_function = function() return ssid:gsub("\n", "") end,
}

-- Keyboard map indicator and switcher
local mykeyboardlayout = awful.widget.keyboardlayout()


function dock.create(s)
    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                            awful.button({ }, 1, function () awful.layout.inc( 1) end),
                            awful.button({ }, 3, function () awful.layout.inc(-1) end),
                            awful.button({ }, 4, function () awful.layout.inc( 1) end),
                            awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = function (t)
            return t.name ~= "scratchpads"
                and awful.widget.taglist.filter.noempty(t)
        end,
        buttons = taglist_buttons,
        widget_template = {
            {
                {
                    {
                        id     = "text_icon",
                        widget = wibox.widget.textbox,
                        font = "Font Awesome 5 Pro Solid 10"
                    },
                    layout = wibox.layout.fixed.horizontal,
                },
                left  = 3,
                right = 3,
                widget = wibox.container.margin
            },
            id     = "background_role",
            widget = wibox.container.background,
            create_callback = function(self, t, index, objects)
                self:get_children_by_id("text_icon")[1].text =
                    (tags.taglist[t.name] or { icon = "" }).icon
            end,
        },
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
        style    = {
            border_width = 1,
            border_color = "#77777700",
            shape        = gears.shape.rounded_bar,
        },
        widget_template = {
            id = "background_role",
            widget = wibox.container.background,
            {
                widget = wibox.container.margin,
                left = 10,
                right = 10,
                top = 2,
                bottom = 2,
                {
                    id     = 'clienticon',
                    widget = awful.widget.clienticon,
                    forced_width = 18,
                    forced_height = 20,
                },
            },
            create_callback = function(self, c, index, objects)
                self:get_children_by_id('clienticon')[1].client = c
            end,
        }
    }

    -- Create the wibox
    s.mywibox = awful.wibar({
        position = "top",
        ontop = false,
        screen = s,
        height = 25,
    })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        expand = "none",
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            {
                layout = wibox.container.margin,
                right = 5,
                s.mytaglist,
            },
            s.mypromptbox,
        },
        { -- Middle widget
            layout = wibox.layout.flex.horizontal,
            {
                layout = wibox.container.place,
                valign = "center",
                s.mytasklist,
            },
        },
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            -- {
            --     layout = wibox.container.margin,
            --     top = 2,
            --     bottom = 2,
            --     right = 2,
            --     wibox.widget.systray(),
            -- },
            {
                layout = wibox.layout.flex.horizontal,
                spacing = 0,
                max_widget_size = 30,
                forced_width = 85,
                wifidisplay,
                volume_widget,
                -- mykeyboardlayout,
            },
            battery_indicator,
            mytextclock,
            s.mylayoutbox,
        }
    }
end


return dock