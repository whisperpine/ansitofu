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

# install roles and collections defined in requirements.yml
[group("ansible")]
install:
  ansible-galaxy role install -r requirements.yml
  ansible-galaxy collection install -r requirements.yml

# --------------------
# molecule
# --------------------

# run "molecule test" with the given SCENARIO
[group("molecule")]
test SCENARIO:
  molecule test --scenario-name {{SCENARIO}} --report --command-borders

# run "molecule converge" with the given SCENARIO
[group("molecule")]
converge SCENARIO:
  molecule converge --scenario-name {{SCENARIO}} --report --command-borders

# run "molecule verify" with the given SCENARIO
[group("molecule")]
verify SCENARIO:
  molecule verify --scenario-name {{SCENARIO}} --report --command-borders
