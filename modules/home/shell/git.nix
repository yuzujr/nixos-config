{ vars, ... }:
{
    programs.git = {
        enable = true;
        settings = {
            user = {
                email = vars.git.email;
                name = vars.git.name;
            };
            core.quotepath = false;
            init.defaultBranch = "main";
        };
    };

    programs.delta = {
        enable = true;
        enableGitIntegration = true;
    };
}
