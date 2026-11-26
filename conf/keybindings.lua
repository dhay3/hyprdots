-- ============================================================================
-- Variables
-- ============================================================================
local workspaceRules = require("conf.rules.workspace")

local mainMod = "SUPER"
-- local mainMod = "SUPER_L"

local sessionWorkspaceRules = {}
local initialWindowSizes = {}

-- ============================================================================
-- Functions
-- ============================================================================
local function getDefaultWorkspaceLimit()
    local limit = workspaceRules.minimum
    for _, monitor in ipairs(hl.get_monitors()) do
        if not monitor.is_mirror then
            limit = math.max(limit, (monitor.id + 1) * workspaceRules.minimum)
        end
    end
    return limit
end

local function keepSessionWorkspace(id, monitor)
    sessionWorkspaceRules[id] = hl.workspace_rule({
        workspace = tostring(id),
        monitor = monitor.name,
        persistent = true
    })
end

local function rememberWindowSize()
    local window = hl.get_active_window()
    if window and window.floating and not initialWindowSizes[window.stable_id] then
        initialWindowSizes[window.stable_id] = {
            x = window.size.x,
            y = window.size.y
        }
    end
    return window
end

local function cycleLayout()
    local layouts = {"dwindle", "master", "scrolling"}
    local current = hl.get_config("general:layout")
    local nextLayout = layouts[1]
    for i, layout in ipairs(layouts) do
        if layout == current then
            nextLayout = layouts[i % #layouts + 1]
            break
        end
    end
    hl.config({
        general = {
            layout = nextLayout
        }
    })
end

local function toggleWindowOnMagicWorkspace()
    local window = hl.get_active_window()
    if not window or not window.workspace or not window.monitor then
        return
    end

    local target = "special:magic"
    if window.workspace.name == target then
        local workspace = window.monitor.active_workspace
        if not workspace then
            return
        end
        target = workspace.name
    end

    hl.dispatch(hl.dsp.window.move({
        window = window,
        workspace = target,
        follow = true
    }))
end

local function toggleMinimizedWindow()
    if hl.get_workspace("special:minimized") then
        hl.dispatch(hl.dsp.window.move({
            workspace = hl.get_active_workspace(),
            window = "tag:minimized"
        }))
        hl.dispatch(hl.dsp.window.clear_tags({
            window = "tag:minimized"
        }))
    else
        hl.dispatch(hl.dsp.window.tag({
            tag = "minimized",
            window = hl.get_active_window()
        }))
        hl.dispatch(hl.dsp.window.move({
            workspace = "special:minimized",
            follow = false
        }))
    end
end

local function addSessionWorkspace()
    local monitor = hl.get_active_monitor()
    if not monitor then
        return
    end

    local nextWorkspace = getDefaultWorkspaceLimit() + 1
    for _, workspace in ipairs(hl.get_workspaces()) do
        nextWorkspace = math.max(nextWorkspace, workspace.id + 1)
    end
    keepSessionWorkspace(nextWorkspace, monitor)
    hl.dispatch(hl.dsp.focus({
        workspace = tostring(nextWorkspace),
        on_current_monitor = true
    }))
end

local function removeCurrentWorkspace()
    local current = hl.get_active_workspace()
    if hl.get_active_special_workspace() or not current or current.id <= 0 or not current.monitor then
        return
    end

    local currentId = current.id
    local monitor = current.monitor
    local remaining = 0
    local previous, nextWorkspace
    for _, workspace in ipairs(hl.get_workspaces()) do
        if workspace.id > 0 and workspace.id ~= currentId and workspace.monitor and workspace.monitor.id == monitor.id then
            remaining = remaining + 1
            if workspace.id < currentId then
                if not previous or workspace.id > previous.id then
                    previous = workspace
                end
            elseif not nextWorkspace or workspace.id < nextWorkspace.id then
                nextWorkspace = workspace
            end
        end
    end
    if remaining < workspaceRules.minimum then
        return
    end

    local destination = tostring((previous or nextWorkspace).id)
    local selector = tostring(currentId)
    for _, window in ipairs(hl.get_workspace_windows(selector)) do
        hl.dispatch(hl.dsp.window.move({
            window = window,
            workspace = destination,
            follow = false
        }))
    end
    if #hl.get_workspace_windows(selector) > 0 then
        return
    end

    hl.dispatch(hl.dsp.focus({
        workspace = destination
    }))
    local active = monitor.active_workspace
    if not active or active.id == currentId then
        return
    end

    local rule = sessionWorkspaceRules[currentId] or workspaceRules.get_default_rule(monitor, currentId)
    if rule then
        rule:set_enabled(false)
    end
    sessionWorkspaceRules[currentId] = nil
end

local function toggleWorkspaceOverview()
    hl.plugin.hyprexpo.expo("toggle")
end

local function toggleCurrentWorkspaceWindowsOverview()
    hl.plugin.hymission.toggle("onlycurrentworkspace")
end

local function toggleAllWorkspacesWindowsOverview()
    hl.plugin.hymission.toggle("forceall")
end

local function toggleWindowMaximized()
    local window = hl.get_active_window()
    if not window or window.class:lower():match("^waydroid") then
        return
    end
    hl.dispatch(hl.dsp.window.fullscreen({
        window = window,
        mode = "maximized",
        action = "toggle"
    }))
end

local function toggleWindowFullscreen()
    local window = hl.get_active_window()
    if not window or window.class:lower():match("^waydroid") then
        return
    end
    hl.dispatch(hl.dsp.window.fullscreen({
        window = window,
        mode = "fullscreen",
        action = "toggle"
    }))
end

local function increaseLayoutRatio()
    local window = rememberWindowSize()
    if not window then
        return
    end
    if not window.floating then
        local layout = window.layout and window.layout.name
        if layout == "dwindle" then
            hl.dispatch(hl.dsp.layout("splitratio +0.05"))
            return
        elseif layout == "scrolling" then
            hl.dispatch(hl.dsp.layout("colresize +0.05"))
            return
        elseif layout == "master" then
            hl.dispatch(hl.dsp.layout("mfact +0.05"))
            return
        end
    end
    hl.dispatch(hl.dsp.window.resize({
        window = window,
        x = 20,
        y = 20,
        relative = true
    }))
end

local function decreaseLayoutRatio()
    local window = rememberWindowSize()
    if not window then
        return
    end
    if not window.floating then
        local layout = window.layout and window.layout.name
        if layout == "dwindle" then
            hl.dispatch(hl.dsp.layout("splitratio -0.05"))
            return
        elseif layout == "scrolling" then
            hl.dispatch(hl.dsp.layout("colresize -0.05"))
            return
        elseif layout == "master" then
            hl.dispatch(hl.dsp.layout("mfact -0.05"))
            return
        end
    end
    hl.dispatch(hl.dsp.window.resize({
        window = window,
        x = -20,
        y = -20,
        relative = true
    }))
end

local function resetLayoutRatio()
    local window = hl.get_active_window()
    if not window then
        return
    end
    if window.floating then
        local size = initialWindowSizes[window.stable_id]
        if size then
            hl.dispatch(hl.dsp.window.resize({
                window = window,
                x = size.x,
                y = size.y,
                relative = false
            }))
        end
        return
    end
    local layout = window.layout and window.layout.name
    if layout == "dwindle" then
        hl.dispatch(hl.dsp.layout("splitratio 1 exact"))
    elseif layout == "scrolling" then
        hl.dispatch(hl.dsp.layout("colresize " .. hl.get_config("scrolling:column_width")))
    elseif layout == "master" then
        hl.dispatch(hl.dsp.layout("mfact exact " .. hl.get_config("master:mfact")))
    end
end

-- ============================================================================
-- States
-- ============================================================================
local defaultWorkspaceLimit = getDefaultWorkspaceLimit()
for _, workspace in ipairs(hl.get_workspaces()) do
    if workspace.id > defaultWorkspaceLimit and workspace.monitor then
        keepSessionWorkspace(workspace.id, workspace.monitor)
    end
end

-- ============================================================================
-- General
-- ============================================================================
hl.bind(mainMod .. " + U", hl.dsp.exec_cmd("noctalia msg panel-toggle kenn/keybind-cheatsheet:cheatsheet"), {
    dont_inhibit = true,
    description = 'Toggle the keybinding cheatsheet'
})

hl.bind(mainMod .. " + O", hl.dsp.exec_cmd("noctalia msg panel-toggle launcher"), {
    dont_inhibit = true,
    description = 'Toggle the launcher'
})

hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("noctalia msg panel-toggle control-center notifications"), {
    dont_inhibit = true,
    description = 'Toggle the notifications'
})

hl.bind(mainMod .. " + SLASH", hl.dsp.exec_cmd("noctalia msg panel-open launcher /tr"), {
    dont_inhibit = true,
    description = "Open the translator"
})

hl.bind(mainMod .. "+ DELETE", hl.dsp.exec_cmd("noctalia msg session lock"), {
    dont_inhibit = true,
    description = 'Lock the session'
})

hl.bind(mainMod .. " + SHIFT + M", cycleLayout, {
    description = "Cycle layout: dwindle / master / scrolling"
})

hl.bind("F1", hl.dsp.exec_cmd("flameshot gui"), {
    -- dont_inhibit = true,
    description = 'Take a screenshot'
})

-- hl.bind("F1", function()
--     hl.plugin.hyprcapture.open_editor("region")
-- end)

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("noctalia msg brightness-up eDP-2 5%"), {
    repeating = true,
    dont_inhibit = true,
    description = "Increase internal display brightness"
})

hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("noctalia msg brightness-down eDP-2 5%"), {
    repeating = true,
    dont_inhibit = true,
    description = "Decrease internal display brightness"
})

hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("noctalia msg volume-down 5%"), {
    repeating = true,
    dont_inhibit = true,
    description = "Decrease output volume"
})

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("noctalia msg volume-up 5%"), {
    repeating = true,
    dont_inhibit = true,
    description = "Increase output volume"
})

-- ============================================================================
-- Programs
-- ============================================================================
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("kitty"), {
    description = 'Open the terminal, default: kitty'
})

hl.bind(mainMod .. " + Y", hl.dsp.exec_cmd("exec kitty -e yazi || nautilus"), {
    description = 'Open the file manager, default: yazi'
})

hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("exec kitty -e nvim || code"), {
    description = 'Open the editor, default: nvim'
})

hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("exec kitty -e btop || resource"), {
    description = 'Open the monitor, default: btop'
})

hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("zen-browser"), {
    description = 'Open the browser, default: zen-browser'
})

hl.bind(mainMod .. " + I", hl.dsp.exec_cmd("chatgpt --ozone-platform=wayland"), {
    description = 'Open ChatGPT'
})

-- ============================================================================
-- Monitors
-- ============================================================================
hl.bind(mainMod .. "+ SHIFT + page_up", hl.dsp.focus({
    monitor = "-1"
}), {
    dont_inhibit = true,
    description = 'Go to the previous monitor'
})

hl.bind(mainMod .. "+ SHIFT + page_down", hl.dsp.focus({
    monitor = "+1"
}), {
    dont_inhibit = true,
    description = 'Go to the next monitor'
})

hl.bind(mainMod .. "+ page_up", hl.dsp.window.move({
    monitor = "-1",
    follow = true
}), {
    dont_inhibit = true,
    description = "Move the window to the previous monitor"
})

hl.bind(mainMod .. "+ page_down", hl.dsp.window.move({
    monitor = "+1",
    follow = true
}), {
    dont_inhibit = true,
    description = "Move the window to the next monitor"
})

-- ============================================================================
-- Workspaces
-- ============================================================================
for id = 1, 9 do
    hl.bind(mainMod .. " + " .. id, hl.dsp.focus({
        workspace = tostring(id)
    }), {
        dont_inhibit = true,
        description = "Go to workspace " .. id
    })
end

hl.bind(mainMod .. " + up", hl.dsp.focus({
    workspace = "m-1"
}), {
    dont_inhibit = true,
    description = 'Go to the previous workspace'
})

hl.bind(mainMod .. " + down", hl.dsp.focus({
    workspace = "m+1"
}), {
    dont_inhibit = true,
    description = 'Go to the next workspace'
})

hl.bind("XF86Tools", hl.dsp.focus({
    workspace = "m-1"
}), {
    dont_inhibit = true,
    description = "Go to the previous workspace (mouse)"
})

hl.bind("XF86Launch5", hl.dsp.focus({
    workspace = "m+1"
}), {
    dont_inhibit = true,
    description = "Go to the next workspace (mouse)"
})

hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({
    workspace = "m-1"
}), {
    dont_inhibit = true,
    description = 'Go to the previous workspace'
})

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({
    workspace = "m+1"
}), {
    dont_inhibit = true,
    description = 'Go to the next workspace'
})

hl.bind(mainMod .. " + left", hl.dsp.window.move({
    workspace = "m-1",
    follow = true
}), {
    dont_inhibit = true,
    description = "Move the window to the previous workspace"
})

hl.bind(mainMod .. " + right", hl.dsp.window.move({
    workspace = "m+1",
    follow = true
}), {
    dont_inhibit = true,
    description = "Move the window to the next workspace"
})

hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"), {
    dont_inhibit = true,
    description = "Toggle the magic workspace"
})

hl.bind(mainMod .. " + SHIFT + S", toggleWindowOnMagicWorkspace, {
    dont_inhibit = true,
    description = "Toggle the window to the magic workspace"
})

hl.bind(mainMod .. " + M", toggleMinimizedWindow, {
    description = "Toggle the window to minimized workspace"
})

hl.bind(mainMod .. " + D", addSessionWorkspace, {
    -- dont_inhibit = true,
    description = "Add a workspace"
})

hl.bind(mainMod .. " + SHIFT + D", removeCurrentWorkspace, {
    description = "Remove the current workspace"
})

hl.bind(mainMod .. " + G", toggleWorkspaceOverview, {
    dont_inhibit = true,
    description = "Toggle workspace overview"
})

hl.bind("XF86Launch6", toggleWorkspaceOverview, {
    dont_inhibit = true,
    description = "Toggle workspace overview (mouse)"
})

hl.bind(mainMod .. " + C", toggleCurrentWorkspaceWindowsOverview, {
    dont_inhibit = true,
    description = "Toggle the current workspace's windows overview"
})

hl.bind(mainMod .. " + A", toggleAllWorkspacesWindowsOverview, {
    dont_inhibit = true,
    description = "Toggle all workspaces' windows overview"
})

hl.bind("XF86Launch7", toggleAllWorkspacesWindowsOverview, {
    dont_inhibit = true,
    description = "Toggle all workspaces' windows overview (mouse)"
})

-- hl.bind(mainMod .. " + G", function()
--     hl.plugin.scrolloverview.overview("toggle all")
-- end)

-- ============================================================================
-- Windows
-- ============================================================================
for k, v in pairs({
    K = "up",
    J = "down",
    L = "right",
    H = "left"
}) do
    hl.bind(mainMod .. " + SHIFT + " .. k, hl.dsp.focus({
        direction = v
    }), {
        dont_inhibit = true,
        description = "Go to the " .. v .. " window"
    })
    hl.bind(mainMod .. " + " .. k, hl.dsp.window.move({
        direction = v
    }), {
        dont_inhibit = true,
        description = "Move the window to the" .. v
    })
end

hl.bind("ALT + Tab", hl.dsp.window.cycle_next({
    next = true
}), {
    description = 'Cycle to the next window'
})

hl.bind("ALT + SHIFT + Tab", hl.dsp.window.cycle_next({
    next = false
}), {
    description = 'Cycle to the previous window'
})

-- hl.bind(mainMod .. " + Tab", hl.dsp.exec_cmd("noctalia msg window-switcher hold"), {
--     description = "Noctalia window switcher"
-- })

hl.bind(mainMod .. " + Q", hl.dsp.window.close(), {
    -- dont_inhibit = true,
    description = "Close the window"
})

hl.bind(mainMod .. " + F", hl.dsp.window.float({
    action = "toggle"
}), {
    dont_inhibit = true,
    description = "Toggle the floating of the window"
})

hl.bind(mainMod .. " + P", hl.dsp.window.pin(), {
    dont_inhibit = true,
    description = "Toggle the pinning of the window"
})

hl.bind(mainMod .. " + V", hl.dsp.layout("togglesplit"), {
    dont_inhibit = true,
    description = "Toggle split"
})

hl.bind(mainMod .. " + Z", toggleWindowMaximized, {
    dont_inhibit = true,
    description = "Toggle the window to maximized"
})

hl.bind(mainMod .. " + SHIFT + Z", toggleWindowFullscreen, {
    dont_inhibit = true,
    description = "Toggle the window to fullscreen"
})

hl.bind(mainMod .. " + EQUAL", increaseLayoutRatio, {
    repeating = true,
    dont_inhibit = true,
    description = "Increase layout ratio"
})

hl.bind(mainMod .. " + MINUS", decreaseLayoutRatio, {
    repeating = true,
    dont_inhibit = true,
    description = "Decrease layout ratio"
})

hl.bind(mainMod .. " + 0", resetLayoutRatio, {
    dont_inhibit = true,
    description = "Reset layout ratio"
})

-- ============================================================================
-- Mouse
-- ============================================================================
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), {
    mouse = true,
    description = "Drag the window with the mouse"
})

hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), {
    description = "Resize the window with the mouse"
})
