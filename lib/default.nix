{ lib, ... }:
{
  relativeToRoot = lib.path.append ../.;

  scanPaths =
    path:
    builtins.map (f: path + "/${f}") (
      builtins.attrNames (
        lib.attrsets.filterAttrs (
          name: kind:
          kind == "directory"
          || (
            name != "default.nix"
            && lib.strings.hasSuffix ".nix" name
          )
        ) (builtins.readDir path)
      )
    );
}
