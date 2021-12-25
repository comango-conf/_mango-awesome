local awful = require("awful")
local tags = require("tags")


local scratchpad = {}

local scratchpads = {}
scratchpads.terminal = {
    class = "scratch",
    cmd = TERMINAL .. " --class scratch --title scratch",
    rules = {
        floating = true,
        ontop = true,
        skip_taskbar = true,
        titlebars_enabled = false,
        placement = awful.placement.centered + awful.placement.top,
        width = 1200,
        height = 600,
    }
}
scratchpads.audio = {
    class = "Pavucontrol",
    cmd = "pavucontrol",
    rules = {
        floating = true,
        ontop = true,
        skip_taskbar = true,
        titlebars_enabled = false,
        placement = awful.placement.centered + awful.placement.top,
        width = 1200,
        height = 400,
    }
}
scratchpads.passwords = {
    class = "Bitwarden",
    cmd = "bitwarden-desktop",
    rules = {
        floating = true,
        ontop = true,
        skip_taskbar = true,
        titlebars_enabled = false,
        placement = awful.placement.centered + awful.placement.top,
        width = 1200,
        height = 600,
    }
}

function scratchpad.toggle(name)
    local scratch = scratchpads[name]
    local curr_tag = awful.screen.focused().selected_tag

    -- check if instance of scratchpad is already running
    for _, c in ipairs(client.get()) do
        if c.class == scratch.class then


            -- scratchpad is on current tag and needs to be moved to stash
            if c.first_tag == curr_tag then

                -- make sure the stash is one the current screen,
                -- so the scratchpad doesnt suddenly jump around before it has faded out
                local scrpds = awful.tag.find_by_name(nil, "scratchpads")
                scrpds.screen = awful.screen.focused()
                c:move_to_tag(scrpds)
                return
            end

            -- if current screen has not tag selected, spawn a temp one
            if not curr_tag then
                curr_tag = tags.add_temp(awful.screen.focused(), true)
            end

            -- else move pad to current tag
            c:move_to_tag(curr_tag)
            client.focus = c
            -- c:activate {
            --     switch_to_tag = true
            -- }
            return
        end
    end

    -- if focused screen as no tag selected, spawn one
    if not curr_tag then
        curr_tag = tags.add_temp(awful.screen.focused(), true)
    end

    local rules = { table.unpack(scratch.rules) };
    rules[tags] = { curr_tag };

    awful.spawn(scratch.cmd, rules)
end

function scratchpad.rules()
    local rules = {}

    for _, scratch in scratchpads do
        rules.insert(
            { rule_any = {
                class = { scratch.class }
            },
            properties = scratch.rules,
            }
        )
    end

    return rules
end

return scratchpad
