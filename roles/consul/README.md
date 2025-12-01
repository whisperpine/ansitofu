# Anisble Role "consul"

This role deploys a consul cluster.

## Automated Tests

Please refer to [molecule/README.md](../../molecule/README.md).

## End-to-end Test

After the "consule" role applied to the hosts,
`ssh` to any one of the hosts to run the following command:

```sh
consul members
```

It's expected to see something like this:

<!-- markdownlint-disable MD013 -->
```txt
Node          Address          Status  Type    Build   Protocol  DC   Partition  Segment
65f82a99cf8c  172.19.0.2:8301  alive   server  1.22.1  2         dc1  default    <all>
d6e5579f4f51  172.19.0.4:8301  alive   server  1.22.1  2         dc1  default    <all>
df162d1210a7  172.19.0.3:8301  alive   server  1.22.1  2         dc1  default    <all>
```
<!-- markdownlint-enable MD013 -->

Now let's see what happens if one consul server is in outage.
Stop one of the virtual machines (e.g. "node_1") and `ssh` to any of the alive node:

```sh
consul members
```

It's expected to see something like this (Notice the Status of one node is "left"):

<!-- markdownlint-disable MD013 -->
```txt
Node           Address          Status  Type    Build   Protocol  DC   Partition  Segment
ip-10-1-2-10   10.1.2.10:8301   left    server  1.22.1  2         dc1  default    <all>
ip-10-1-29-84  10.1.29.84:8301  alive   server  1.22.1  2         dc1  default    <all>
ip-10-1-40-40  10.1.40.40:8301  alive   server  1.22.1  2         dc1  default    <all>
```
<!-- markdownlint-enable MD013 -->
