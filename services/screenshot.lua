-- DEPENDENCIES: maim, xclip, xdotool, date
local awful = require("awful")
local naughty = require("naughty")
local config = require("rice.config")

-- Return early if feature is disabled
if not (config.features and config.features.screenshot_tools) then
  return {}
end

local screenshot = {}
local format = string.format

-- Helper to get current screen geometry for maim
local function get_screen_geom()
  local s = awful.screen.focused()
  local g = s.geometry
  return format("--geometry=%dx%d+%d+%d", g.width, g.height, g.x, g.y)
end

function screenshot.take(args)
  args = args or {}
  local file_format = args.format or "png"
  local timestamp = os.date("%Y%m%d-%H%M-%S")
  local screenshot_dir = config.places and config.places.screenshots or os.getenv("HOME")

  -- If args.output is a path (contains /) use it; otherwise generate a timestamped one.
  local is_literal_path = type(args.output) == "string" and args.output:find("/")
  local file_path = is_literal_path and args.output or format("%s/%s.%s", screenshot_dir, timestamp, file_format)

  -- Base Command Construction
  local cmd_parts = { "maim", "--quiet", "--hidecursor", "--format", file_format }

  if args.delay then table.insert(cmd_parts, format("--delay %.0f", args.delay)) end
  if args.shader then table.insert(cmd_parts, format("--shader %s", args.shader)) end

  -- Mode Table
  local modes = {
    ["selection"] = { flag = "--select", desc = "Selection" },
    ["window"]    = { flag = "--window " .. (args.window or "$(xdotool getactivewindow)"), desc = "Window" },
    ["display"]   = { flag = "--xdisplay " .. (args.display or ""), desc = "Screen" },
    ["screen"]    = { flag = get_screen_geom(), desc = "Current monitor" },
  }

  -- Default to "screen" if mode is nil or invalid
  local selected_mode = modes[args.mode] or modes["screen"]
  table.insert(cmd_parts, selected_mode.flag)

  -- Output Table
  local outputs = {
    ["clipboard"] = {
      flag = format("| xclip -selection clipboard -t image/%s > /dev/null 2>&1 &", file_format),
      desc = "Copied to clipboard",
    },
    ["github"] = {
      -- Saves to the local repo, then stages and pushes
      -- Change the path below to the actual local repo location
      flag = format("\"%s\" && cd %s && git add . && git commit -m 'docs: auto-screenshot %s' && git push",
        file_path, config.places.homelab_repo or "~/Documents/Homelab", timestamp),
      desc = "Pushed to Homelab GitHub",
    },
    ["remote_storage"] = {
      -- Saves locally then SCPs to NAS or remote server
      flag = format("\"%s\" && scp \"%s\" user@192.168.20.222:/mnt/storage/screenshots/", file_path, file_path),
      desc = "Uploaded to Remote Storage",
    },
    ["default"] = {
      flag = format("\"%s\"", file_path),
      desc = "Saved to " .. file_path,
    },
  }

  local selected_output = outputs[args.output] or outputs["default"]
  table.insert(cmd_parts, selected_output.flag)

  -- 4. Execution
  local command = table.concat(cmd_parts, " ")
  local notification_msg = format("%s screenshot captured\n%s", selected_mode.desc, selected_output.desc)

  awful.spawn.easy_async_with_shell(command, function(_, stderr, exitreason, exitcode)
    if exitreason == "exit" and exitcode == 0 then
      naughty.notify {
        title = "📸 Screenshot Processed",
        text = notification_msg,
        timeout = 5, -- Longer timeout for network uploads
      }
    elseif not (args.mode == "selection" and exitcode == 1) then
      naughty.notify {
        title = "❌ Screenshot Failed",
        text = stderr or "Check terminal for logs",
        urgency = "critical",
      }
    end
  end)
end

return screenshot
