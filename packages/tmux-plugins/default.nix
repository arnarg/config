{ lib
, fetchFromGitHub
, pkgs
, reattach-to-user-namespace
, stdenv
}:

let
  rtpPath = "share/tmux-plugins";

  addRtp = path: rtpFilePath: attrs: derivation:
    derivation // { rtp = "${derivation}/${path}/${rtpFilePath}"; } // {
      overrideAttrs = f: mkDerivation (attrs // f attrs);
    };

  mkDerivation = a@{
    pluginName,
    rtpFilePath ? (builtins.replaceStrings ["-"] ["_"] pluginName) + ".tmux",
    namePrefix ? "tmuxplugin-",
    src,
    unpackPhase ? "",
    configurePhase ? ":",
    buildPhase ? ":",
    addonInfo ? null,
    preInstall ? "",
    postInstall ? "",
    path ? lib.getName pluginName,
    dependencies ? [],
    ...
  }:
    addRtp "${rtpPath}/${path}" rtpFilePath a (stdenv.mkDerivation (a // {
      pname = namePrefix + pluginName;

      inherit pluginName unpackPhase configurePhase buildPhase addonInfo preInstall postInstall;

      installPhase = ''
        runHook preInstall
        target=$out/${rtpPath}/${path}
        mkdir -p $out/${rtpPath}
        cp -r . $target
        if [ -n "$addonInfo" ]; then
          echo "$addonInfo" > $target/addon-info.json
        fi
        runHook postInstall
      '';

      dependencies = [ pkgs.bash ] ++ dependencies;
    }));

in rec {

  inherit mkDerivation;

  tmux-tilish = mkDerivation {
    pluginName = "tmux-tilish";
    version = "unstable-2020-05-04";
    rtpFilePath = "tilish.tmux";
    src = fetchFromGitHub {
      owner = "jabirali";
      repo = "tmux-tilish";
      rev = "6dfa3bf6bad2d111d4d1192caf5572a5534355df";
      sha256 = "1418sb5755jdn87a9a05f25kwddc9np70k94cacam9bzhv6wikwg";
    };
  };

  tmux-navigate = mkDerivation {
    pluginName = "tmux-navigate";
    version = "unstable-2020-05-06";
    rtpFilePath = "tmux-navigate.tmux";
    src = fetchFromGitHub {
      owner = "sunaku";
      repo = "tmux-navigate";
      rev = "053a2463efd4d5ba7558f81d7615090505a54df7";
      sha256 = "0y4aaff4pd55ssx72xmhml3jziwwirrd6vq4138lgcsx4b8cldk7";
    };
  };

}
