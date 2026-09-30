{
  flake.nixosModules.antigravity = {
    vars,
    pkgs,
    ...
  }: {
    home-manager.users.${vars.username} = {
      home.packages = with pkgs; [
        antigravity-cli
      ];
      programs.antigravity-cli = {
        enable = true;
        permissions = {
          allow = [];
          ask = [];
          deny = [];
        };
        skills = [];
        mcpServers = {};
      };
    };
  };
}
