# ADR Tag Conventions

Tags classify decisions for cross-referencing during sprint scope (G0).

## Default Tags (override in profile.yaml)

```yaml
decisions:
  tags: [arch, build, test, dx, security, api, data, infra]
```

## Tag Semantics

| Tag | Scope |
|-----|-------|
| arch | System design, boundaries, interfaces |
| build | Build tooling, CI/CD, bundling |
| test | Test strategy, coverage, frameworks |
| dx | Developer experience, conventions |
| security | Auth, secrets, vulnerabilities |
| api | API design, contracts, versioning |
| data | Data modeling, storage, migrations |
| infra | Deployment, hosting, monitoring |

## Custom Tags

Projects define domain-specific tags in `.anvil/profile.yaml`.
Sprint G0 greps decisions by tag to find relevant prior decisions.
