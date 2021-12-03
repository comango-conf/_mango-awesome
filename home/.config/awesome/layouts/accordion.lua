local naughty = require("naughty")
local awful = require("awful")

local accordion = {
    name = "accordion",
}

local state = {}


function accordion.arrange (p)
    local area = p.workarea

    local clients = p.clients

    if #clients < 1 then
        return
    end

    if #p.clients == 1 then
        p.geometries[clients[1]] = {
            x      = area.x,
            y      = area.y,
            width  = area.width,
            height = area.height
        }
        return
    end

    local sel
    for s in screen do
        if s.index == p.screen then
            sel = s
        end
    end

    -- naughty.notify { text = show(p) }


    local order = {};
    local i = 1
    local c = clients[i]
    while c do
        if c == client.focus then
            if clients[i + 1] == nil then
                order[clients[i - 1]] = 1
                order[c] = 2
            else
                order[c] = 1
                i = i + 1
                c = clients[i]
                order[c] = 2
            end
            state[sel.selected_tag] = c
        elseif c == state[sel.selected_tag] then
            order[c] = 1
            i = i + 1
            c = clients[i]
            order[c] = 2
        else
            order[c] = 0;
        end
        i = i + 1
        c = clients[i]
    end

    -- naughty.notify { text = show(order) }

    for _, c in pairs(p.clients) do
        if order[c] == 1 then
            p.geometries[c] = {
                    x      = area.x,
                    y      = area.y,
                    width  = area.width / 2,
                    height = area.height,
                }
        elseif order[c] == 2 then
            p.geometries[c] = {
                x      = area.x + area.width / 2,
                y      = area.y,
                width  = area.width / 2,
                height = area.height,
            }
        else 
            p.geometries[c] = {
                x = area.x,
                y = area.y + area.height,
                width = area.width,
                height = area.height
            }
        end
    end


end

function accordion.skip_gap (nclients, t)
    return true;
end




return accordion;