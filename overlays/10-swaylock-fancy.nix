{ config, ... }:
self: super: {

  swaylock-fancy = super.swaylock-fancy.overrideAttrs (oa: rec {
    patchPhase = ''
      # Add -f flag to swaycmd
      sed -i -E 's/swaylock_cmd\+=\((.*)\)/swaylock_cmd+=\(\1 "-f"\)/' swaylock-fancy
    '';
  });

}
