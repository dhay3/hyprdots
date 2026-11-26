local colors = require("conf.appearance.colors")

-- ============================================================================
-- general
-- ============================================================================
hl.window_rule({
    name = "general-rules",
    match = {
        float = true
    },
    border_size = 1,
    border_color = "rgba(" .. colors.mauve .. "ff) rgba(" .. colors.mauve .. "ff)"
})

hl.window_rule({
    name = "gtk-portal",
    match = {
        initial_title = "(?i)^(open files?|select (a )?files?|choose (a )?files?|save (file )?as|save file|打开文件|选择文件|保存文件|另存为|開啟檔案|選擇檔案|儲存檔案|另存新檔)([.… ]*)$"
    },
    float = true
})

-- ============================================================================
-- noctalia
-- ============================================================================
hl.window_rule({
    name = "noctalia-settings",
    match = {
        class = "^dev\\.noctalia\\.Noctalia$|^org\\.pulseaudio\\.pavucontrol$"

    },
    float = true,
    size = {"1300", "800"}
})

-- ============================================================================
-- flameshot
-- ============================================================================
hl.window_rule({
    name = "flameshot-general",
    match = {
        class = "^flameshot$"
    },
    float = true,
    border_size = 0,
    no_blur = true,
    no_shadow = true,
    rounding = 0
})

hl.window_rule({
    name = "flameshot-configuration",
    match = {
        class = "^flameshot$",
        title = "^Configuration$"
    },
    border_size = 1,
    rounding = 20
})

hl.window_rule({
    name = "flameshot-capture",
    match = {
        class = "^flameshot$",
        title = "^flameshot$"
    },
    stay_focused = true,
    focus_on_activate = true,
    no_anim = true
})

hl.window_rule({
    name = "flameshot-pin",
    match = {
        class = "^flameshot$",
        title = "^flameshot-pin$"
    },
    pin = true
})

-- ============================================================================
-- browser
-- ============================================================================
hl.window_rule({
    name = "browser-pip",
    match = {
        class = "(?i)^(zen|zen-browser|firefox|firefox-esr|brave|brave-browser|google-chrome|google-chrome-stable|google-chrome-beta|google-chrome-unstable|chrome|org\\.mozilla\\.firefox|com\\.brave\\.Browser|com\\.google\\.Chrome|app\\.zen_browser\\.zen)$",
        title = "(?i)^(picture[ -]in[ -]picture|画中画|畫中畫)$"
    },
    border_size = 0,
    float = true,
    pin = true
})

-- ============================================================================
-- waydroid
-- ============================================================================
hl.window_rule({
    name = "waydroid",
    match = {
        class = "(?i)^waydroid.*"
    },
    float = true,
    no_blur = true,
    opaque = true,
    keep_aspect_ratio = false,
    pseudo = false,
    maximize = false,
    size = {571, 1019},
    center = true,
    suppress_event = "maximize fullscreen",
    no_shortcuts_inhibit = true
})

-- ============================================================================
-- freerdp
-- ============================================================================
hl.window_rule({
    name = "freerdp-general",
    match = {
        class = "^com\\.freerdp\\.client\\.sdl3$"
    },
    float = true,
    maximize = false
})

hl.window_rule({
    name = "freerdp-credentials",
    match = {
        class = "^com\\.freerdp\\.client\\.sdl3$",
        title = "^Credentials required.*$"
    },
    center = true
})

hl.window_rule({
    name = "freerdp",
    match = {
        class = "^com\\.freerdp\\.client\\.sdl3$",
        title = "^FreeRDP:.*$"
    },
    size = {"monitor_w - 4", "monitor_h - 38"},
    move = {2, 36}
})

