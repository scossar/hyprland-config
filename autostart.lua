-- Extra autostart processes.
-- o.launch_on_start("my-service")

-- Force Intel iHD for VA-API instead of Omarchy's NVIDIA default
-- (default.hypr.nvidia sets LIBVA_DRIVER_NAME=nvidia on this hybrid GPU,
-- which makes Chromium video playback janky). Must be set after Omarchy's
-- defaults load, so it belongs here rather than in hyprland.conf (which
-- Hyprland no longer reads now that hyprland.lua is the config).
hl.env("LIBVA_DRIVER_NAME", "iHD")

