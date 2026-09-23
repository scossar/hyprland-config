-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

local omarchy_gdk_scale = 1

hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))
-- hl.monitor({ output = "", mode = "preferred", position = "auto", scale = omarchy_monitor_scale })
hl.monitor({ output = "eDP-1", mode = "1920x1080@144", position = "0x0", scale = 1.35 })
hl.monitor({ output = "HDMI-A-1", mode = "3440x1440@60", position = "1440x0", scale = 1 })

-- Keep workspace 1 on the laptop and Omarchy's remaining numbered
-- workspaces on the external monitor.
hl.workspace_rule({ workspace = "1", monitor = "eDP-1", default = true })
for workspace = 2, 10 do
	hl.workspace_rule({
		workspace = tostring(workspace),
		monitor = "HDMI-A-1",
		default = workspace == 2,
	})
end

local function bind_later_workspace_to_external(workspace)
	if not workspace.special and workspace.id > 10 then
		hl.workspace_rule({ workspace = tostring(workspace.id), monitor = "HDMI-A-1" })
	end
end

-- Cover workspaces above Omarchy's default 1-10 range, including any that
-- already exist when the configuration is reloaded.
for _, workspace in pairs(hl.get_workspaces()) do
	bind_later_workspace_to_external(workspace)
end
hl.on("workspace.created", bind_later_workspace_to_external)

-- Configure a specific monitor.
-- hl.monitor({ output = "DP-2", mode = "2560x1440@144", position = "0x0", scale = 1 })

-- Portrait/rotated secondary monitor (transform: 1 = 90°, 3 = 270°).
-- hl.monitor({ output = "DP-2", mode = "preferred", position = "auto", scale = 1, transform = 1 })
