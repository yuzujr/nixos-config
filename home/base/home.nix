{ myvars, ... }:
{
  home = {
    inherit (myvars) username;
    stateVersion = "24.11";
  };
}
