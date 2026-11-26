local colors = require("conf.appearance.colors")

hl.config({
    general = {
        border_size = 1,
        float_gaps = 1,
        gaps_in = 1,
        gaps_out = 2,
        col = {
            active_border = {
                colors = {"rgba(" .. colors.mauve .. "ff)", "rgba(" .. colors.lavender .. "ff)"},
                angle = 45
            },
            inactive_border = "rgba(" .. colors.surface1 .. "aa)",
        },
        allow_tearing = false,
        no_focus_fallback = true,
        resize_on_border = true,
        extend_border_grab_area = 15,
        hover_icon_on_border = true,
        resize_corner = 0,
        snap = {
            enabled = true,
            window_gap = 10,
            monitor_gap = 10,
            border_overlap = false,
            respect_gaps = false
        }
    },
    decoration = {
        rounding = 20,
        rounding_power = 2.0,
        active_opacity = 1.0,
        inactive_opacity = 1.0,
        fullscreen_opacity = 1.0,
        dim_inactive = false,
        dim_strength = 0.5,
        dim_special = 0.2,
        dim_around = 0.4,
        shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            color = "rgba(" .. colors.crust .. "ee)"
        },
        blur = {
            enabled = true,
            size = 3,
            passes = 2,
            vibrancy = 0.1696
        },
        glow = {
            enabled = false
        },
        motion_blur = {
            enabled = false
        }
        -- wobble = {
        --     enabled = false
        -- }
    },
    misc = {
        background_color = "rgb(" .. colors.base .. ")",
    }
})

