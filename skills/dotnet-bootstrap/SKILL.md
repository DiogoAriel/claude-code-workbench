---
name: dotnet-bootstrap
description: Conventions for starting or auditing a .NET solution the way this person builds them (clean architecture, central packages, warnings as errors, analyzers, tests without Docker). Use when creating a new .NET project, adding a project to a solution, or asked to "set up", "scaffold" or "review the structure" of a .NET codebase.
---

# .NET bootstrap

## Solution layout

```
<Name>.sln
Directory.Build.props        # shared: net8.0 (or current LTS), nullable, implicit usings, warnings as errors, analyzers
Directory.Packages.props     # central package management; the only place versions live
global.json                  # pinned SDK with rollForward latestFeature
.editorconfig                # file-scoped namespaces, var, braces, _camelCase private fields
.gitattributes / .gitignore  # _local/, bin/, obj/, *.db, .env
src/
  <Name>.Domain              # entities, value objects, domain services, integration events. No package references.
  <Name>.Application         # commands/queries, validators, ports (interfaces), DI registration by scanning
  <Name>.Infrastructure      # EF Core, repositories, unit of work, outbox, message publishers
  <Name>.Api                 # minimal APIs, error mapping, auth, logging, tracing, health checks, Dockerfile
tests/
  <Name>.UnitTests           # domain and handlers with in-memory ports
  <Name>.IntegrationTests    # WebApplicationFactory over SQLite in memory; no containers required
deploy/                      # helm chart, terraform, otel collector
docs/                        # architecture.md and adr/
```

## Non-negotiable settings (Directory.Build.props)

```xml
<TreatWarningsAsErrors>true</TreatWarningsAsErrors>
<EnableNETAnalyzers>true</EnableNETAnalyzers>
<AnalysisLevel>latest-recommended</AnalysisLevel>
<ManagePackageVersionsCentrally>true</ManagePackageVersionsCentrally>
<Nullable>enable</Nullable>
```

NuGet audit is on by default in SDK 8+: a package with a known vulnerability fails the build. That is
intended. Fix by upgrading, never by suppressing.

## Patterns

- **Persistence model separate from the domain.** Records mirror tables; repositories map to domain
  objects; domain types expose `Rehydrate` for persistence only. Keeps value objects, private setters
  and provider workarounds out of the domain.
- **Unit of work = one `SaveChanges`.** State change, audit record and outbox message in one transaction.
- **Idempotency by caller reference**, enforced in the handler and by a unique index.
- **Optimistic concurrency** with a version column mapped as a concurrency token; map
  `DbUpdateConcurrencyException` to HTTP 409.
- **Errors are a contract:** 400 validation, 404 missing, 409 concurrency, 422 business rule, 500
  everything else, all as RFC 7807 problem details with a trace id.
- **Observability by default:** Serilog compact JSON, OpenTelemetry traces and metrics over OTLP,
  `/health/live` and `/health/ready`.

## Known traps

- `WebApplicationFactory`: settings read in `Program.cs` at build time must be passed with
  `builder.UseSetting(key, value)`; `ConfigureAppConfiguration` is applied too late for them.
- SQLite cannot `ORDER BY` or compare `DateTimeOffset`; apply `DateTimeOffsetToBinaryConverter`
  when `Database.IsSqlite()` (all timestamps UTC).
- `dotnet ef ... -c Release` means `--context Release`; use `--configuration Release`.
- Newer OpenTelemetry packages require Microsoft.Extensions.* 9/10 even on net8.0; pin those
  abstractions centrally to the newer version.
- FluentAssertions 8+ changed license; stay on 7.x unless the project has a license.

## Commands

```bash
dotnet new sln -n <Name>
dotnet sln add src/**/*.csproj tests/**/*.csproj
dotnet build <Name>.sln -c Release
dotnet test  <Name>.sln -c Release --collect:"XPlat Code Coverage"
dotnet ef migrations add <Migration> --project src/<Name>.Infrastructure --startup-project src/<Name>.Api --configuration Release
```
