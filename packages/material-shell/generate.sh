
#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=../../../../.. -i bash -p nodePackages.node2nix

# TODO: merge with other node packages in nixpkgs/pkgs/development/node-packages once
# * support for npm projects in sub-directories is added to node2nix:
#   https://github.com/svanderburg/node2nix/issues/177
# * we find a way to enable development dependencies for some of the packages

set -euo pipefail

if [ "$#" -ne 1 ] || [[ "$1" == -* ]]; then
  echo "Regenerates the node composition and package nix files for the material-shell package."
  echo "Usage: $0 <git release tag>"
  exit 1
fi

wget https://github.com/material-shell/material-shell/raw/$1/package.json
wget https://github.com/material-shell/material-shell/raw/$1/package-lock.json

node2nix \
  --development \
  --input ./package.json \
  --lock ./package-lock.json \
  --output node-packages.nix \
  --composition node-composition.nix \

rm package.json package-lock.json
