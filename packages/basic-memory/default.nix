{
  python3Packages,
  fetchFromGitHub,
  fetchPypi,
}: let
  pyright = python3Packages.buildPythonApplication rec {
    pname = "pyright";
    version = "1.1.402";
    pyproject = true;

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-haM8LUDNRDnGaqlG/UznGrLz9bjCLONqYj9ZrCKTdoM=";
    };

    build-system = with python3Packages; [setuptools];

    dependencies = with python3Packages; [
      nodeenv
      typing-extensions
    ];
  };
in
  python3Packages.buildPythonApplication rec {
    pname = "basic-memory";
    version = "0.12.3";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "basicmachines-co";
      repo = "basic-memory";
      rev = "v${version}";
      hash = "sha256-0BBAi25Wla1yg+RECLoKq8GvN5DX1GW9A0/DnJflM9s=";
    };

    build-system = with python3Packages; [
      uv-build
      hatchling
    ];

    dependencies = with python3Packages; [
      aiosqlite
      alembic
      dateparser
      fastapi
      greenlet
      icecream
      loguru
      markdown-it-py
      mcp
      pillow
      pydantic-settings
      pydantic
      python-frontmatter
      pyyaml
      qasync
      rich
      sqlalchemy
      typer
      unidecode
      watchfiles

      pyright
    ];
  }
