hl.on("hyprland.start", function()
    hl.exec_cmd("hyprpm reload")
    hl.exec_cmd("noctalia")
    hl.exec_cmd("fcitx5 --replace -d")
    hl.exec_cmd("kitten panel --edge=background --focus-policy=on-demand --margin-top 40 zsh -c 'fastfetch;exec zsh'")
end)

hl.on("hyprland.start", function()

    local applications = {
        "flameshot",
        "betterbird",
    }
    for _, app in ipairs(applications) do
        hl.exec_cmd(app)
    end
end)
