{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  wayland.windowManager.hyprland.settings = {
    exec-once = [
      "hyprpaper"
      "hypridle"
      "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1 &"
      "gnome-keyring-daemon --start --components=secrets"
    ];
  };
}
