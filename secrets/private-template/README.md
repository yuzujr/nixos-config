# Private Secrets Template

Use `scripts/security/bootstrap-private-secrets.sh` to initialize an actual private `nix-secrets` repository.

Example:

```bash
/home/yuzujr/nixos-config/scripts/security/bootstrap-private-secrets.sh /home/yuzujr/nix-secrets
```

Then create a private GitHub repository and push it (for example `git@github.com:yuzujr/nix-secrets.git`).
