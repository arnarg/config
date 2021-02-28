self: super: {

  # CapabilityBoundingSet is not allowed in user systemd service
  yubikey-agent = super.yubikey-agent.overrideAttrs (oa: rec {
    postInstall = oa.postInstall + ''
      substituteInPlace $out/lib/systemd/user/yubikey-agent.service \
      --replace "CapabilityBoundingSet=" ""
    '';
  });

}
