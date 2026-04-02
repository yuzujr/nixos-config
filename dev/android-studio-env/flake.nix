{
    description = "Android Studio dev shell";

    inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    outputs =
        { nixpkgs, ... }:
        let
            systems = [
                "x86_64-linux"
                "aarch64-linux"
            ];
            forAllSystems = nixpkgs.lib.genAttrs systems;
        in
        {
            devShells = forAllSystems (
                system:
                let
                    pkgs = import nixpkgs {
                        inherit system;
                        config.allowUnfreePredicate =
                            pkg:
                            builtins.elem (nixpkgs.lib.getName pkg) [
                                "android-studio"
                            ];
                    };
                in
                {
                    default = pkgs.mkShell {
                        packages = [
                            pkgs.android-tools
                            pkgs.jdk17
                            pkgs.gradle
                            pkgs.cmake
                            pkgs.ninja
                            pkgs.pkg-config
                        ]
                        ++ pkgs.lib.optionals pkgs.stdenv.hostPlatform.isx86_64 [
                            pkgs.android-studio
                        ];

                        shellHook = ''
                            export JAVA_HOME="${pkgs.jdk17}"
                            export ANDROID_HOME="$HOME/Android/Sdk"
                            export ANDROID_SDK_ROOT="$ANDROID_HOME"

                            echo "Android development shell ready"
                            echo "JAVA_HOME=$JAVA_HOME"
                            echo "ANDROID_SDK_ROOT=$ANDROID_SDK_ROOT"

                            if command -v android-studio >/dev/null 2>&1; then
                              echo "Run: android-studio"
                            elif command -v studio >/dev/null 2>&1; then
                              echo "Run: studio"
                            else
                              echo "android-studio is unavailable on this architecture."
                            fi
                        '';
                    };
                }
            );
        };
}
