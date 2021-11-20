local awful = require("awful")
local tags = require("tags")


local scratchpad = {}

local scratchpads = {}
scratchpads.terminal = {
    class = "scratch",
    cmd = TERMINAL .. " --class scratch --title scratch"
}
scratchpads.audio = {
    class = "Pavucontrol",
    cmd = "pavucontrol",
}
scratchpads.passwords = {
    class = "Bitwarden",
    cmd = "bitwarden"
}

function scratchpad.toggle(name)
    local scratch = scratchpads[name]
    local curr_tag = awful.screen.focused().selected_tag

    -- check if instance of scratchpad is already running
    for _, c in ipairs(client.get()) do
        if c.class == scratch.class then


            -- scratchpad is on current tag and needs to be moved to stash
            if c.first_tag == curr_tag then

                -- make sure the stach is one the current screen,
                -- so the scratchpad doesnt suddenly jump around befor it faded out
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

    awful.spawn(scratch.cmd, { tags = { curr_tag } })
end

return scratchpad