local awful = require("awful")
local ruled = require("ruled")
local beautiful = require("theme.theme")
local core_tag = require("core.tag")

---@class Rice.Rules
local rules = {}

-- Volatile 'Messages' tag properties
local messages_tag = {
    name = "Messaging",
    screen = "DP-4",
    layout = awful.layout.suit.fair,
    volatile = true
}

-- messages_tag.properties = {
--     name = "Messaging",
--     screen = "DP-4",
--     layout = awful.layout.suit.fair,
--     volatile = true
-- }

-- Return a reference to the asserted tag if exists, create it if not
local function assert_tag(c, tag_props)
    for _, tag in ipairs(c.screen.tags) do
        if tag.name == tag_props.name then 
            return tag
        end
    end
    
    -- Tag does not exist. Create it and return the reference
    local new_tag = awful.tag.add(tag_props.name, tag_props)
    return new_tag
end

ruled.client.connect_signal("request::rules", function()
    ----------------------------------------------------------------------------------------------------
    ruled.client.append_rules {
        {
            id = "global",
            rule = {},
            properties = {
                screen = awful.screen.preferred,
                focus = awful.client.focus.filter,
                titlebars_enabled = DEBUG,
                raise = true,
                shape = beautiful.client.shape,
            },
            callback = function(client)
                awful.client.setslave(client)
            end,
        },
        {
            id = "tools",
            rule_any = {
                floating = true,
                type = "dialog",
            },
            properties = {
                floating = true,
                titlebars_enabled = "toolbox",
            },
        },
        {
            id = "floating",
            rule_any = {
                class = {
                    "Arandr",
                },
                role = {
                    "pop-up",
                },
            },
            properties = {
                floating = true,
                titlebars_enabled = true,
            },
        },
        {
            id = "picture_in_picture",
            rule_any = {
                name = {
                    "Picture in picture",
                    "Picture-in-Picture",
                },
            },
            properties = {
                titlebars_enabled = "toolbox",
                floating = true,
                ontop = true,
                sticky = true,
                placement = function(client)
                    awful.placement.bottom_right(client, {
                        honor_workarea = true,
                        margins = beautiful.edge_gap,
                    })
                end,
            },
        },
        {
            id = "no_size_hints",
            rule_any = {
                class = {
                    "XTerm",
                },
            },
            properties = {
                size_hints_honor = false,
            },
        },
        {
            id = "urgent",
            rule_any = {
                class = {
                    "^Gcr-prompter$",
                },
                name = {
                    "^Authenticate$",
                },
            },
            properties = {
                floating = true,
                ontop = true,
                sticky = true,
                titlebars_enabled = "toolbox",
                placement = awful.placement.centered,
            },
        },
    }
    ----------------------------------------------------------------------------------------------------
    ruled.client.append_rules {
        {
            rule = {
                class = "SpeedCrunch",
            },
            properties = {
                floating = true,
                ontop = true,
                titlebars_enabled = true,
            },
        },
    }
    ----------------------------------------------------------------------------------------------------
    ruled.client.append_rules {
        {
            rule = {
                class = "^1Password$",
            },
            properties = {
                floating = true,
                titlebars_enabled = true,
            },
        },
        {
            rule = {
                class = "^1Password$",
                name = "Quick Access",
            },
            properties = {
                skip_taskbar = true,
                titlebars_enabled = "toolbox",
            },
        },
    }
    ----------------------------------------------------------------------------------------------------
    ruled.client.append_rules {
        {
            rule = {
                class = "qr_code_clipboard",
            },
            properties = {
                floating = true,
                ontop = true,
                sticky = true,
                placement = awful.placement.centered,
                titlebars_enabled = "toolbox",
            },
        },
    }
    ----------------------------------------------------------------------------------------------------
    ruled.client.append_rules {
        {
            rule = {
                class = "Dragon-drop",
            },
            properties = {
                floating = true,
                ontop = true,
                sticky = true,
                placement = awful.placement.centered,
                titlebars_enabled = "toolbox",
                border_color = beautiful.common.secondary_bright,
            },
        },
    }
    ----------------------------------------------------------------------------------------------------
    ruled.client.append_rules {
        {
            rule = {
                class = "^Xephyr$",
            },
            properties = {
                floating = false,
                switch_to_tags = true,
                new_tag = core_tag.build {
                    name = "Xephyr",
                    volatile = true,
                    selected = true,
                },
            },
        },
    }
    ----------------------------------------------------------------------------------------------------
    ruled.client.append_rules {
        {
            rule = {
                name = "^Event Tester$",
            },
            properties = {
                titlebars_enabled = "toolbox",
                floating = true,
                ontop = true,
                sticky = true,
                placement = function(client)
                    awful.placement.bottom_left(client, {
                        honor_workarea = true,
                        margins = beautiful.edge_gap,
                    })
                end,
            },
        },
    }
    ----------------------------------------------------------------------------------------------------
    ruled.client.append_rules {
        {
            rule = {
                class = "^Spotify$",
            },
            properties = {
                new_tag = core_tag.build {
                    name = "Spotify",
                    volatile = true,
                },
            },
        },
    }
    ----------------------------------------------------------------------------------------------------
    ruled.client.append_rules {
        {
            rule = {
                class = "^FreeTube$",
            },
            properties = {
                new_tag = core_tag.build {
                    name = "FreeTube",
                    volatile = true,
                },
            },
        },
    }
    ---------------------------------------------------------------------------------------------------- 
    ruled.client.append_rules {
        {
            rule = {
                class = "Signal",
                name = "^Signal$"
            },
            properties = {
                tag = messages_tag.name,
                screen = messages_tag.screen,
                layout = messages_tag.layout,
                floating=false,
            },
            callback  = function (c)
                local  msg_tag = assert_tag(c, messages_tag)
                if msg_tag then
                    c:move_to_tag (msg_tag)
                end
            end
        },
    }
    ----------------------------------------------------------------------------------------------------
    ruled.client.append_rules {
        {
            rule = {
                -- name = "^Messages for web$"
                instance = "crx_hpfldicfbfomlpcikngkocigghgafkph",
                class = "Brave-browser",
            },
            properties = {
                tag = messages_tag.name,
                screen = messages_tag.screen,
                layout = messages_tag.layout,
                floating=false,
                titlebars_enabled = false,
            },
            callback  = function (c)
                local  msg_tag = assert_tag(c, messages_tag)
                if msg_tag then
                    c:move_to_tag (msg_tag)
                end
            end
        },
    }
    ----------------------------------------------------------------------------------------------------

end)

return rules
