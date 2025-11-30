# Anisble Role "ncat_listen"

Create a systemd template unit `ncat@.service` so you can start listeners like:

```sh
sudo systemctl start ncat@10000.service
```

## The Approach

There should be a template file "/etc/systemd/system/ncat@.service".

A new service should be created based on the template after running the command:

```sh
sudo systemctl start ncat@12345.service
```

There're also default services created automatically by this ansible role.
Defined in [./defaults/main.yml](./defaults/main.yml):

```yaml
# Ports to enable/start listed ports automatically.
ncat_listen_ports: [10000, 10001]
```

## Automated Tests

Please refer to [molecule/README.md](../../molecule/README.md).

## End-to-end Test

After the "ncat_listen" role applied to the hosts,
`ssh` to any one of the hosts to run the following command:

```sh
# List all running systemd units whose name contains "ncat".
systemctl list-units --type=service --state=running | grep ncat
```

It's expected to see something like this:

```txt
ncat@10000.service          loaded active running ncat listener on port 10000
ncat@10001.service          loaded active running ncat listener on port 10001
```

To test if the port is being listened at, run the following command:

```sh
ncat -vz localhost 10000
```

It's expected to see something like this:

```txt
Ncat: Version 7.80 ( https://nmap.org/ncat )
Ncat: Connected to ::1:10000.
Ncat: 0 bytes sent, 0 bytes received in 0.03 seconds.
```

Now let's try to start a new service based on the template:

```sh
# For example, port "12345" is used here.
sudo systemctl start ncat@12345.service
# List all running systemd units whose name contains "ncat".
systemctl list-units --type=service --state=running | grep ncat
```

It's expected to see something like this (notice that `ncat@12345.service` is added):

```txt
ncat@10000.service          loaded active running ncat listener on port 10000
ncat@10001.service          loaded active running ncat listener on port 10001
ncat@12345.service          loaded active running ncat listener on port 12345
```
