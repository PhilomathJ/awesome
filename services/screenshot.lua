-- DEPENDENCIES (feature flag "screenshot_tools"): maim, xclip, xdotool, date

local config = require("rice.config")
if not config.features.screenshot_tools then
    return
end

local format = string.format
local awful = require("awful")
local beautiful = require("theme.theme")
local tcolor = require("utils.color")
local places = require("rice.places")
local naughty = require("naughty")


local screenshot = {}

function screenshot.take(args)
    args = args or {}

    args.format = args.format or "png"

    local command = "maim --quiet --hidecursor --format " .. args.format

    if args.delay then
        command = format("%s --delay %.0f", command, args.delay)
    end

    if args.shader then
        command = format("%s --shader %s", command, args.shader)
    end

    -- Determine screenshot mode description and build notification message immediately
    local mode_desc
    if args.mode == "selection" then
        command = format("%s --select --highlight --bordersize %.0f --color %s", command,
            beautiful.screen_selection_border_width,
            tcolor.format_slop(beautiful.screen_selection_color))
        mode_desc = "Selection"
    elseif args.mode == "window" then
        command = format("%s --window %s", command, args.window or "$(xdotool getactivewindow)")
        mode_desc = "Window"
    elseif args.mode == "screen" or args.mode == nil then
        -- Capture only the focused monitor/screen
        local screen = awful.screen.focused()
        if screen then
            local geom = screen.geometry
            command = format("%s --geometry=%dx%d+%d+%d", command,
                geom.width, geom.height, geom.x, geom.y)
        end
        mode_desc = "Current monitor"
    elseif args.display then
        command = format("%s --xdisplay %s", command, args.display)
        mode_desc = "Screen"
    end

    -- Determine output destination
    local output_desc
    if args.output == "clipboard" then
        command = format("%s | xclip -selection clipboard -t image/%s", command, args.format)
        output_desc = "Copied to clipboard"
    elseif args.output then
        command = format("%s \"%s\"", command, args.output)
        output_desc = format("Saved to %s", args.output)
    else
        local file_name = "$(date '+%Y%m%d-%H%M-%S')"
        command = format("%s \"%s/%s.%s\"", command, config.places.screenshots, file_name, args.format)
        output_desc = "Saved to file"
    end

    -- Create the complete message as a single string immediately
    local final_message = mode_desc .. " screenshot captured\n" .. output_desc
    local check_selection_cancel = (args.mode == "selection")

    -- Execute screenshot command and show notification only on completion
    awful.spawn.easy_async_with_shell(command, function(stdout, stderr, exitreason, exitcode)
        if exitreason == "exit" and exitcode == 0 then
            -- Show success notification
            naughty.notification {
                title = "Screenshot",
                message = final_message,
                timeout = 3,
                urgency = "normal",
            }
        elseif exitcode == 1 and check_selection_cancel then
            -- Exit code 1 for selection mode usually means user cancelled
            -- Don't show error notification for cancellation
        else
            -- Show failure notification
            naughty.notification {
                title = "Screenshot Failed",
                message = "Failed to capture screenshot",
                timeout = 3,
                urgency = "critical",
            }
        end
    end)
end

return screenshot
