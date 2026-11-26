local workspaces_per_monitor = 4
local monitor_rules = {}

local function add_monitor(monitor)
    if monitor.is_mirror then
        return
    end

    local rules = monitor_rules[monitor.name]
    if rules then
        for _, rule in ipairs(rules) do
            rule:set_enabled(true)
        end
        return
    end

    rules = {}
    for i = 1, workspaces_per_monitor do
        rules[i] = hl.workspace_rule({
            workspace = tostring(monitor.id * workspaces_per_monitor + i),
            monitor = monitor.name,
            persistent = true,
            default = i == 1,
        })
    end
    monitor_rules[monitor.name] = rules
end

local function add_connected_monitors()
    for _, monitor in ipairs(hl.get_monitors()) do
        add_monitor(monitor)
    end
end

hl.on("monitor.added", add_monitor)
hl.on("monitor.removed", function(monitor)
    for _, rule in ipairs(monitor_rules[monitor.name] or {}) do
        rule:set_enabled(false)
    end
    monitor_rules[monitor.name] = nil
end)
hl.on("hyprland.start", add_connected_monitors)
hl.on("config.reloaded", add_connected_monitors)
add_connected_monitors()

return {
    minimum = workspaces_per_monitor,
    get_default_rule = function(monitor, id)
        local rules = monitor_rules[monitor.name]
        local index = id - monitor.id * workspaces_per_monitor
        return rules and rules[index]
    end
}
