# list all available subcommands
_default:
  @just --list

# find vulnerabilities and misconfigurations by trivy
trivy:
  trivy fs --skip-dirs "./target" .
  trivy config .
