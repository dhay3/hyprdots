-- cursor
hl.env("HYPRCURSOR_SIZE", "22")
hl.env("HYPRCURSOR_THEME", "HyprBibata-Modern-Classic")
hl.env("XCURSOR_THEME", "Bibata-Modern-Classic")
hl.env("XCURSOR_SIZE", "22")

-- IM
hl.env("XMODIFIERS", "@im=fcitx")
hl.env("QT_IM_MODULE", "fcitx")
hl.env("QT_IM_MODULES", "wayland;fcitx;ibus")

-- GPU
hl.env("GBM_BACKEND", "nvidia-drm")
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")

-- X11
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

-- QT
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION","1")
hl.env("QT_QPA_PLATFORMTHEME", "kde;gtk3")
hl.env("QT_STYLE_OVERRIDE", "kvantum")

-- GTK
-- hl.env("GTK_THEME", "yourVeryPrettyTheme")
hl.env("GDK_BACKEND", "wayland,x11,*")

-- SDL
hl.env("SDL_VIDEODRIVER", "wayland")

-- clutter
hl.env("CLUTTER_BACKEND", "wayland")