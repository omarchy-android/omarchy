hl.on("hyprland.start", function()
  -- PRoot has neither systemd user services nor direct hardware access. More
  -- importantly, Android 12+ counts every short-lived helper here as a
  -- "phantom process" and may kill unrelated Termux children (tmux/Codex)
  -- during the startup burst. Keep the real Omarchy shell, but omit helpers
  -- whose services cannot function in this environment.
  if os.getenv("OMARCHY_PROOT") == "1" then
    hl.exec_cmd("omarchy-launch-shell")
    return
  end

  -- Slow app launch fix -- set systemd vars before starting session services.
  hl.exec_cmd("systemctl --user import-environment $(env | cut -d'=' -f 1)")
  hl.exec_cmd("dbus-update-activation-environment --systemd --all")

  hl.exec_cmd("omarchy-launch-shell")
  hl.exec_cmd("omarchy-provision-first-run")
  hl.exec_cmd("omarchy-powerprofiles-init")
  hl.exec_cmd(o.launch("omarchy-hyprland-monitor-watch"))
  hl.exec_cmd(o.launch("udiskie --automount --no-notify --no-tray"))

  -- Run post-boot hooks after startup config has loaded.
  hl.exec_cmd("sleep 2 && omarchy-hook post-boot")
end)
