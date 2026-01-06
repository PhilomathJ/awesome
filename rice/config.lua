-- DEPENDENCIES (see below)

local core = require("core")
local awful = require("awful")


local config = {}

---@class Features
---@field screenshot_tools boolean?
---@field magnifier_tools boolean?
---@field torrent_widget boolean?
---@field weather_widget boolean?
---@field redshift_widget boolean?
---@field wallpaper_menu boolean?
config.features = {
  screenshot_tools = true,
  magnifier_tools = false,
  torrent_widget = false,
  weather_widget = false,
  redshift_widget = true,
  wallpaper_menu = false,
}

config.places = {}
config.places.home = os.getenv("HOME")
config.places.config = os.getenv("XDG_CONFIG_HOME") or (config.places.home .. "/.config")
config.places.awesome = string.match(awful.util.get_configuration_dir(), "^(/?.-)/*$")
config.places.theme = config.places.awesome .. "/theme"
config.places.screenshots = config.places.home .. "/Pictures/screenshots"
config.places.wallpapers = config.places.home .. "/Pictures/wallpapers"

config.wm = {
  name = "awesome",
}

local terminal = "alacritty"
local terminal_execute = terminal .. " -e "

config.apps = {
  shell = "zsh",
  terminal = terminal,
  editor = terminal_execute .. "nano",
  browser = "brave",
  private_browser = "brave --incognito",
  file_manager = "dolphin",
  calculator = "qalculate-gtk",
  mixer = terminal_execute .. "pulsemixer",
  bluetooth_control = terminal_execute .. "bluetoothctl",
}

config.power = {
  shutdown = "systemctl poweroff",
  reboot = "systemctl reboot",
  suspend = "systemctl suspend",
  kill_session = "loginctl kill-session ''",
  lock_session = "loginctl lock-session",
  lock_screen = "light-locker-command --lock",
}

config.actions = {
  qr_code_clipboard = "qrclip",
  show_launcher = "rofi -show drun",
  show_emoji_picker = "ibus emoji",
  -- show_emoji_picker = config.places.config .. "/rofi/emoji-run.sh",
}

config.commands = {}

function config.commands.open(path)
  return "xdg-open \"" .. path .. "\""
end


local awful_utils = require("awful.util")
awful_utils.shell = config.apps.shell

return config
