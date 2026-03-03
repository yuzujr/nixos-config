{ pkgs, ... }:

{
  users.users.yuzujr = {
    isNormalUser = true;
    description = "yuzujr";
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
      "video"
      "input"
    ];
  };
}
