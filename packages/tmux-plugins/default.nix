{
  lib,
  fetchFromGitHub,
  pkgs,
  reattach-to-user-namespace,
  stdenv,
}:
# Stolen from <nixpkgs>/pkgs/misc/tmux-plugins/default.nix
let
  rtpPath = "share/tmux-plugins";

  addRtp = path: rtpFilePath: attrs: derivation:
    derivation
    // {rtp = "${derivation}/${path}/${rtpFilePath}";}
    // {
      overrideAttrs = f: mkDerivation (attrs // f attrs);
    };

  mkDerivation = a @ {
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
    addRtp "${rtpPath}/${path}" rtpFilePath a (stdenv.mkDerivation (a
      // {
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

        dependencies = [pkgs.bash] ++ dependencies;
      }));
in rec {
  inherit mkDerivation;

  navigate = mkDerivation {
    pluginName = "navigate";
    version = "2020-10-16";
    rtpFilePath = "tmux-navigate.tmux";
    src = fetchFromGitHub {
      owner = "sunaku";
      repo = "tmux-navigate";
      rev = "52da3cdca6e23fda99e05527093d274622b742cd";
      sha256 = "0njnra2a9c51hxghhqlyvdi4b02wgmfd6jcpfhapcvvv599g8sri";
    };
  };
}
