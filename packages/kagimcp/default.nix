{
  python3Packages,
  fetchFromGitHub,
  fetchPypi,
}: let
  kagiapi = python3Packages.buildPythonPackage rec {
    pname = "kagiapi";
    version = "0.2.1";

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-NV/kB7TGg9bwhIJ+T4VP2VE03yhC8V0Inaz/Yg4/Sus=";
    };

    build-system = with python3Packages; [setuptools];

    dependencies = with python3Packages; [
      requests
      typing-extensions
    ];
  };
in
  python3Packages.buildPythonApplication {
    pname = "kagimcp";
    version = "2025-05-28";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "kagisearch";
      repo = "kagimcp";
      rev = "4f19e3e337ad0217ebf8a181ca3d00fa7e363ec5";
      hash = "sha256-2VsgowlMjxUkdN1Vhg78+hLsgyqGgeCXHKZTtAwPlso=";
    };

    build-system = with python3Packages; [
      uv-build
      hatchling
    ];

    dependencies = with python3Packages; [
      mcp
      pydantic
      kagiapi
    ];

    patchPhase = ''
      sed -i -e 's|pydantic~=2.10.3|pydantic~=2.11.0|g' pyproject.toml
    '';
  }
