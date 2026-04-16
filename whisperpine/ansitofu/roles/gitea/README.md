# Anisble Role "gitea"

Deploy [gitea](https://github.com/go-gitea/gitea) by docker.

It requires docker with docker compose plugin already installed in the managed nodes.
Therefore, it's recommended to install docker by the [install_docker](../install_docker/)
ansible role before running this role.

## The Approach

The core is the "gitea" service declared in [compose.yaml](./files/compose.yaml).
To expose the service to the internet safely (and in cases where the server
doesn't have a public ip), [Cloudflare Tunnel](https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/)
is applied as a sidecar.

## Networking

The default http port of "gitea" is `3000`.

Both services "cloudflared" and "gitea" are in the same docker network. The
"cloudflared" service is responsible for redirecting requests to "gitea".
Hence there's no need to expose ports in "compose.yaml". Rather, you have to add
the route `http://gitea:3000` to the corresponding Cloudflare Tunnel.

## Post-setup

If gitea is deployed the first time, modify the
`gitea_allow_only_external_registration` and `gitea_enable_password_signin_form`
variables to allow admin user registration. These two ansible variables are
directly used by `ALLOW_ONLY_EXTERNAL_REGISTRATION` and
`ENABLE_PASSWORD_SIGNIN_FORM` in [app.ini.j2](./templates/app.ini.j2).

## Backup and Restore

### Backup

To backup, just archive the `gitea-data` volume declared in [compose.yaml](./files/compose.yaml).

Run the following command in the working directory ("/opt/gitea" by default):

```sh
# Stops the gitea container before backup.
docker compose down gitea

# Backs up gitea with the help of busybox.
docker compose run --rm busybox \
    tar czf /backup/gitea-data-$(date --utc +%Y%m%d).tar.gz var/lib/gitea/

# Starts the gitea container after backup.
docker compose up -d gitea
```

### Restore

To restore, just extract the archive to the gitea's data directory ("/var/lib/gitea").

Run the following command in the working directory ("/opt/gitea" by default):

```sh
# Stops the gitea container before backup.
docker compose down gitea

# Extracts gitea's data directory to restore.
# (Assume that the "gitea-data.tar.gz" file exists.)
docker compose run --rm busybox \
  tar xf /backup/gitea-data.tar.gz

# Starts the gitea container after backup.
docker compose up -d gitea
```
