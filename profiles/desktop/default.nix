{
  config,
  lib,
  pkgs,
  home,
  ...
}: {
  imports = [
    ./gnome
  ];

  config = with lib; {
    environment.systemPackages = with pkgs; [git home-manager];

    # Default packages for this profile
    local.desktop.gnome.enable = mkDefault true;

    sound.enable = true;
    hardware.pulseaudio.enable = false;
    services.pipewire.enable = true;
    services.pipewire.pulse.enable = true;

    hardware.opengl.enable = true;

    fonts = {
      enableDefaultPackages = true;
      packages = with pkgs; [
        inconsolata
        powerline-fonts
      ];
    };

    services.avahi.nssmdns = true;

    users.users.arnar.extraGroups = [
      "audio"
      "cdrom"
      "input"
      "tty"
      "video"
      "dialout"
    ];

    time.timeZone = mkForce "Europe/Vienna";
  };
}
