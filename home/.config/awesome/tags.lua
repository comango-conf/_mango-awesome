local awful = require("awful")
local naughty = require("naughty")
local layouts = require("layouts")
-- local misc = require("wslua.misc")
local util = require("util")


awful.layout.append_default_layouts({
    layouts.tile,
    layouts.minmax,
    layouts.accordion,
    awful.layout.suit.floating
})

local tags = {}

local taglist = {}
tags.taglist = taglist

local indextable = {}

local i = 1

function tags.add(name, args)
    taglist[name] = args
end

local function default_tag(tag)
    local instance = awful.tag.add(tag.name, {
        layout             = tag.layout             or awful.layout.layouts[1],
        master_fill_policy = tag.master_fill_policy or "expand",
        gap_single_client  = tag.gap_single_client  or true,
        gap                = tag.gap                or 5,
        selected           = tag.selected           or false,
        screen             = tag.s,
    })

    indextable[i] = tag.name
    tags.add(tag.name, {
        index    = i,
        icon     = tag.icon,
        instance = instance,
    })
    i = i + 1
end

function tags.create(s)
    default_tag {
        name     = "www",
        icon     = "",
        screen   = s,
        selected = true,
    }
    default_tag {
        name     = "code",
        icon     = "",
        screen   = s,
    }
    default_tag {
        name     = "term",
        icon     = "",
        screen   = s,
    }
    default_tag {
        name     = "misc",
        icon     = "",
        screen   = s,
        layout   = awful.layout.layouts[4],
    }
    default_tag {
        name     = "music",
        icon     = "",
        screen   = s,
    }
    default_tag {
        name     = "chat",
        icon     = "",
        screen   = s,
    }
    default_tag {
        name     = "mail",
        icon     = "",
        screen   = s,
    }
    default_tag {
        name     = "zoom",
        icon     = "",
        screen   = s,
    }
    -- default_tag("scratchpads", s)

    local scrpd = awful.tag.add("scratchpads", {
        layout             = awful.layout.layouts[1],
        master_fill_policy = "expand",
        gap_single_client  = true,
        gap                = 5,
        screen             = s,
        selected           = false,
        volatile           = false,
        activated          = true,
    })

    scrpd:connect_signal("property::selected", function(self)
        self.selected = false
    end)


    -- misc.print(taglist)
    -- misc.print(awful.widget.taglist.source.for_screen(s))
end

function tags.toggle(index)
    local name = indextable[index]

    -- if tag is on the focused screen select it
    local tag = awful.tag.find_by_name(awful.screen.focused(), name)
    if tag then
        tag:view_only()
        return
    end

    -- otherwise find tag
    tag = awful.tag.find_by_name(nil, name)

    -- if tag doesnt exist exit
    if not tag then
        return nil
    end

    -- if tag is the selected_tag on its screen, tags have to be switched
    if tag.screen.selected_tag == tag then
        local oldtag = awful.screen.focused().selected_tag

        -- if focused screen has no tag selected there is nothing to swap
        if oldtag ~= nil then
            oldtag.screen = tag.screen
            oldtag:view_only()
        end
    end
    -- swap desired tag to focused screen
    tag.screen = awful.screen.focused()
    tag:view_only()
end

function tags.get_by_index(index)
    local name = indextable[index]
    return awful.tag.find_by_name(nil, name)
end

function tags.add_temp(s, selected)
    local t = awful.tag.add("temp", {
        layout             = awful.layout.layouts[1],
        master_fill_policy = "expand",
        gap_single_client  = true,
        gap                = 5,
        screen             = s,
        selected           = selected or false,
        volatile           = true
    })

    t:connect_signal("untagged", function()
        -- if next(t:clients()) == nil then
        --     local screen = t.screen
        --     -- t:delete(nil)
        --     screen.selected_tag = nil
        -- end
    end)
    return t
end

function tags.source()
    table.sort(taglist, function(a, b) return a.index < b.index end)
    return util.map(function(t) return t.instance end, taglist);
end

return tags
