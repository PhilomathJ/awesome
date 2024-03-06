-- requirements
-- ~~~~~~~~~~~~
-- local capi = {
--     screen = screen,
--     mouse = mouse,
--     client = client
-- }
local awful = require "awful"
local capi = Capi

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
    -- "nitrogen --restore", -- wallpaper
    "touchegg", -- Trackpad gestures,
    -- "signal-desktop",
    -- "/opt/brave-bin/brave --profile-directory=Default --app-id=hpfldicfbfomlpcikngkocigghgafkph", -- Google Messages PWA
    -- "/usr/bin/Discord",
    -- "/opt/brave-bin/brave --profile-directory=Default --app-id=agimnkijcaahngcdmfeangaknmldooml" -- YouTube PWA
    -- "feh --no-fehbg --bg-fill ~/Immagini/Arch/Arch-abstract2.jpg --bg-fill ~/Immagini/Arch/Arch-abstract1.jpg",
    -- "picom --config $HOME/.config/awesome/misc/picom/panthom.conf &",
    -- "$HOME/.conky/conky-startup.sh",
    -- "solaar --window=hide",
    -- "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1",
}

for _, prc in ipairs(applications) do
    run(prc)
end
-------------------------------------------------------------------------
-- only-one-time applications
local function run_once(command)
    local is_running = false   -- flag is an instance is already running

    for _, c in ipairs(capi.client.get()) do
        if c.instance == "crx_hpfldicfbfomlpcikngkocigghgafkph" then
            is_running = true
        end
    end

    if is_running then return end -- TODO: apply focus

    awful.spawn.easy_async_with_shell(command)
end

local one_time_applications = {
    -- "dex $HOME/.local/share/brave-hpfldicfbfomlpcikngkocigghgafkph.desktop",
    -- "/opt/brave-bin/brave --profile-directory=Default --app-id=agimnkijcaahngcdmfeangaknmldooml" -- YouTube PWA
    "/opt/brave-bin/brave  --profile-directory=Default --app-id=hpfldicfbfomlpcikngkocigghgafkph" -- Google Messages
}

-- for _, prc in ipairs(one_time_applications) do
--     run_once(prc)
-- end

-- awful.spawn.with_shell("~/.config/awesome/scripts/autorun.sh")