local awful = require("awful")
local naughty = require("naughty")
local util = require("util")

local old_volume = {}

awful.spawn.with_line_callback(
    "/home/hannah/.local/bin/volume-notify.sh",
    {
        stdout = function (out)
            local split = util.split(out, "\t")

            local new_volume = {
                sink   = split[1]:gsub("\"", ""),
                volume = tonumber(split[2]),
                muted  =  split[3] == "true"
            }

            if new_volume.sink   ~= old_volume.sink
            or new_volume.volume ~= old_volume.volume
            or new_volume.muted   ~= old_volume.muted
            then
                awesome.emit_signal("volume::change", new_volume, old_volume)
                old_volume = new_volume
            end
        end,
    }
)