# Secret Management with Bitwarden

This dotfiles repo uses [chezmoi](https://chezmoi.io) with [Bitwarden](https://bitwarden.com) for secret management. Secrets are stored in your Bitwarden vault and fetched automatically when applying dotfiles.

## Prerequisites

### Install Bitwarden CLI

```bash
# Using npm
npm install -g @bitwarden/cli

# Using snap
sudo snap install bw

# Using Homebrew (macOS)
brew install bitwarden-cli
```

### Login to Bitwarden

```bash
bw login
```

## Quick Start

Before applying dotfiles, unlock your Bitwarden vault:

```bash
export BW_SESSION=$(bw unlock --raw)
chezmoi apply
```

## Storing Secrets in Bitwarden

Create a Bitwarden item (Login or Secure Note) to store your secrets. You can use:

- **Password field**: For a single secret
- **Custom fields**: For multiple related secrets
- **Notes**: For longer content like SSH keys

### Recommended Structure

Create an item named `dotfiles-secrets` with custom fields:

| Field Name       | Value                  |
|------------------|------------------------|
| `github_token`   | ghp_xxxxxxxxxxxx       |
| `openai_api_key` | sk-xxxxxxxxxxxx        |
| `anthropic_key`  | sk-ant-xxxxxxxxxxxx    |

## Using Secrets in Templates

Template files use the `.tmpl` extension and are processed by chezmoi.

### Basic Usage

To access a Bitwarden item's password:

```
{{ (bitwarden "item" "my-item-name").login.password }}
```

### Accessing Custom Fields

```
{{- $secrets := bitwarden "item" "dotfiles-secrets" -}}
{{- range $secrets.fields -}}
{{- if eq .name "github_token" }}
export GITHUB_TOKEN={{ .value }}
{{- end -}}
{{- end -}}
```

### Helper Function

Add this to the top of your template for cleaner access to custom fields:

```
{{- $secrets := bitwarden "item" "dotfiles-secrets" -}}
{{- $field := dict -}}
{{- range $secrets.fields -}}
{{- $_ := set $field .name .value -}}
{{- end -}}

export GITHUB_TOKEN={{ index $field "github_token" }}
export OPENAI_API_KEY={{ index $field "openai_api_key" }}
```

### Accessing Notes

```
{{ (bitwarden "item" "my-ssh-key").notes }}
```

## Examples

### Example 1: Environment Variables File

Create `dot_env_secrets.tmpl`:

```
{{- $secrets := bitwarden "item" "dotfiles-secrets" -}}
# Auto-generated secrets - do not edit manually
{{- range $secrets.fields }}
export {{ .name | upper }}={{ .value }}
{{- end }}
```

This generates `~/.env_secrets` which you can source in your shell rc file:

```bash
# In .bashrc or .zshrc
[ -f ~/.env_secrets ] && source ~/.env_secrets
```

### Example 2: Git Config with Signing Key

Create `dot_config/git/config.tmpl`:

```
[user]
    name = Your Name
    email = your@email.com
    signingkey = {{ (bitwarden "item" "gpg-signing-key").login.password }}

[commit]
    gpgsign = true
```

### Example 3: SSH Config

Create `private_dot_ssh/config.tmpl`:

```
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519

Host private-server
    HostName {{ (bitwarden "item" "private-server").login.uris | first | .uri }}
    User {{ (bitwarden "item" "private-server").login.username }}
```

### Example 4: Application Config with API Key

Create `dot_config/some-app/config.toml.tmpl`:

```toml
[api]
{{- $secrets := bitwarden "item" "dotfiles-secrets" }}
{{- range $secrets.fields }}
{{- if eq .name "some_app_api_key" }}
key = "{{ .value }}"
{{- end }}
{{- end }}
```

## Converting Existing Files to Templates

1. Rename the file to add `.tmpl` extension:
   ```bash
   cd ~/.local/share/chezmoi
   mv dot_config/myapp/config.toml dot_config/myapp/config.toml.tmpl
   ```

2. Edit the file to replace hardcoded secrets with template expressions

3. Store the actual secrets in Bitwarden

4. Test with:
   ```bash
   chezmoi diff
   chezmoi apply --dry-run --verbose
   ```

## Workflow Tips

### Create a Shell Alias

Add to your shell rc file:

```bash
alias cza='export BW_SESSION=$(bw unlock --raw) && chezmoi apply'
```

### Auto-sync Bitwarden Before Apply

```bash
alias cza='bw sync && export BW_SESSION=$(bw unlock --raw) && chezmoi apply'
```

### Check What Will Change

```bash
export BW_SESSION=$(bw unlock --raw)
chezmoi diff
```

## Troubleshooting

### "vault is locked" Error

Your Bitwarden session expired. Re-run:
```bash
export BW_SESSION=$(bw unlock --raw)
```

### "item not found" Error

- Check the item name matches exactly (case-sensitive)
- Run `bw sync` to pull latest vault changes
- Verify with `bw get item "item-name"`

### Testing Templates

Preview the output without applying:
```bash
chezmoi execute-template < ~/.local/share/chezmoi/dot_config/myapp/config.toml.tmpl
```

## Security Notes

- Secrets are fetched at `chezmoi apply` time and written to target files
- Target files containing secrets should have appropriate permissions (chezmoi handles this with `private_` prefix)
- Never commit the target files (e.g., `~/.env_secrets`) to version control
- The `.tmpl` source files in this repo are safe to commit - they contain no actual secrets

## References

- [chezmoi Bitwarden docs](https://www.chezmoi.io/user-guide/password-managers/bitwarden/)
- [Bitwarden CLI docs](https://bitwarden.com/help/cli/)
