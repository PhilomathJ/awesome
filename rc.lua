---@diagnostic disable: undefined-global
require("develop")
require("globals")

require("core")

require("config")
require("theme")
require("rice")
require("services")
require("ui")

---@diagnostic disable: param-type-mismatch
collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)
---@diagnostic enable: param-type-mismatch

-- Autostart applications
local awful = require("awful")
awful.spawn.with_shell("~/.config/awesome/autorun.sh")
