-- Hyprland config for rocinante, Lua format (Hyprland 0.55+).
-- The hex values here are the CLASSIC palette and act as substitution keys:
-- modules/home-manager/desktop/hyprland/default.nix rewrites them for the
-- variant selected by the rocinante.palette option (theme/palette.nix).
-- Converted from the hyprlang hyprland.conf on 2026-11-08: 0.56 warns that the
-- legacy format is outdated and 0.57 drops it entirely, so there is no
-- automatic migration path for a hand-written .conf.
-- Same layout, gaps, palette and binds as before; only the syntax changed.
-- Wiki: https://wiki.hypr.land/Configuring/Start/


-- Monitor layout is handled by kanshi (services.kanshi). Uncomment for a fixed layout:
-- hl.monitor({ output = "HDMI-A-1", mode = "preferred", position = "auto", scale = "auto" })

-- waybar is started by its systemd user unit (services.waybar), not from here.
-- hl.on("hyprland.start", function() hl.exec_cmd("waybar") end)


-- Some default env vars (home.pointerCursor / home.sessionVariables already set these).
-- hl.env("XCURSOR_SIZE", "24")
-- HYPRCURSOR_THEME was rose-pine, which fights the Bibata-Modern-Ice cursor
-- set through home.pointerCursor; left unset Hyprland follows XCURSOR_THEME.
-- hl.env("HYPRCURSOR_THEME", "rose-pine-hyprcursor")

hl.config({
    input = {
        kb_layout = "gb",
        kb_variant = "mac",
        kb_model = "mac_intl",
        kb_options = "",
        kb_rules = "",

        follow_mouse = 1,

        -- touchpad = { natural_scroll = false },

        sensitivity = -1.0, -- -1.0 - 1.0, 0 means no modification.
    },
})

hl.config({
    general = {
        -- Console plate spacing: wider outer gutters, tight inner gaps
        gaps_in = 6,
        gaps_out = 10,
        border_size = 3,

        -- Rocinante / MCRN tactical display palette, shared with
        --   modules/home-manager/services/hyprlock/default.nix
        --   modules/home-manager/services/waybar/style.css
        --   ~/.pi/agent/themes/rocinante.json
        -- Hard cyan frame on the focused console, dim hologram when not.
        col = {
            active_border = "rgba(2de2e6ee)",
            inactive_border = "rgba(1a8a8f55)",
        },

        layout = "dwindle",

        -- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
        allow_tearing = false,
    },
})

hl.config({
    decoration = {
        -- Hard-edged plates: the Roci's consoles have no rounded corners
        rounding = 0,

        blur = {
            enabled = true,
            size = 6,
            passes = 2,
            noise = 0.01,
            xray = true, -- blur what is behind the window, not the window itself
        },

        -- Background consoles read as dimmed secondary screens
        dim_inactive = true,
        dim_strength = 0.30,
    },
})

hl.config({
    animations = {
        enabled = true,
    },
})

hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 7, bezier = "myBezier" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 7, bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "default" })

hl.config({
    dwindle = {
        -- You probably want this. The pseudotile master switch was removed in
        -- Hyprland 0.5x; the pseudo dispatcher (mainMod + P) still works.
        preserve_split = true,
    },
})

-- hl.config({
--     master = {
--         new_status = "master",
--     },
-- })

-- hl.config({
--     gestures = {
--         workspace_swipe = false,
--     },
-- })

hl.config({
    misc = {
        force_default_wallpaper = 0, -- Set to 0 to disable the anime mascot wallpapers
    },
})

-- Example per-device config
-- hl.device({ name = "epic-mouse-v1", sensitivity = -0.5 })

-- Example window rules
-- hl.window_rule({ name = "float-kitty", match = { class = "^kitty$" }, float = true })

local mainMod = "SUPER"

hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("alacritty"))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("wlogout"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("dolphin"))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("rofi -show drun"))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo()) -- dwindle
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit")) -- dwindle
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd("firefox"))
hl.bind(mainMod .. " + CONTROL + ALT + SHIFT + R", hl.dsp.exec_cmd("~/.local/bin/screenshot.sh")) -- screenshot

-- Set volume through volume keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9], move window with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Lid switch binds dropped: `hyprctl devices` on rocinante reports no switch
-- devices, and the closed-lid line called `dispatch exec hyprlock`, which was
-- never a valid dispatcher. Add them back on a laptop with:
-- hl.bind("switch:off:Lid Switch", hl.dsp.dpms({ action = "off" }), { locked = true })
-- hl.bind("switch:on:Lid Switch", hl.dsp.dpms({ action = "on" }), { locked = true })

-- Layer rules for rofi blur
-- hl.layer_rule({ name = "rofi-blur", match = { namespace = "^rofi$" }, blur = true, ignorezero = true, dimaround = true })
