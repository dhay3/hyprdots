local M = {}

function M.hyprexpo()
    hl.plugin.load("/home/cc/.config/hypr/hyprexpo.so")
    local colors = require("conf.appearance.colors")

    if hl.plugin.hyprexpo ~= nil then

        hl.config({
            plugin = {
                hyprexpo = {
                    dynamic_grid = 1,
                    -- columns = 2,
                    -- rows = 0,
                    skip_empty = 0,
                    fill_gaps = 0,
                    gaps_in = 5,
                    gaps_out = 5,
                    tile_rounding = 15,
                    border_width = 1,
                    label_enable = 1,
                    label_show = "hover+focus",
                    bg_col = "rgb(" .. colors.base .. ")",
                    border_color = "rgb(" .. colors.surface1 .. ")",
                    border_color_current = "rgb(" .. colors.mauve .. ")",
                    border_color_focus = "rgb(" .. colors.mauve .. ")",
                    border_color_hover = "rgba(" .. colors.lavender .. "8c)",
                    label_bg_color = "rgba(" .. colors.crust .. "e6)",
                    label_color_default = "rgb(" .. colors.text .. ")",
                    label_color_hover = "rgb(" .. colors.text .. ")",
                    label_color_focus = "rgb(" .. colors.lavender .. ")",
                    label_color_current = "rgb(" .. colors.mauve .. ")",
                    drag_drop_proxy_color = "rgba(" .. colors.mauve .. "24)",
                    drag_drop_proxy_active_color = "rgba(" .. colors.mauve .. "3d)"
                }
            }
        })
    end
end
return M
