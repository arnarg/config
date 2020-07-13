{ config, ... }:
self: super: {

  swaylock-fancy = super.swaylock-fancy.overrideAttrs (oa: rec {
    patchPhase = ''
      # Add -f flag to swaycmd
      sed -i -E 's/swaylock_cmd\+=\((.*)\)/swaylock_cmd+=\(\1 "-f"\)/' swaylock-fancy
      sed -i -E "s/grep name/jq -r \'.[] | select\(.active == true\) | .name\'/" swaylock-fancy
    '';
  });

}
