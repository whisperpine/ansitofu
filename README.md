# Ansitofu

[![GitHub License](https://img.shields.io/github/license/whisperpine/ansitofu)](https://github.com/whisperpine/ansitofu/blob/main/LICENSE)
[![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/whisperpine/ansitofu/checks.yml?logo=github&label=checks)](https://github.com/whisperpine/ansitofu/actions/workflows/checks.yml)
[![GitHub deployments](https://img.shields.io/github/deployments/whisperpine/ansitofu/infra-default?logo=github&label=deployment)](https://github.com/whisperpine/ansitofu/deployments/infra-default)
[![GitHub Release](https://img.shields.io/github/v/release/whisperpine/ansitofu?logo=github)](https://github.com/whisperpine/ansitofu/releases)
[![Ansible Collection Version](https://img.shields.io/ansible/collection/v/whisperpine/ansitofu?logo=ansible)](https://galaxy.ansible.com/ui/repo/published/whisperpine/ansitofu/)

My personal Ansible collection [whisperpine.ansitofu](https://galaxy.ansible.com/ui/repo/published/whisperpine/ansitofu/),
containing reusable Ansible roles for services on Debian/Ubuntu hosts. Roles are
integration-tested with [Molecule](https://github.com/ansible/molecule) in CI
and published to [Ansible Galaxy](https://galaxy.ansible.com/ui/repo/published/whisperpine/ansitofu/).

## Ansible Roles

| Role | Purpose | Molecule |
| - | - | - |
| [install_docker](whisperpine/ansitofu/roles/install_docker/) | Install docker engine, CLI, containerd, and docker compose. | Yes |
| [consul](whisperpine/ansitofu/roles/consul/) | Deploy a HashiCorp Consul cluster. | Yes |
| [mongodb](whisperpine/ansitofu/roles/mongodb/) | Deploy replica set (primary/secondary/arbiter) with backups. | Yes |
| [registry](whisperpine/ansitofu/roles/registry/) | Self-signed private Docker registry trusted by all hosts. | |
| [gitea](whisperpine/ansitofu/roles/gitea/) | Run Gitea via docker compose behind a Cloudflare Tunnel. | |
| [pocketid](whisperpine/ansitofu/roles/pocketid/) | Run Pocket ID via Docker Compose behind a Cloudflare Tunnel. | |
| [ncat_listen](whisperpine/ansitofu/roles/ncat_listen/) | systemd template unit for on-demand `ncat` listeners. | Yes |
| [etc_monitor](whisperpine/ansitofu/roles/etc_monitor/) | Watch "/etc" for changes and email root. | Yes |
| [sshd_configs](whisperpine/ansitofu/roles/sshd_configs/) | Harden `sshd` (e.g. disable password authentication). | Yes |

## Getting Started

Install the collection from Ansible Galaxy:

```sh
ansible-galaxy collection install whisperpine.ansitofu
```

Or declare it in a "requirements.yml":

```yaml
collections:
  - name: whisperpine.ansitofu
    version: ">=0.10.2"
```

Then reference any role by its fully qualified collection name:

```yaml
- hosts: all
  roles:
    - whisperpine.ansitofu.install_docker
```

Refer to each role's README for the variables it accepts.

## Testing

Roles are covered by [Molecule](https://github.com/ansible/molecule)
scenarios that run inside Docker containers
(See [molecule/README.md](whisperpine/ansitofu/extensions/molecule/README.md)).

```sh
just test SCENARIO
```

Directory [infra/](/infra/README.md) provisions disposable AWS EC2 nodes with OpenTofu
to test these roles end to end.

## Development

Dev environment is managed by [Direnv](https://github.com/direnv/direnv) and Nix Flake (See [flake.nix](./flake.nix)).
Run the following command once to get every required tool
(e.g ansible, molecule, just, sops, opentofu):

```sh
direnv allow
```

Secrets are encrypted by ansible-vault and [sops](https://github.com/getsops/sops).

- "encrypted.env" and "infra/encrypted.default.json" are managed by sops.
- "inventories/group_vars/all.yml" is encrypted by ansible-vault.

The common tasks are wrapped by [just](https://github.com/casey/just).
List all subcommands by running `just --list`.
