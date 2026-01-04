{pkgs, ...}: let
  rofi-type5 = pkgs.fetchFromGitHub {
    owner = "adi1090x";
    repo = "rofi";
    rev = "master";
    hash = "sha256-iUX0Quae06tGd7gDgXZo1B3KYgPHU+ADPBrowHlv02A=";
  };
in {
  home-manager.users.alsesd = {
    home.packages = with pkgs; [
      rofi
      rofi-bluetooth
      networkmanager_dmenu
    ];

    # This links the entire folder so all styles (1-5) are available
    xdg.configFile."rofi/launchers/type-5".source = "${rofi-type5}/files/launchers/type-5";

    # Link the shared colors/fonts needed by the theme
    xdg.configFile."rofi/colors".source = "${rofi-type5}/files/colors";

    xdg.configFile."rofi/config.rasi".text = ''
      /* Load the layout and colors from the theme itself */
      @import "~/.config/rofi/launchers/type-5/style-5.rasi"

      configuration {
        modi: "drun,filebrowser";
        show-icons: true;
        display-drun: "Apps";
        terminal: "kitty";
      }
    '';
  };
}
