{
  buildGoModule,
  fetchFromGitHub,
  ...
}:
buildGoModule {
  pname = "tpm-fido";
  version = "2022-09-27";

  src = fetchFromGitHub {
    owner = "psanford";
    repo = "tpm-fido";
    rev = "cd117cecc088cb4fa31f0258a442bbd967dc5b28";
    sha256 = "E+HW02D37SmOA3LDRaXdi3GXXnNpgWxlxinsjtmKXZ4=";
  };

  vendorHash = "sha256-qm/iDc9tnphQ4qooufpzzX7s4dbnUbR9J5L770qXw8Y=";
}
