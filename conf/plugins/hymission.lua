local M = {}

function M.hymission()
    local colors = require("conf.appearance.colors")

    if hl.plugin.hymission ~= nil then

        hl.config({
            plugin = {
                hymission = {
                    layout_engine = "expose",
                    vim_keys = 1,
                    niri_mode = 0,
                    workspace_strip_anchor = "left",
                    switch_release_key = "Super_L",
                    outer_padding_top = 92,
                    column_spacing = 5,
                    row_spacing = 5,
                    only_active_workspace = 0,
                    only_active_monitor = 0,
                    show_special = 0,
                    show_focus_indicator = 1,
                    backdrop_blur = 1,
                    focus_hover_thickness = 1,
                    focus_selected_thickness = 1,
                    backdrop_color = "rgba(" .. colors.base .. "cc)",
                    focus_hover_color = "rgba(" .. colors.lavender .. "8c)",
                    focus_selected_color = "rgba(" .. colors.mauve .. "f2)",
                    focus_title_color = "rgba(" .. colors.text .. "ff)",
                    workspace_strip_background_color = "rgba(" .. colors.crust .. "80)",
                    workspace_strip_inactive_color = "rgba(" .. colors.surface0 .. "8c)",
                    workspace_strip_active_color = "rgba(" .. colors.mauve .. "3d)",
                    workspace_strip_empty_color = "rgba(" .. colors.base .. "b3)",
                    workspace_strip_new_color = "rgba(" .. colors.surface1 .. "8c)",
                    workspace_strip_hover_tint_color = "rgba(" .. colors.lavender .. "18)",
                    workspace_strip_active_tint_color = "rgba(" .. colors.mauve .. "24)",
                    workspace_strip_plus_color = "rgba(" .. colors.mauve .. "f2)",
                    close_button_color = "rgba(" .. colors.crust .. "eb)",
                    close_button_hover_color = "rgba(" .. colors.surface1 .. "f2)",
                    close_button_glyph_color = "rgba(" .. colors.text .. "fa)"
                }
            }
        })
    end
end
return M
