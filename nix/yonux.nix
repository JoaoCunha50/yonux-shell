{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    btop
    wl-clipboard
    cliphist
    fuzzel
    grim
    slurp
    mako
    playerctl
    brightnessctl
    libnotify
    nautilus
    hyprpicker
    hyprpolkitagent
    bibata-cursors
    adw-gtk3
    adwaita-icon-theme
    matugen
    lm_sensors
    xdg-terminal-exec
  ];

  systemd.packages = [ pkgs.hyprpolkitagent ];
  services.gnome.gnome-keyring.enable = true;

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  services.hypridle.enable = true;
  programs.hyprlock.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  boot.extraModprobeConfig = ''
    options btusb enable_autosuspend=0
  '';

  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;

  programs.gamescope.enable = true;
  programs.gamemode.enable = true;
}
