require("conf.appearance")
require("conf.rules")
require("conf.plugins")
require("conf.gestures")
require("conf.autostart")
require("conf.environment")
require("conf.input")
require("conf.keybindings")
require("conf.layouts")
require("conf.misc")
require("conf.monitors")

-- For Noctalia Color templates
require("noctalia").apply_theme()


-- overwrite
hl.config({
    general = {
        layout = "dwindle"
    },
    dwindle = {
        smart_split = false
    },
    xwayland = {
        force_zero_scaling = true
      },
    misc = {
        font_family = "Hack Nerd Font",
        splash_font_family = "Hack Nerd Font"
    }
})
