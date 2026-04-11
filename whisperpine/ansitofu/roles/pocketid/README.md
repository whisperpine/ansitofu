# Anisble Role "pocketid"

Deploy [pocket-id](https://github.com/pocket-id/pocket-id) by docker.

It requires docker with docker compose plugin already installed in the managed nodes.
Therefore, it's recommended to install docker by the [install_docker](../install_docker/)
ansible role before running this role.

## The Approach

The core is the "pocket-id" service declared in [compose.yaml](./files/compose.yaml).
To expose the service to the internet safely (and in cases where the server
doesn't have a public ip), [Cloudflare Tunnel](https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/)
is applied as a sidecar.

## Networking

The default port of "pocket-id" is `1411`.

Both services "cloudflared" and "pocket-id" are in the same docker network. The
"cloudflared" service is responsible for redirecting requests to "pocket-id".
Hence there's no need to expose ports in "compose.yaml". Rather, you have to add
the route `http://pocket-id:1411` to the corresponding Cloudflare Tunnel.

## Post-setup

Right after the deployment, visit `https://MY_DOMAIN/setup` to register the
admin account. Notice that only (the first) one admin account can be signed up
this way.

## Backup and Restore

Since the "/app/data" directory inside the "pocket-id" container is mapped to
"./data" locally in "compose.yaml", you can simply backup and restore by
manipulating the "./data" local directory (especially "./data/pocket-id.db").

## Remarks

If your DNS server is Cloudflare, make sure that
"Rocket Loader" is disabled, otherwise you'll get a blank page.
Find the config in: Speed / Settings / Content Optimization / Rocket Loader.
