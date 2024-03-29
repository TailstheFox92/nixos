{ pkgs, config, ... }:

{
  services.mako = {
    enable = true;
    backgroundColor = "#${config.colorScheme.palette.base01}";
    borderColor = "#${config.colorScheme.palette.base06}";
    borderRadius = 5;
    borderSize = 2;
    textColor = "#${config.colorScheme.palette.base04}";
    layer = "overlay";
    extraConfig = "default-timeout=5000";
  };
}
