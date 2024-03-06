local awful = require("awful")
local naughty = require("naughty")
local ruled = require("ruled")
local beautiful = require("theme.theme")
local core_tag = require("core.tag")
local capi = Capi

---@class Rice.Rules
local rules = {}

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

local function describe_client(c)
    local msg = ""
    msg = msg .. "class: " .. tostring(c.class) .. "\n"
    msg = msg .. "instance: " .. tostring(c.instance) .. "\n"
    msg = msg .. "name: " .. tostring(c.name) .. "\n"
    msg = msg .. "pid: " .. tostring(c.pid) .. "\n"
    msg = msg .. "screen: " .. tostring(c.screen)

    naughty.notify({text = msg})
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
-- Volatile 'Messages' tag properties
local messages_tag = {
    name = "Messaging",
    screen = "DP-4",
    layout = awful.layout.suit.fair,
    volatile = true
}

    -- Signal desktop app
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
    -- Google Messages PWA
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
                visible = false,
                            },
            callback  = function (c)
                -- Check if Google Messages PWA is already running
                -- Kill client if an instance is already running
                -- Apply focus to client
                local msg_client_counter = 0
                local running_client = {}   -- Holds an instance of the running Google Messages PWA client
                
                local brave_msgs_clients = function(all_clients)
                    return awful.rules.match(all_clients, {class = "Brave-browser", instance = "crx_hpfldicfbfomlpcikngkocigghgafkph"})
                end

                for msg_client in awful.client.iterate(brave_msgs_clients) do
                    describe_client(msg_client)
                    if msg_client_counter >= 1 then  -- if a running client already exists, kill the new one
                        c:kill()
                        naughty.notify({text = "Killed the new client: " .. c.instance})
                        break
                    end
                    running_client = msg_client -- store a reference to the running client
                    msg_client_counter = msg_client_counter + 1
                end

                -- Continue to launch client on specific tag
                naughty.notify({text = "Google Messages PWA is not running. Starting a fresh instance"})
                local  msg_tag = assert_tag(c, messages_tag)
                if msg_tag then
                    c:move_to_tag (msg_tag)
                    c.visible = true
                end
            end
        },
    }
    ----------------------------------------------------------------------------------------------------
    -- LinkedIn PWA
    ruled.client.append_rules {
        {
            rule = {
                instance = "crx_ohghonlafcimfigiajnmhdklcbjlbfda",
                class = "Brave-browser",
            },
            properties = {
                tag = "2",
                floating = false,
                switch_to_tags = true,
            },
        },
    }
    ----------------------------------------------------------------------------------------------------
    -- Discord desktop app
    ruled.client.append_rules {
        {
            rule = {
                class = "discord",
            },
            properties = {
                screen = "DP-0",
                tag = "4",
                floating = false,
                switch_to_tags = true,
                -- layout = awful.layout.suit.fair,,
            },
        },
    }
    ----------------------------------------------------------------------------------------------------
    -- Discord
    ruled.client.append_rules {
        {
            rule = {
                instance = "crx_mjoklplbddabcmpepnokjaffbmgbkkgg",
                class = "Brave-browser",
            },
            properties = {
                screen = "DP-4",
                tag = "3",
                floating = false,
                switch_to_tags = true,
                -- layout = awful.layout.suit.fair,,
            },
        },
    }
    ----------------------------------------------------------------------------------------------------
    -- YouTube PWA
    ruled.client.append_rules {
        {
            rule = {
                instance = "crx_agimnkijcaahngcdmfeangaknmldooml",
                class = "Brave-browser",
            },
            properties = {
                screen = "DP-4",
                tag = "6",
                floating = false,
                titlebars_enabled = false,
                switch_to_tags = true,
                -- layout = awful.layout.suit.fair,,
            },
        },
    }
    ----------------------------------------------------------------------------------------------------
    -- Gmail PWA
    ruled.client.append_rules {
        {
            rule = {
                instance = "crx_fmgjjmmmlfnkbppncabfkddbjimcfncm",
                class = "Brave-browser",
            },
            properties = {
                screen = "DP-0",
                tag = "5",
                floating = false,
                titlebars_enabled = false,
                switch_to_tags = true,
                -- layout = awful.layout.suit.fair,,
            },
        },
    }
    ----------------------------------------------------------------------------------------------------
    -- Notion app
    ruled.client.append_rules {
        {
            rule = {
                class = "notion-snap-reborn",
            },
            properties = {
                screen = "DP-4",
                tag = "2",
                floating = false,
                switch_to_tags = true,
                -- layout = awful.layout.suit.fair,,
            },
        },
    }
    ----------------------------------------------------------------------------------------------------
    -- Google Drive PWA
    ruled.client.append_rules {
        {
            rule = {
                instance = "crx_aghbiahbpaijignceidepookljebhfak",
                class = "Brave-browser",
            },
            properties = {
                -- screen = "DP-4",
                -- tag = "6",
                floating = false,
                titlebars_enabled = false,
                -- switch_to_tags = true,
                -- layout = awful.layout.suit.fair,,
            },
        },
    }
    ----------------------------------------------------------------------------------------------------
    -- Facebook PWA
    ruled.client.append_rules {
        {
            rule = {
                instance = "crx_kippjfofjhjlffjecoapiogbkgbpmgej",
                class = "Brave-browser",
            },
            properties = {
                -- screen = "DP-4",
                -- tag = "6",
                floating = false,
                titlebars_enabled = false,
                -- switch_to_tags = true,
                -- layout = awful.layout.suit.fair,,
            },
        },
    }
    ----------------------------------------------------------------------------------------------------
    -- Calculator floating and on top
    ruled.client.append_rules {
        {
            rule_any = {
                class = {
                    "qalculate-gtk",
                    "Qalculate-gtk",
                }
            },
            properties = {
                -- screen = "DP-4",
                -- tag = "6",
                floating = true,
                titlebars_enabled = false,
                ontop = true,
                sticky = true,
            },
        },
    }
end)

return rules
