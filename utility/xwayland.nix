{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.programs.xwayland-satellite;
in {
  options = {
    programs.xwayland-satellite.enable =
      lib.mkEnableOption
      "Enables XWayland-satellite, a daemon for running X programs in Wayland compositors.";

    programs.xwayland-satellite.display = lib.mkOption {
      default = 0;
      type = lib.types.int;
      example = "1";
      description = "DISPLAY that Xwayland-Satellite should reside on";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services."xwayland-satellite" = {
      description = "Xwayland-Satellite background process";
      serviceConfig = {
        ExecStart = "${pkgs.xwayland-satellite}/bin/xwayland-satellite :${toString cfg.display}";
        Restart = "no";
      };
      wantedBy = ["graphical-session.target"];
      partOf = ["graphical-session.target"];
      after = ["graphical-session.target"];
    };
  };
}
