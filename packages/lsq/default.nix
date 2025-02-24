{
  buildGoModule,
  fetchFromGitHub,
  ...
}:
buildGoModule rec {
  pname = "lsq";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "jrswab";
    repo = "lsq";
    rev = "v${version}";
    sha256 = "sha256-tYAij49DyRlAgvfE891O6wCLEd26RVk5asdxPr8lf0w=";
  };

  vendorHash = "sha256-YmFE2CDGX/3IdoOdCFZWAsPtiA4sF2SeIb6q9/Fszcc=";
}
