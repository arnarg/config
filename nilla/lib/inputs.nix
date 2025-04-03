{config}: {
  options.generators.inputs = with config.lib; {
    pins = options.create {
      type = types.attrs.of types.attrs.any;
      description = "Attribute set with input pins.";
    };
  };

  config = {
    inputs =
      builtins.mapAttrs (n: pin: {
        src = pin;
      })
      config.generators.inputs.pins;
  };
}
