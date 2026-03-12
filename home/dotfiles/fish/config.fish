if status is-interactive
    # Init
    set fish_greeting
    starship init fish | source
    zoxide init fish | source

    # env
    set -x XDG_CONFIG_HOME "$HOME/.config"
    set -x EDITOR nvim

    # Alias
    alias vim="nvim"
    alias cls="clear && printf '\e[3J'"
    alias ls="eza --icons -F -H --group-directories-first --git -1"
    alias ll="eza --icons -F -H --group-directories-first --git -1 -l"
    alias du="dust"
    alias df="duf -only local"
    alias cd="z"
    alias diff="delta"
    alias code="code --ozone-platform-hint=auto &> /dev/null"

    # Functions
    function nhs --description "nh with secret inputs: nhs [switch|build|test|boot]"
        set -l mode switch
        switch $argv[1]
            case switch build test boot
                set mode $argv[1]
                set -e argv[1]
        end

        nh os $mode $argv /home/yuzujr/nixos-config#nixos \
            -- --override-input mysecrets path:/home/yuzujr/nix-secrets
    end

    function y
        set tmp (mktemp -t "yazi-cwd.XXXXXX")
        yazi $argv --cwd-file="$tmp"
        if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
            builtin cd -- "$cwd"
        end
        rm -f -- "$tmp"
    end

    function copy
        if test (count $argv) -eq 0
            echo "Usage: copy <filename>"
            return 1
        end
        if not test -f $argv[1]
            echo "File not found: $argv[1]"
            return 1
        end
        wl-copy <$argv[1]
    end

    function fast --wraps fastfetch --description "fastfetch with GNOME light/dark config"
        set -l light ~/.config/fastfetch/config-light.jsonc
        set -l dark ~/.config/fastfetch/config-dark.jsonc

        set -l cs (dconf read /org/gnome/desktop/interface/color-scheme 2>/dev/null)

        if string match -q "*prefer-dark*" -- $cs
            command fastfetch --config $dark
        else
            command fastfetch --config $light
        end
    end

    function fixqtperm --description "Make Qt Creator generated source files writable"
        set -l target "."
    
        if test (count $argv) -ge 1
            set target $argv[1]
        end
    
        if not test -e $target
            echo "fixqtperm: path not found: $target" >&2
            return 1
        end
    
        find $target -type f \( \
            -name '*.cpp' -o \
            -name '*.cc' -o \
            -name '*.cxx' -o \
            -name '*.h' -o \
            -name '*.hpp' -o \
            -name '*.ui' -o \
            -name 'CMakeLists.txt' \
        \) -exec chmod u+w {} +
    end

    # Keybindings
    bind \cs 'for cmd in sudo doas please; if command -q $cmd; fish_commandline_prepend $cmd; break; end; end'
end
