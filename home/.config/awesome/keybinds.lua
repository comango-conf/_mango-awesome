local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local scratchpad = require("scratchpad")
local hotkeys_popup = require("awful.hotkeys_popup")
local tags = require("tags")
local naughty = require("naughty")

local keybinds = {}

-- {{{ Menu
-- Create a launcher widget and a main menu
local myawesomemenu = {
    { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
    -- { "manual", TERMINAL .. " -e man awesome" },
    { "edit config", EDITOR_CMD .. " " .. awesome.conffile },
    { "restart", awesome.restart },
    { "quit", function() awesome.quit() end },
}

local mymainmenu = awful.menu({
    items = {
        { "awesome", myawesomemenu, beautiful.awesome_icon },
        { "open terminal", TERMINAL }
    }
})


function keybinds.set()
    -- {{{ Mouse bindings
    root.buttons(gears.table.join(
        awful.button({ }, 1, function () mymainmenu:hide() end),
        awful.button({ }, 2, function () mymainmenu:hide() end),
        awful.button({ }, 3, function () mymainmenu:toggle() end)
        -- awful.button({ }, 4, awful.tag.viewnext),
        -- awful.button({ }, 5, awful.tag.viewprev)
    ))
    -- }}}

    -- {{{ Key bindings
    local globalkeys = gears.table.join(
        -- awful.key({ MODKEY, "Shift"   }, "s",      hotkeys_popup.show_help,
        --           {description="show help", group="awesome"}),
        awful.key({ MODKEY,           }, "Left",
            function ()
                awful.tag.viewprev()
                awful.layout.arrange(awful.screen.focused())
            end,
            {description = "view previous", group = "tag"}
        ),
        awful.key({ MODKEY,           }, "Right",  awful.tag.viewnext,
            {description = "view next", group = "tag"}),
        -- awful.key({ MODKEY,           }, "Escape", awful.tag.history.restore,
        --           {description = "go back", group = "tag"}),

        awful.key({ MODKEY,           }, "d",
            function ()
                awful.client.focus.byidx( 1)
            end,
            {description = "focus next by index", group = "client"}
        ),
        awful.key({ MODKEY,           }, "a",
            function ()
                awful.client.focus.byidx(-1)
            end,
            {description = "focus previous by index", group = "client"}
        ),

        -- Layout manipulation
        awful.key({ MODKEY, "Shift"   }, "d", function () awful.client.swap.byidx(  1) end,
                {description = "swap with next client by index", group = "client"}),
        awful.key({ MODKEY, "Shift"   }, "a", function () awful.client.swap.byidx( -1) end,
                {description = "swap with previous client by index", group = "client"}),
        awful.key({ MODKEY,           }, "q", function () awful.screen.focus(2) end,
                {description = "focus the next screen", group = "screen"}),
        awful.key({ MODKEY,           }, "e", function () awful.screen.focus(1) end,
                {description = "focus the previous screen", group = "screen"}),
        awful.key({ MODKEY, "Shift"   }, "q", function ()
            if client.focus then
                local tag = screen[1].selected_tag
                if tag then
                    client.focus:move_to_tag(tag)
                end
            end
        end,
                {description = "move client to screen 1", group = "screen"}),
        awful.key({ MODKEY, "Shift"   }, "e", function ()
            if client.focus then
                local tag = screen[2].selected_tag
                if tag then
                    client.focus:move_to_tag(tag)
                end
            end
        end,
                {description = "move client to screen 2", group = "screen"}),
        awful.key({ MODKEY,           }, "u", awful.client.urgent.jumpto,
                {description = "jump to urgent client", group = "client"}),
        awful.key({ MODKEY,           }, "Tab",
            function ()
                awful.client.focus.history.previous()
                if client.focus then
                    client.focus:raise()
                end
            end,
            {description = "go back", group = "client"}),
        awful.key({ MODKEY, "Shift"  }, "t",
            function ()
                local c = client.focus
                if c then
                    c.floating = false
                end
            end,
                {description = "unfloat focused client", group = "layout"}),

        -- Standard program
        awful.key({ MODKEY, "Shift"   }, "Return", function () awful.spawn(TERMINAL) end,
                {description = "open a terminal", group = "launcher"}),
        awful.key({ MODKEY, "Shift"   }, "r", awesome.restart,
                {description = "reload awesome", group = "awesome"}),
        -- awful.key({ MODKEY, "Shift"   }, "q", awesome.quit,
        --           {description = "quit awesome", group = "awesome"}),
        awful.key({ MODKEY,           }, "l", function () awful.spawn.with_shell('/home/hannah/.local/bin/lock') end,
                {description = "lock screen", group = "awesome"}),

        awful.key({ MODKEY,           }, "k",     function () awful.tag.incmwfact( 0.05)          end,
                {description = "increase master width factor", group = "layout"}),
        awful.key({ MODKEY,           }, "j",     function () awful.tag.incmwfact(-0.05)          end,
                {description = "decrease master width factor", group = "layout"}),
        awful.key({ MODKEY, "Shift"   }, "j",     function () awful.tag.incnmaster( 1, nil, true) end,
                {description = "increase the number of master clients", group = "layout"}),
        awful.key({ MODKEY, "Shift"   }, "k",     function () awful.tag.incnmaster(-1, nil, true) end,
                {description = "decrease the number of master clients", group = "layout"}),
        awful.key({ MODKEY, "Control" }, "j",     function () awful.tag.incncol( 1, nil, true)    end,
                {description = "increase the number of columns", group = "layout"}),
        awful.key({ MODKEY, "Control" }, "k",     function () awful.tag.incncol(-1, nil, true)    end,
                {description = "decrease the number of columns", group = "layout"}),
        awful.key({ MODKEY,           }, "space", function () awful.layout.inc( 1)                end,
                {description = "select next", group = "layout"}),
        awful.key({ MODKEY, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
                {description = "select previous", group = "layout"}),

        awful.key({ MODKEY, "Control" }, "n",
                function ()
                    local c = awful.client.restore()
                    -- Focus restored client
                    if c then
                        c:emit_signal(
                            "request::activate", "key.unminimize", {raise = true}
                        )
                    end
                end,
                {description = "restore minimized", group = "client"}),

        -- Prompt
        -- awful.key({ MODKEY },            "r",     function () awful.screen.focused().mypromptbox:run() end,
        --           {description = "run prompt", group = "launcher"}),

        awful.key({ MODKEY }, "x",
                function ()
                    awful.prompt.run {
                        prompt       = "Run Lua code: ",
                        textbox      = awful.screen.focused().mypromptbox.widget,
                        exe_callback = awful.util.eval,
                        history_path = awful.util.get_cache_dir() .. "/history_eval"
                    }
                end,
                {description = "lua execute prompt", group = "awesome"}),
        -- Menubar
        awful.key({ MODKEY }, "p", function() awful.spawn("rofi -show drun -theme \"/home/hannah/.config/rofi/launcher/style\"") end,
                {description = "show the application menu", group = "launcher"}),
        awful.key({ MODKEY }, "s", function() awful.spawn("rofi -show window -theme \"/home/hannah/.config/rofi/launcher/style\"") end,
                {description = "show the window menu", group = "launcher"}),
        awful.key({ MODKEY }, ".", function() awful.spawn("splatmoji copypaste") end,
                {description = "show the emoji picker", group = "launcher"}),


        -- Media
        awful.key({}, "XF86MonBrightnessUp"  , function() awful.spawn.with_shell("light -A 5") end,
                {description = "increase monitor brightness", group = "Media"}),
        awful.key({}, "XF86MonBrightnessDown", function() awful.spawn.with_shell("light -U 5") end,
                {description = "decrease monitor brightness", group = "Media"}),
        awful.key({}, "XF86AudioRaiseVolume" , function() awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%") end,
                {description = "increase speaker volume", group = "Media"}),
        awful.key({}, "XF86AudioLowerVolume" , function() awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%") end,
                {description = "decrease speaker volume", group = "Media"}),
        awful.key({}, "XF86AudioMute"        , function() awful.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle") end,
                {description = "toggle speaker", group = "Media"}),
        awful.key({}, "XF86AudioPlay"        , function() awful.spawn("playerctl -p playerctld play-pause") end,
                {description = "play/pause playback", group = "Media"}),
        awful.key({}, "XF86AudioPrev"        , function() awful.spawn("playerctl -p playerctld previous") end,
                {description = "play previous song", group = "Media"}),
        awful.key({}, "XF86AudioNext"        , function() awful.spawn("playerctl -p playerctld next") end,
                {description = "play next song", group = "Media"}),
        awful.key({ "Shift" }, "Print"       , function() awful.spawn.with_shell("import png:/tmp/snip.png") end,
                {description = "selection screenshot to tmp", group = "Media"}),
        awful.key({         }, "Print"       , function() awful.spawn.with_shell("import png:- | xclip -selection c -t image/png -i") end,
                {description = "selection screenshot to clipboard", group = "Media"}),
        awful.key({ MODKEY, "Shift" }, "s"   , function() awful.spawn.with_shell("import png:- | xclip -selection c -t image/png -i") end,
                {description = "selection screenshot to clipboard", group = "Media"}),


        -- Scratchpads
        awful.key({ MODKEY }, "t", function() scratchpad.toggle("terminal") end,
                {description = "toggle terminal scratchpad", group = "scratchpads"}),
        awful.key({ MODKEY }, "v", function() scratchpad.toggle("audio") end,
                {description = "toggle audio scratchpad", group = "scratchpads"}),
        awful.key({ MODKEY }, "b", function() scratchpad.toggle("passwords") end,
                {description = "toggle bitwarden scratchpad", group = "scratchpads"})
    )

    -- Bind all key numbers to tags.
    -- Be careful: we use keycodes to make it work on any keyboard layout.
    -- This should map on the top row of your keyboard, usually 1 to 9.
    for i = 1, 9 do
        globalkeys = gears.table.join(globalkeys,
            -- View tag only.
            awful.key({ MODKEY }, "#" .. i + 9,
                    function ()
                        tags.toggle(i)
                    end,
                    {description = "view tag #"..i, group = "tag"}),
            -- Toggle tag display.
            awful.key({ MODKEY, "Control" }, "#" .. i + 9,
                    function ()
                        local tag = tags.get_by_index(i)
                        if tag then
                            awful.tag.viewtoggle(tag)
                        end
                    end,
                    {description = "toggle tag #" .. i, group = "tag"}),
            -- Move client to tag.
            awful.key({ MODKEY, "Shift" }, "#" .. i + 9,
                    function ()
                        if client.focus then
                            local tag = tags.get_by_index(i)
                            if tag then
                                client.focus:move_to_tag(tag)
                            end
                        end
                    end,
                    {description = "move focused client to tag #"..i, group = "tag"}),
            -- Toggle tag on focused client.
            awful.key({ MODKEY, "Control", "Shift" }, "#" .. i + 9,
                    function ()
                        if client.focus then
                            local tag = tags.get_by_index(i)
                            if tag then
                                client.focus:toggle_tag(tag)
                            end
                        end
                    end,
                    {description = "toggle focused client on tag #" .. i, group = "tag"})
        )
    end

    -- Set keys
    root.keys(globalkeys)
    -- }}}
end

function keybinds.clientkeys ()
    return gears.table.join(
        awful.key({ MODKEY,           }, "Escape",
            function (c)
                c.fullscreen = not c.fullscreen
                c:raise()
            end,
            {description = "toggle fullscreen", group = "client"}),
        awful.key({ MODKEY, "Shift"   }, "c",      function (c) c:kill()                         end,
                {description = "close", group = "client"}),
        awful.key({ MODKEY,           }, "n",
            function (c)
                -- The client currently has the input focus, so it cannot be
                -- minimized, since minimized clients can't have the focus.
                c.minimized = true
            end ,
            {description = "minimize", group = "client"}),
        awful.key({ MODKEY,           }, "m",
            function (c)
                c.maximized = not c.maximized
                c:raise()
            end ,
            {description = "(un)maximize", group = "client"}),
        awful.key({ MODKEY, "Control" }, "m",
            function (c)
                c.maximized_vertical = not c.maximized_vertical
                c:raise()
            end ,
            {description = "(un)maximize vertically", group = "client"}),
        awful.key({ MODKEY, "Shift"   }, "m",
            function (c)
                c.maximized_horizontal = not c.maximized_horizontal
                c:raise()
            end ,
            {description = "(un)maximize horizontally", group = "client"}),
        awful.key({ MODKEY, "Shift"}, "u", function (c) c.bg_opaque = not c.bg_opaque end,
            {description = "toggle client unfocused opacity", group = "client"})
    )
end

function keybinds.clientbuttons()
    return gears.table.join(
        awful.button({ }, 1, function (c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
        end),
        awful.button({ MODKEY }, 1, function (c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
            c.floating = true
            awful.mouse.client.move(c)
        end),
        awful.button({ MODKEY }, 3, function (c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
            c.floating = true
            awful.mouse.client.resize(c)
        end)
    )
end


return keybinds
