-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Omarchy root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")

-- Search the Obsidian vault.
-- o.bind("SUPER + CTRL + SHIFT + O", "Obsidian vault search", "omarchy-shell shell toggle scossar.vault-search")

-- Copilot key (was Omarchy menu): open the Obsidian vault search.
hl.unbind("SUPER + SHIFT + code:201")
o.bind("SUPER + SHIFT + code:201", "Obsidian vault search", "omarchy-shell shell toggle scossar.vault-search")

-- Replace the default browser shortcut with a floating terminal.
hl.unbind("SUPER + SHIFT + RETURN")
o.bind("SUPER + SHIFT + RETURN", "Floating terminal", "omarchy launch terminal --app-id=org.omarchy.terminal")

-- Offline spelling lookup.
o.bind("SUPER + CTRL + SHIFT + D", "Word lookup", "omarchy-shell shell toggle scossar.word-lookup")

-- Build a shortcut that brings the most recently used matching window here,
-- or launches the application. Classes are matched exactly, ignoring case.
local function app_here(classes, command)
	local matches = {}
	for _, class in ipairs(classes) do
		matches[class:lower()] = true
	end

	return function()
		-- Capture the destination before moving or focusing any window.
		local workspace = hl.get_active_workspace()
		if not workspace then
			return
		end
		local destination = tostring(workspace.id)
		local selected, best_rank

		for _, window in ipairs(hl.get_windows()) do
			if window.mapped and matches[window.class:lower()] then
				local rank = window.focus_history_id
				if not rank or rank < 0 then
					rank = math.huge
				end
				if not selected or rank < best_rank then
					selected, best_rank = window, rank
				end
			end
		end

		if not selected then
			hl.exec_cmd(o.launch(command))
			return
		end

		hl.dispatch(hl.dsp.window.move({
			workspace = destination,
			window = selected,
			follow = false,
		}))
		hl.dispatch(hl.dsp.focus({ window = selected }))
	end
end

-- Replace Obsidian's launch-or-focus shortcut and ChatGPT's web-app shortcut.
hl.unbind("SUPER + SHIFT + O")
o.bind("SUPER + SHIFT + O", "Obsidian here", app_here({ "md.obsidian.obsidian", "obsidian" }, "obsidian"))
hl.unbind("SUPER + SHIFT + A")
o.bind("SUPER + SHIFT + A", "ChatGPT here", app_here({ "chatgpt" }, "chatgpt"))

-- Move floating windows to the top corners, leaving space for the bar.
local function move_floating_to_top(right)
	return function()
		local window = hl.get_active_window()
		if not window or not window.floating or window.fullscreen ~= 0 then
			return
		end

		local monitor = window.monitor
		if not monitor then
			return
		end
		local width = monitor.size.width
		if monitor.transform % 2 == 1 then
			width = monitor.size.height
		end
		width = width / monitor.scale

		local x = monitor.reserved.left + 10
		if right then
			x = math.max(x, width - monitor.reserved.right - window.size.x - 10)
		end
		hl.dispatch(hl.dsp.window.move({
			window = window,
			x = math.floor(monitor.position.x + x),
			y = monitor.position.y + math.max(40, monitor.reserved.top + 10),
			relative = false,
		}))
	end
end

o.bind("SUPER + CTRL + SHIFT + LEFT", "Floating window to top left", move_floating_to_top(false))
o.bind("SUPER + CTRL + SHIFT + RIGHT", "Floating window to top right", move_floating_to_top(true))
o.bind("SUPER + SHIFT + H", "Hermes Desktop", "hermes-desktop")
