# Anisble Role "install_docker"

This role installs docker ecosystem (containerd, docker client, docker server
and docker-compose). But it's not intended for installing apps.

## Automated Tests

Please refer to [molecule/README.md](../../molecule/README.md).

## End-to-end Test

Assume that the role is executed successfully.

`ssh` to any host, and run the following command:

```sh
docker --version
docker compose version
```
