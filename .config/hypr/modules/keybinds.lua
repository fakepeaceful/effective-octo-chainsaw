----------------
----KEYBINDS----
----------------



local mainMod = "SUPER" -- Sets Windows key as the main modifier
local closeWindowBind = hl.bind(mainMod .. " + W", hl.dsp.window.close()) -- command to close windows

-- Execution of programs
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd("kitty"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("kitty yazi"))
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("fuzzel"))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("hyprlock"))

-- Moving focus using vim key
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left"}))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down"}))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up"}))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right"}))

-- Altering windows
hl.bind(mainMod .." + F", hl.dsp.window.fullscreen({ fullscreen, action = "toggle"})) --Toggles fullscreen window
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" })) --Toggles floating window

-- Switching between workspaces and moving active windows to a workspace
for i = 1, 10 do
	local key = i % 10 -- makes 10 the 0 key
	hl.bind(mainMod .. " + " .. key,			hl.dsp.focus({ workspace = i}))
	hl.bind(mainMod .. " + SHIFT + " .. key, 		hl.dsp.window.move({ workspace = i}))
end

-- Moving and resizing windows with mouse keys
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),	{ mouse = true})
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(),	{ mouse = true})

-- Exiting hyprland
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("command -v hyprs:hutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))


-- F keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"), { repeating = true, locked = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { repeating = true, locked = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set 5%+"), { repeating = true, locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { repeating = true, locked = true })

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl --player=%any next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl --player=%any previous"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl --player=%any play-pause"), { locked = true })

--hl.bind("XF86LaunchA", hl.dsp.exec_cmd("kitty --class impala -e impala", { float = true, size = "1000 1000" }))
--hl.bind("XF86LaunchA", hl.dsp.exec_cmd("kitty --hold -e fastfetch", { float = true, size = "1200 1200" }), { long_press = true })



--hl.bind("XF86LaunchA", hl.dsp.exec_cmd("kitty --class impala -e impala", { float = true, size = "1000 1000" }), { release = true })
--hl.bind("XF86Search", hl.dsp.exec_cmd("kitty --class bluetui -e bluetui", { float = true, size = "1000 1000" }))
--hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("kitty --class wiremix -e wiremix", { float = true, size = "1000 1000" }))
--hl.bind("XF86LaunchA", hl.dsp.exec_cmd("kitty --hold -e fastfetch", { float = true, size = "1200 1200" }), { long_press = true })


local launchA_long_press = false

-- Impala/Fastfeth
-- 1. Long Press Bind (fires immediately when the threshold is hit)
hl.bind("XF86LaunchA", function()
    launchA_long_press = true
    hl.dispatch(hl.dsp.exec_cmd("kitty --hold -e fastfetch", { float = true, size = "1050 600" }))
end, { long_press = true })

-- 2. Short Press Bind (fires on key release ONLY if long press didn't happen)
hl.bind("XF86LaunchA", function()
    if not launchA_long_press then
        hl.dispatch(hl.dsp.exec_cmd("kitty --class impala -e impala", { float = true, size = "1000 1000" }))
    end
    -- Reset the flag for the next keypress
    launchA_long_press = false
end, { release = true })


-- Micmute/Wiremix
local mic_long_press = false

-- 1. Long Press Bind (Fires immediately when held and launches wiremix inside Kitty)
hl.bind("XF86AudioMicMute", function()
    mic_long_press = true
    -- Wraps wiremix inside a floating Kitty window matching your setup sizing
    hl.dispatch(hl.dsp.exec_cmd("kitty --class wiremix -e wiremix", { float = true, size = "1000 1000" }))
end, { long_press = true })

-- 2. Short Press Bind (Fires on key release ONLY if long press didn't happen)
hl.bind("XF86AudioMicMute", function()
    if not mic_long_press then
        hl.dispatch(hl.dsp.exec_cmd([[
            wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
            if wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -q "\[MUTED\]"; then
                notify-send -h string:x-canonical-private-synchronous:sys-notify "Microphone" "Muted" -i microphone-sensitivity-muted-symbolic -t 1500
            else
                notify-send -h string:x-canonical-private-synchronous:sys-notify "Microphone" "Unmuted" -i microphone-sensitivity-high-symbolic -t 1500
            fi
        ]]))
    end
    -- Reset the tracking flag cleanly
    mic_long_press = false
end, { release = true })

--Bluetui/BTOP

local search_long_press = false

-- 1. Long Press Bind: Launches btop inside a floating Kitty window
hl.bind("XF86Search", function()
    search_long_press = true
    hl.dispatch(hl.dsp.exec_cmd("kitty --class btop -e btop", { float = true, size = "1750 1250" }))
end, { long_press = true })

-- 2. Short Press Bind (Release): Launches bluetui ONLY if long press didn't happen
hl.bind("XF86Search", function()
    if not search_long_press then
        hl.dispatch(hl.dsp.exec_cmd("kitty --class bluetui -e bluetui", { float = true, size = "1000 1000" }))
    end
    -- Reset the tracking flag cleanly
    search_long_press = false
end, { release = true })

--Suspend + Hyprlock
hl.bind("XF86PowerOff", hl.dsp.exec_cmd("hyprlock & systemctl suspend"))

-- Tap once to lock. Tap twice quickly to lock and suspend.
hl.bind("XF86Sleep", hl.dsp.exec_cmd([[
    # File to track if the key was tapped recently
    TAP_FILE="/tmp/sleep_button_tapped"

    if [ -f "$TAP_FILE" ]; then
        # SECOND TAP: Trigger lock and deep sleep immediately
        rm -f "$TAP_FILE"
        hyprlock & systemctl suspend
    else
        # FIRST TAP: Create a quick marker
        touch "$TAP_FILE"
        
        # Wait 300 milliseconds (0.3 seconds) to see if a second tap happens
        sleep 0.3
        
        # If the file still exists, a second tap didn't happen -> just lock the screen
        if [ -f "$TAP_FILE" ]; then
            rm -f "$TAP_FILE"
            hyprlock
        fi
    fi
]]))

-- Targets the physical MacBook lid closing event via Apple's SMC hardware name
hl.bind("switch:on:Apple SMC power/lid events", function()
    -- Universally launches hyprlock first, pauses for 0.3 seconds to let 
    -- the screen lock finish rendering, then triggers a safe suspend state.
    hl.dispatch(hl.dsp.exec_cmd("hyprlock & sleep 0.3 && systemctl suspend"))
end, { locked = true })

