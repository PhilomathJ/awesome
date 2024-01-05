-- requirements
-- ~~~~~~~~~~~~
local awful = require "awful"
local gfs = require "gears".filesystem.get_configuration_dir()

-- autostart
-- ~~~~~~~~~

-- startup apps runner
local function run(command, pidof)
    local findme = command
    local firstspace = command:find(' ')
    if firstspace then
        findme = command:sub(0, firstspace - 1)
    end

    awful.spawn.easy_async_with_shell(string.format('pgrep -u $USER -x %s > /dev/null || (%s)', pidof or findme, command))
end


local applications = {
    "nitrogen --restore",
    -- "xrandr --output DVI-D-0 --off --output HDMI-0 --off --output DP-0 --mode 1920x1080 --pos 0x0 --rotate left --output DP-1 --off --output DP-2 --primary --mode 3840x2160 --pos 1080x0 --rotate normal --output DP-3 --off --output DP-4 --mode 1920x1200 --pos 4920x0 --rotate normal --output DP-5 --off",
    "signal-desktop",
    -- "feh --no-fehbg --bg-fill ~/Immagini/Arch/Arch-abstract2.jpg --bg-fill ~/Immagini/Arch/Arch-abstract1.jpg",
    -- "picom --config $HOME/.config/awesome/misc/picom/panthom.conf &",
    -- "$HOME/.conky/conky-startup.sh",
    -- "solaar --window=hide",
    -- "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1",
}

for _, prc in ipairs(applications) do
    run(prc)
end
