package.path = package.path .. ";" .. os.getenv("HOME") .. "/.local/share/lua/?.lua;" .. os.getenv("HOME") ..
    "/.local/share/lua/?/init.lua"


-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

require("variables")
require("volume_signal")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local wibox = require("wibox")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

local tags = require("tags")
local dock = require("dock")
local keybinds = require("keybinds")
local titlebar = require("titlebar")
local theme = require("theme")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors })
end


-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function(err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err) })
        in_error = false
    end)
end
-- }}}



if awesome.startup then
    -- awful.spawn.once({"comango", "hook", "wminit"})
end


-- Menubar configuration
menubar.utils.TERMINAL = TERMINAL -- Set the terminal for applications that require it




local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    dock.create(s)
end)
-- }}}


-- screen[1]:fake_resize(0,0,960,1080)
-- screen.fake_add(960,0,960,1080)



tags.create(screen[1])


keybinds.set()



-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = {},
        properties = { border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = keybinds.clientkeys(),
            buttons = keybinds.clientbuttons(),
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen,
            size_hints_honor = false,
        }
    },

    -- dialogs
    { rule_any = {
        type = { "dialog" },
        class = { "Gcr-prompter" }
    },
        properties = {
            placement = awful.placement.centered,
        }
    },

    -- Floating clients.
    { rule_any = {
        class = {
            "Blueman-manager",
        },
        role = {
            "AlarmWindow", -- Thunderbird's calendar.
            "ConfigManager", -- Thunderbird's about:config.
            "pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
        }
    },
        properties = {
            floating = true,
        }
    },

    -- Add titlebars to normal clients and dialogsE
    { rule_any = { type = { "normal", "dialog" }
    }, properties = { titlebars_enabled = false }
    },

    { rule_any = {
        class = {
            "Vivaldi",
            "Firefox",
            "Microsoft-edge",
            "Microsoft-edge-dev",
            "Microsoft-edge-beta",
            "Chromium"
        }
    },
        properties = {
            maximized = false,
            -- opacity = 0.2,
        }
    },


    { rule_any = {
        class = {
            "Firefox",
            "Microsoft-edge",
            "Microsoft-edge-dev",
            "Microsoft-edge-beta",
            "Chromium"
        }
    },
        properties = { tag = "www" }
    },
    { rule_any = {
        class = {
            "Code",
            "jetbrains-webstorm",
            "jetbrains-idea"
        }
    },
        properties = { tag = "code" }
    },
    { rule_any = {
        class = {
            "Steam"
        }
    },
        properties = { tag = "misc" }
    },
    { rule_any = {
        class = {
            "Spotify",
            "spotify",
        }
    },
        properties = { tag = "music" }
    },
    { rule_any = {
        class = {
            "discord",
            "Signal",
            "Element",
            "whatsapp-desktop"
        },
    },
        properties = { tag = "chat" }
    },

    { rule_any = {
        class = {
            "Thunderbird",
            "thunderbird",
            "Mail"
        }
    },
        properties = { tag = "mail" }
    },

    { rule_any = {
        class = {
            "zoom"
        }
    },
        properties = { tag = "zoom" }
    },

    -- games
    { rule_any = {
        name = {
            -- "Warframe"
        }
    },
        properties = {
            floating = true,
            tag = "misc",
            fullscreen = true,
            placement = awful.placement.centered,
            shape = nil,
        }
    },

    -- scratchpads
    { rule_any = {
        class = {
            "scratch"
        }
    },
        properties = {
            floating = true,
            ontop = true,
            skip_taskbar = true,
            titlebars_enabled = false,
            placement = awful.placement.centered + awful.placement.top,
            width = 1200,
            height = 600,
        }
    },
    { rule_any = {
        class = {
            "Pavucontrol"
        }
    },
        properties = {
            floating = true,
            ontop = true,
            skip_taskbar = true,
            titlebars_enabled = false,
            placement = awful.placement.centered + awful.placement.top,
            width = 1200,
            height = 400,
        }
    },
    { rule_any = {
        class = {
            "Bitwarden"
        }
    },
        properties = {
            floating = true,
            ontop = true,
            skip_taskbar = true,
            titlebars_enabled = false,
            placement = awful.placement.centered + awful.placement.top,
            width = 1200,
            height = 600,
        }
    },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)


    c:connect_signal("property::class", function()
        if c.class:lower() == "spotify" then
            c:move_to_tag("music")
        end
    end)

    if not c.fullscreen then
        -- c.shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 5) end
    end

    c:connect_signal("property::fullscreen", function(c)
        if c.fullscreen then
            c.shape = nil
        else
            -- c.shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 5) end
        end
    end)

    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
        and not c.size_hints.user_position
        and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

client.connect_signal("request::titlebars", titlebar)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

client.connect_signal("focus", function(c)
    c.border_color = beautiful.border_focus
    c.opacity = 1
end)
client.connect_signal("unfocus", function(c)
    c.border_color = beautiful.border_normal

    if not c.bg_opaque then
        c.opacity = BACKGROUND_OPACITY
    end
end)
-- }}}
