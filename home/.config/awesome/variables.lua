local beautiful = require("beautiful")
local naughty = require("naughty")
local gears = require("gears")


TERMINAL = "kitty"
EDITOR = os.getenv("EDITOR") or "nano"
EDITOR_CMD = TERMINAL .. " -e " .. EDITOR


MODKEY = "Mod4"

-- Themes define colours, icons, font and wallpapers.
beautiful.init("/home/hannah/.config/awesome/theme.lua")

naughty.config.defaults.position = "top_middle"
-- naughty.config.defaults.shape = function(cr,w,h) gears.shape.rounded_rect(cr,w,h,5) end



ENABLE_WIFI = "<#{ENABLE_WIFI}#>" == "true"
WIFI_DEVICE = "<#{WLAN_INTERFACE}#>"

ENABLE_BATTERY = "<#{ENABLE_BATTERY}#>" == "true"

BACKGROUND_OPACITY = tonumber("<#{BACKGROUND_OPACITY}#>")