hl.config({
    animations = {
        enabled = true
    }
})
hl.curve("amethyst", {
    type = "bezier",
    points = {{0.16, 1.0}, {0.3, 1.0}}
})
hl.animation({
    leaf = "windows",
    enabled = true,
    speed = 3.5,
    bezier = "amethyst"
})
hl.animation({
    leaf = "fade",
    enabled = true,
    speed = 2.5,
    bezier = "amethyst"
})
hl.animation({
    leaf = "border",
    enabled = true,
    speed = 3,
    bezier = "amethyst"
})
hl.animation({
    leaf = "borderangle",
    enabled = false,
    speed = 3,
    bezier = "default"
})
hl.animation({
    leaf = "workspaces",
    enabled = true,
    speed = 3,
    bezier = "amethyst",
    style = "slide"
})
