local awful = require("awful")
local naughty = require("naughty")
local minmax = require("layouts.minmax")
local accordion = require("layouts.accordion")
local misc = require("wslua.misc")


awful.layout.append_default_layouts({
    awful.layout.suit.tile,
    minmax,
    accordion,
})

local tags = {}

local taglist = {}
tags.taglist = taglist

local indextable = {}

local i = 1

function tags.add(name, args)
    taglist[name] = args
end

local function default_tag(name, s, icon, selected)
    local instance = awful.tag.add(name, {
        layout             = awful.layout.layouts[1],
        master_fill_policy = "expand",
        gap_single_client  = true,
        gap                = 5,
        screen             = s,
        selected           = selected or false,
    })

    indextable[i] = name
    tags.add(name, {
        index = i,
        icon = icon,
        instance = instance,
    })
    i = i + 1
end

function tags.create(s)
    default_tag("www", s, "", true)
    default_tag("code", s, "")
    default_tag("term", s, "")
    default_tag("misc", s, "")
    default_tag("music", s, "")
    default_tag("chat", s, "")
    default_tag("mail", s, "")
    default_tag("zoom", s, "")
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


    misc.print(taglist)
    misc.print(awful.widget.taglist.source.for_screen(s))
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
    local ret = {}

    for _, tag in ipairs(taglist) do
        ret.append(tag.instance)
    end

    return ret;
end

return tags
