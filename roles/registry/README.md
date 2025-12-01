# Anisble Role "registry"

Setup local docker registry with self-signed certificate.

It requires docker with docker compose plugin already installed in the managed nodes.
Therefore, it's recommended to install docker by the [install_docker](../install_docker/)
ansible role before running this role.

## Design

Spin up the registry service on one host, and let all hosts to trust and use it.

## The Approach

- Generate a self-signed certificate on *one host* ("node_1" is used here).
- Copy the certificate to *all hosts* and make it trusted by docker daemon.
- Spin up the registry service by docker compose on *one host* ("node_1").
- Modify the "/etc/hosts" file on *all hosts* resolving to the IP of the registry.

```yaml
# ./defaults/main.yml
registry_ip: "{{ hostvars['node_1'].ansible_default_ipv4.address }}"
```

## Prerequisites

Please make sure that:

- All hosts can see each other (e.g. in the same subnet, or have public IPs).
- The "node_1" allows inbound to 5000 TCP port (e.g. firewall, security group).

## End-to-end Test

Assume that the role is executed successfully.

`ssh` to any host, and run the following command:

```sh
# It's expected to receive "{}".
curl https://registry.local:5000/v2/ --cacert /etc/docker/certs.d/registry.local:5000/ca.crt
```

Run the following commands to test with the docker commands:

```sh
sudo docker pull alpine
sudo docker tag alpine registry.local:5000/alpine
sudo docker push registry.local:5000/alpine
```

Also consider `ssh` to another node and run the following command:

```sh
sudo docker pull registry.local:5000/alpine
```
