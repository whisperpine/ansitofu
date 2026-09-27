# Ansitofu

[![GitHub License](https://img.shields.io/github/license/whisperpine/ansitofu)](https://github.com/whisperpine/ansitofu/blob/main/LICENSE)
[![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/whisperpine/ansitofu/checks.yml?logo=github&label=checks)](https://github.com/whisperpine/ansitofu/actions/workflows/checks.yml)
[![GitHub deployments](https://img.shields.io/github/deployments/whisperpine/ansitofu/infra-default?logo=github&label=deployment)](https://github.com/whisperpine/ansitofu/deployments/infra-default)
[![GitHub Release](https://img.shields.io/github/v/release/whisperpine/ansitofu?logo=github)](https://github.com/whisperpine/ansitofu/releases)
![Ansible Collection Version](https://img.shields.io/ansible/collection/v/whisperpine/ansitofu?logo=ansible)

Ansitofu is a personal Ansible collection, `whisperpine.ansitofu`, of reusable
roles for configuring self-hosted services on Debian/Ubuntu hosts. Roles are
integration-tested with Molecule in CI and published to Ansible Galaxy.

Scope: `infra/` provisions throwaway AWS EC2 nodes with OpenTofu purely to
exercise these roles end to end. It is a test bed, not a production
environment. See [infra/README.md](./infra/README.md).

## Roles

| Role | Purpose | Molecule |
| - | - | - |
| [`install_docker`](whisperpine/ansitofu/roles/install_docker/) | Install the Docker engine, CLI, containerd, and Compose plugin. | Yes |
| [`consul`](whisperpine/ansitofu/roles/consul/) | Deploy a 3-server Consul cluster. | Yes |
| [`mongodb`](whisperpine/ansitofu/roles/mongodb/) | 3-member replica set (primary/secondary/arbiter) with backups. | Yes |
| [`registry`](whisperpine/ansitofu/roles/registry/) | Self-signed private Docker registry trusted by all hosts. | No |
| [`gitea`](whisperpine/ansitofu/roles/gitea/) | Run Gitea via Docker Compose behind a Cloudflare Tunnel. | No |
| [`pocketid`](whisperpine/ansitofu/roles/pocketid/) | Run Pocket ID via Docker Compose behind a Cloudflare Tunnel. | No |
| [`ncat_listen`](whisperpine/ansitofu/roles/ncat_listen/) | systemd template unit for on-demand `ncat` listeners. | Yes |
| [`etc_monitor`](whisperpine/ansitofu/roles/etc_monitor/) | Watch `/etc` for changes and email root. | Yes |
| [`sshd_configs`](whisperpine/ansitofu/roles/sshd_configs/) | Harden `sshd` (disable password authentication). | Yes |

## Quickstart

Install the collection from Ansible Galaxy:

```sh
ansible-galaxy collection install whisperpine.ansitofu
```

Or declare it in a `requirements.yml`:

```yaml
collections:
  - name: whisperpine.ansitofu
```

Then reference any role by its fully qualified collection name:

```yaml
- hosts: all
  roles:
    - whisperpine.ansitofu.install_docker
```

Refer to each role's README for the variables it accepts.

## Testing

Role behaviour is covered by
[Molecule](https://github.com/ansible/molecule) scenarios that run inside
Docker containers. The active scenarios are `consul`, `mongodb`,
`install_docker`, `ncat_listen`, `etc_monitor`, and `sshd_configs`.

```sh
just test consul      # run the full test sequence
just converge consul  # apply and keep the containers running
just verify consul    # run the assertions only
```

See
[molecule/README.md](whisperpine/ansitofu/extensions/molecule/README.md)
for details.

## Development

Use the Nix flake to get every required tool (`ansible`, `molecule`, `just`,
`sops`, `opentofu`, and more):

```sh
direnv allow   # or: nix develop
```

Secrets are encrypted: `encrypted.env` is managed by sops with age, and
`inventories/group_vars/all.yml` is ansible-vault encrypted.

The common tasks are wrapped by `just`:

```sh
just --list         # list all available recipes
just inventory      # output all hosts in the inventory
just play site      # run ./playbooks/site.yml
just test consul    # run a Molecule scenario
```
