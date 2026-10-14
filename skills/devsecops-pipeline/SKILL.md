---
name: devsecops-pipeline
description: Add or review a security pipeline (secret detection, SAST, dependency and container scanning, IaC checks, SBOM) on GitHub Actions or GitLab CI, with findings that fail the build. Use when asked to "add security to the pipeline", "set up CI", or review a workflow.
---

# DevSecOps pipeline

Every control runs on every change. A control that only warns is decoration.

## Controls and the tool for each

| Control | Tool | Fail on |
|---|---|---|
| Secret detection | gitleaks (full history on first run) | any finding |
| SAST | semgrep with the language ruleset + `p/secrets` + `p/owasp-top-ten` | findings |
| Dependency vulnerabilities | trivy `fs` (plus NuGet/npm audit at build time) | HIGH, CRITICAL, fixable |
| SBOM | syft / trivy in CycloneDX; attach as artifact | — |
| Infrastructure as code | checkov on Terraform, Helm, Dockerfile, Kubernetes manifests | failed checks |
| Container image | trivy `image` after build; SARIF to code scanning | HIGH, CRITICAL, fixable |
| DAST (when a deployable exists) | OWASP ZAP baseline against a review environment | medium+ |

Run the cheap controls (secrets, SAST) before building the image; the image scan depends on them.

## Rules of the pipeline

- Pin action and image versions; renovate them with Dependabot or Renovate, weekly.
- `permissions:` at the top of every workflow, least privilege (`contents: read` by default).
- Secrets only from the CI secret store. A pipeline that needs a secret to lint is wrong.
- A weekly scheduled run catches new CVEs in unchanged code.
- Findings go to the platform's code scanning (SARIF) so they are visible in the PR, not in a log.
- Exceptions are explicit: an ignore file with the finding id, the reason and an expiry date.

## Verifying the pipeline itself

Plant a secret in a branch and confirm the pipeline turns red. Remove it. A control that has never
failed has never been proven to work. Record the check in `_local/history/`.

## Templates

`templates/github-security.yml` and `templates/gitlab-ci.yml` in this repository are copies of the
workflows used in the payments-ledger-platform reference project; adjust the language rulesets and
the paths.
