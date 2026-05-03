{ vars, ... }:
{
    programs.git = {
        enable = true;
        settings = {
            user = {
                name = vars.git.name;
                email = vars.git.email;
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
