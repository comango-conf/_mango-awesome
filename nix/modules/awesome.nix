{ pkgs, ... }:

{

  nixpkgs.overlays = [ (self: super: {
    awesome = (super.awesome.override {
      lua = self.lua5_3;
    }).overrideAttrs ( old: {
      name = "awesome-git";
      src = super.fetchFromGitHub {
        owner = "awesomeWM";
        repo = "awesome";
        rev = "05a405b38bbcb8fa3b344d45d94d4f56b83c74df";
        sha256 = "OBCUbkWEcWHokYNjfz4aRRkxr9rwGNkaKnovzoliFwU=";
      };
    });
  })];

   
  services.xserver.windowManager.awesome = {
    luaModules = with pkgs.luaPackages; [
      #luarocks
    ];
  };


  environment.systemPackages = with pkgs; [
    acpilight
    i3lock-color
    imagemagick
    pamixer
    pavucontrol
    xclip
  ];
}
