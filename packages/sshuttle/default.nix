{ python37Packages, fetchFromGitHub }:

with python37Packages; buildPythonPackage rec {
  pname = "sshuttle";
  version = "1.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0qfgxm36cjcrj963w5pz0hp2m853fc39ccbk9rmbn84scs41rzqg";
  };

  nativeBuildInputs = [ setuptools_scm setuptools-scm-git-archive ];

  # sshuttle is wrapped in a shell script that sets PATH env variable and such.
  # sshuttle also runs itself in subcommand using a python interpreter.
  # Here I'm crudely patching the source code so that it runs the python script,
  # not the wrapping shell script.
  postPatch = ''
    sed -i "s|sys\.argv\[0\]|\"$out/bin/.sshuttle-wrapped\"|g" sshuttle/client.py
  '';

  doCheck = false;
}
