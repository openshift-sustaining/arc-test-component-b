# arc-test-component-b

## Known Vulnerabilities

- CVE-2026-33186 In Modules: `sub-a`
- CVE-2024-45339 In Modules: `.`, `sub-a`, `sub-b`

## Branch Info

| Property | Value |
|---|---|
| Go Version | 1.22 |
| grpc | v1.64.0 in `sub-a` (vulnerable) |
| Module Structure | Multi-module (`.`, `sub-a`, `sub-b`) |
| Expected ARC Behavior | Fork/patch (`v1.71.x-sec.1` for Go 1.22) only in `sub-a` |
