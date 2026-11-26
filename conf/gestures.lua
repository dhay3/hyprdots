hl.config({
	gestures = {
		workspace_swipe_distance = 400,
		workspace_swipe_touch = false,
		workspace_swipe_create_new = false,
	},
})

for fingers = 4, 9 do
	hl.gesture({
		fingers = fingers,
		direction = "horizontal",
		action = "workspace",
	})
end

for fingers = 4, 9 do
	hl.gesture({
		fingers = fingers,
		direction = "up",
		action = function()
			if hl.plugin.hyprexpo then
				hl.plugin.hyprexpo.expo("toggle")
			end
		end,
	})
end

for fingers = 4, 9 do
	hl.gesture({
		fingers = fingers,
		direction = "down",
		action = function()
			if hl.plugin.hymission then
				hl.plugin.hymission.toggle("forceall")
			end
		end,
	})
end

hl.gesture({ fingers = 4, direction = "pinch", action = "cursor_zoom", zoom_level = 1.2 })
hl.gesture({ fingers = 3, direction = "pinchout", action = "cursor_zoom", zoom_level = 1.2, mode = "mult" })
hl.gesture({ fingers = 2, direction = "pinchout", action = "cursor_zoom", zoom_level = 1 / 1.2, mode = "mult" })
