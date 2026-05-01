if status is-interactive
    # Init
    set fish_greeting
    starship init fish | source
    zoxide init fish --cmd cd | source

    # env
    if not contains -- $HOME/.local/bin $PATH
        set -gx PATH $HOME/.local/bin $PATH
    end

    # Alias
    alias vim="nvim"
    alias cls="clear && printf '\e[3J'"
    alias ls="eza --icons -F -H --group-directories-first --git -1"
    alias ll="eza --icons -F -H --group-directories-first --git -1 -l"
    alias du="dust"
    alias df="duf -only local"
    alias diff="delta"

    # Functions
    function nhs --description "nh with secret inputs: nhs [switch|build|test|boot]"
        set -l mode switch
        switch $argv[1]
            case switch build test boot
                set mode $argv[1]
                set -e argv[1]
        end

        nh os $mode --update $argv /home/yuzujr/nixos-config#nixos \
            -- --override-input secrets path:/home/yuzujr/nix-secrets
    end

    function y
        set tmp (mktemp -t "yazi-cwd.XXXXXX")
        yazi $argv --cwd-file="$tmp"
        if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
            builtin cd -- "$cwd"
        end
        rm -f -- "$tmp"
    end

    function ff --wraps fastfetch --description "fastfetch with GNOME light/dark config"
        set -l light ~/.config/fastfetch/config-light.jsonc
        set -l dark ~/.config/fastfetch/config-dark.jsonc

        set -l cs (dconf read /org/gnome/desktop/interface/color-scheme 2>/dev/null)

        if string match -q "*prefer-dark*" -- $cs
            command fastfetch --config $dark
        else
            command fastfetch --config $light
        end
    end

    # Keybindings
    bind \cs 'for cmd in sudo doas please; if command -q $cmd; fish_commandline_prepend $cmd; break; end; end'
    bind \ec 'commandline | wl-copy --trim-newline'
end
