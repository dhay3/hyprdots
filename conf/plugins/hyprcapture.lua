local M = {}

function M.hyprcapture()
    if not hl.plugin.hyprcapture then return end

    hl.config({
        plugin = {
            hyprcapture = {
                default_mode = "region",
                include_cursor = false,
                save = false,
                clipboard = true,
                show_thumbnail = true,
                remember_settings = false,
                filename_template = "Screenshot-%Y-%m-%d-%H%M%S.png",
            },
        },
    })
end

return M
