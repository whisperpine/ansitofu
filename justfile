# find vulnerabilities and misconfigurations by trivy
trivy:
  trivy fs --skip-dirs "./target" .
  trivy config .
