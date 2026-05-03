{
    nixpkgs,
    system,
    ...
}:
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
pkgs.mkShell {
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

        echo
        echo "JAVA_HOME=$JAVA_HOME"
        echo "ANDROID_SDK_ROOT=$ANDROID_SDK_ROOT"
    '';
}
