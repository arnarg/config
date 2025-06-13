{
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage (finalAttrs: {
  pname = "mcp-knowledge-graph";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "shaneholloman";
    repo = "mcp-knowledge-graph";
    rev = "3e41a7033e0e953e014281c6ba844f516ffb1eb4";
    hash = "sha256-VGqPDbviI115pwUUF+SW8Y0aWgCPbve9fmLFIMRp9d4=";
  };

  npmDepsHash = "sha256-noVQ3Xg2Wu75tE2TobFh/fN+5BuwYgofR1XfcEYkiv4=";
})
