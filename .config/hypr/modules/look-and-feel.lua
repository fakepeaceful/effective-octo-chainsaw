-----------------------
---- LOOK AND FEEL ----
-----------------------
local colors = require("modules.colors")

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
    general = {
        gaps_in  = 2,
        gaps_out = 4,

        border_size = 3,

        col = {
            active_border   = colors.primary,
            inactive_border = colors.secondary_outlilne,
        },

        -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = false,

        -- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
        allow_tearing = false,

    },

    decoration = {
        rounding       = 20,
        rounding_power = 0,

        -- Change transparency of focused and unfocused windows
        active_opacity   = 1.0,
        inactive_opacity = 0.8,

        shadow = {
            enabled      = false,
            range        = 15,
            render_power = 4,
            color        = 0xee0a0a0a,
        },

        blur = {
            enabled   = true,
            xray =  false,
            special = false,
            ignore_opacity = true, 
            new_optimizations = true,
            popups = true,
            input_methods = true, 
            size      = 8,
            passes    = 2,
            vibrancy  = 0.1696,
        },
    },
})

