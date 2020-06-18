with import <nixpkgs> {};

mkShell {
  buildInputs = [ transmission ];
}
