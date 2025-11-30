# Automated Tests by Molecule

[Molecule](https://github.com/ansible/molecule) is a test framework for Ansible.
Ansible roles are tested by molecule in this repository.

## Prerequisites

- Make sure these tools are locally installed: docker, ansible, molecule, python.
- It also requires that the Python library (e.g. "requests") on the local machine.

## Get Started

It's recommended to use the `just` command for less keystrokes (refer to [justfile](../justfile)):

```sh
just test SCENARIO  # test a given scenario
just test common    # e.g. test the "common" scenario
```

You can also use the `molecule test` command to run scenarios (test cases):

```sh
# Run the following comment to test a given scenario.
molecule test -s SCENARIO --report --command-borders
# For example, test the "common" scenario.
molecule test -s common --report --command-borders
```

To speed up testing, feel free to run multiple scenarios in parallel.

## Inventory

The inventory used and shared by all scenarios the same as the [the real inventory](../inventories/inventory.yml).

The purpose is to mimic the real-world use cases with minimal disparities:

- the real inventory are Virtual Machines which are connected by SSH.
- the inventory used by molecule are docker containers (ansible_connection: docker).

The trade-off is to tolerate some disparities to gain the convenience of
hosts as containers:

- Much faster to spin up and tear down.
- Easier to setup locally as well as in CI/CD.
