{config, ...}: {
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      format = "[](base00)\$os\$username\[@](bg:base00 fg:base05)\$hostname\[](bg:base01 fg:base00)\$directory\[](fg:base01 bg:base02)\$git_branch\$git_status\[](fg:base02 bg:base03)\$c\$rust\$golang\$nodejs\$php\$java\$kotlin\$haskell\$python\$nix_shell\[ ](fg:base03)\$line_break$character";

      os = {
        style = "bg:base00 fg:base0D";
        disabled = false;
        symbols = {
          NixOS = "";
          Windows = "󰍲";
          Ubuntu = "󰕈";
          SUSE = "";
          Raspbian = "󰐿";
          Mint = "󰣭";
          Macos = "";
          Manjaro = "";
          Linux = "󰌽";
          Gentoo = "󰣨";
          Fedora = "󰣛";
          Alpine = "";
          Amazon = "";
          Android = "";
          Arch = "󰣇";
          Artix = "󰣇";
          CentOS = "";
          Debian = "󰣚";
          Redhat = "󱄛";
          RedHatEnterprise = "󱄛";
        };
      };

      username = {
        show_always = true;
        style_user = "bg:base00 fg:base05";
        style_root = "bg:base00 fg:base08";
        format = "[$user]($style)";
      };

      hostname = {
        ssh_only = false;
        ssh_symbol = " ";
        trim_at = ".";
        format = "[$hostname$ssh_symbol ]($style)";
        style = "bg:base00 fg:base05";
      };

      directory = {
        style = "bg:base01 fg:base05";
        format = "[ $path ]($style)";
        read_only = " 󰌾 ";
        read_only_style = "bg:base01 fg:base08";
        truncation_length = 3;
        truncation_symbol = "…/";
        substitutions = {
          "Documents" = "󰈙 ";
          "Downloads" = " ";
          "Music" = "󰝚 ";
          "Pictures" = " ";
          "Developer" = "󰲋 ";
          ".config" = " ";
          "nixos" = " ";
        };
      };

      git_branch = {
        symbol = "";
        style = "bg:base02 fg:base05";
        format = "[ $symbol $branch ]($style)";
      };

      git_status = {
        style = "bg:base02 fg:base05";
        format = "[$all_status$ahead_behind ]($style)";
      };

      # Programming languages with base16 colors
      nix_shell = {
        symbol = " ";
        style = "bg:base03 fg:base0D";
        format = "[ $symbol ($name) ]($style)";
      };

      nodejs = {
        symbol = "";
        style = "bg:base03 fg:base0B";
        format = "[ $symbol ($version) ]($style)";
      };

      c = {
        symbol = " ";
        style = "bg:base03 fg:base05";
        format = "[ $symbol ($version) ]($style)";
      };

      rust = {
        symbol = "";
        style = "bg:base03 fg:base09";
        format = "[ $symbol ($version) ]($style)";
      };

      golang = {
        symbol = " ";
        style = "bg:base03 fg:base0D";
        format = "[ $symbol ($version) ]($style)";
      };

      php = {
        symbol = "";
        style = "bg:base03 fg:base0E";
        format = "[ $symbol ($version) ]($style)";
      };

      java = {
        symbol = " ";
        style = "bg:base03 fg:base09";
        format = "[ $symbol ($version) ]($style)";
      };

      kotlin = {
        symbol = "";
        style = "bg:base03 fg:base0E";
        format = "[ $symbol ($version) ]($style)";
      };

      haskell = {
        symbol = "";
        style = "bg:base03 fg:base0F";
        format = "[ $symbol ($version) ]($style)";
      };

      python = {
        symbol = "";
        style = "bg:base03 fg:base0A";
        format = "[ $symbol ($version) ]($style)";
      };

      line_break.disabled = false;

      character = {
        disabled = false;
        success_symbol = "[➜](bold fg:base0B)";
        error_symbol = "[➜](bold fg:base08)";
        vimcmd_symbol = "[](bold fg:base0A)";
      };

      # Additional modules that might be useful for your setup
      cmd_duration = {
        min_time = 2000;
        format = "took [$duration](bold fg:base0A)";
      };

      time = {
        disabled = false;
        time_format = "%R";
        style = "bg:base03 fg:base05";
        format = "[ ♰ $time ]($style)";
      };
    };
  };
}
