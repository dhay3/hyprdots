hl.config({
  input = {
      left_handed = false,
      sensitivity = 0.0,
      follow_mouse = 1,
      focus_on_close = 0,
      force_no_accel = false,
      kb_layout = "us",
      numlock_by_default = false,
      touchpad = {
          clickfinger_behavior = true,
          disable_while_typing = true,
          middle_button_emulation = false,
          tap_to_click = true,
          tap_and_drag = true,
          drag_3fg = 1,
          drag_lock = 1,
          natural_scroll = false,
      },
      touchdevice = {
          enabled = true,
      },
      virtualkeyboard = {
          release_pressed_on_close = true,
      },
      tablet = {

      },
      tablettool = {

      },
  },
  cursor = {
      invisible = false,
      enable_hyprcursor = true,
      hide_on_key_press = false,
      hide_on_tablet = false,
      hide_on_touch = false,
      inactive_timeout = 20,
      no_hardware_cursors = 1,
      persistent_warps = false,
      warp_back_after_non_mouse_input = false,
      warp_on_change_workspace = 0,
    --   warp_on_monitor_change = 0,
      warp_on_toggle_special = 0,
    },

})
