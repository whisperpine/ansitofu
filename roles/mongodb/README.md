# Ansible Role "mongodb"

Setup MongoDB cluster consisting of 3 members: 1 primary, 1 secondary, 1 arbiter.

Implement MongoDB backup script. It should be run on a secondary member of the
replication set. Restrict access to the MongoDB to replication set members only.

## Automated Tests

Please refer to [molecule/README.md](../../molecule/README.md).

## End-to-End Test

### MongoDB Replica Set

After the "mongodb" role applied to the hosts,
`ssh` to any one of the hosts to run the following command:

```sh
mongosh --eval 'rs.status()' | grep stateStr
```

It's expected to see this output:

```txt
stateStr: 'PRIMARY',
stateStr: 'SECONDARY',
stateStr: 'ARBITER',
```

You can also insert a document in one node and read from another node.\
IMPORTANT: run the following commands on different nodes:

```sh
# Insert a document in the "rs_test" collection on the primary (node_1).
mongosh --eval 'db.rs_test.insertOne({ msg: "replica test", ts: new Date() })'
# Read all documents in the "rs_test" collection on the secondary (node_2).
mongosh --eval 'db.rs_test.find()'
```

### MongoDB Backup

Now let's move on to the backup. `ssh` to the *secondary* replica (node_2) and run:

```sh
ls /var/backups/mongodb
```

It's expected to see something like this:

```txt
2025-11-27_222343
```

### MongoDB Failover

Now let's see the failover behavior - what happens if the primary replica is in outage.

Manually stop the *primary* replica (e.g. just stop the VM)
and `ssh` to "node_2" run the following command:

```sh
mongosh --eval 'rs.status()' | grep stateStr
```

It's expected to see something like this (the previous PRIMARY is not reachable,
the previous SECONDARY now becomes PRIMARY):

```txt
stateStr: '(not reachable/healthy)',
stateStr: 'PRIMARY',
stateStr: 'ARBITER',
```
