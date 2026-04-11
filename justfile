# --------------------
# utility
# --------------------

# list all available subcommands
[group("utility")]
_default:
  @just --list

# --------------------
# ansible
# --------------------

# run ansible-playbook with a given playbook (default: ./playbooks/site.yml)
[group("ansible")]
play BOOK="site":
  ansible-playbook \
    -i ./inventories/inventory.yml \
    ./playbooks/{{BOOK}}.yml

# output all hosts info in "inventories/inventory.yml"
[group("ansible")]
inventory:
  ansible-inventory \
    -i inventories/inventory.yml \
    --list

# --------------------
# molecule
# --------------------

# run "molecule test" with the given SCENARIO
[group("molecule")]
[working-directory: "whisperpine/ansitofu"]
test SCENARIO:
  molecule test --scenario-name {{SCENARIO}} --report --command-borders

# run "molecule converge" with the given SCENARIO
[group("molecule")]
[working-directory: "whisperpine/ansitofu"]
converge SCENARIO:
  molecule converge --scenario-name {{SCENARIO}} --report --command-borders

# run "molecule verify" with the given SCENARIO
[group("molecule")]
[working-directory: "whisperpine/ansitofu"]
verify SCENARIO:
  molecule verify --scenario-name {{SCENARIO}} --report --command-borders
