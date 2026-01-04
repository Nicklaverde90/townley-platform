<#
run-db.ps1
Townley Platform DB runner (SQL Server in Docker) + deploy + legacy parity check

Assumes SQL scripts live in:
  C:\Projects\townley-platform-main\townley-platform\db\sql

Mounts that folder into the container as:
  /scripts

Runs:
  1) /scripts/townley_deploy_end_to_end.sql
  2) /scripts/parity_legacy_full.sql  (against Townley_MySQL)

Exit codes:
  0 = success
  1 = failure
#>

param(
  [string]$SqlDir = "C:\Projects\townley-platform-main\townley-platform\db\sql",
  [string]$ContainerName = "townley_mssql",
  [string]$Image = "mcr.microsoft.com/mssql/server:2022-latest",
  [string]$DbName = "Townley_MySQL",
  [int]$HostPort = 1433,
  [int]$StartupTimeoutSeconds = 180,
  [switch]$RecreateContainer
)

# ----------------------------
# Helpers
# ----------------------------
function Write-Log {
  param([string]$Message)
  $ts = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
  $line = "[$ts] $Message"
  $line | Tee-Object -FilePath $LogFile -Append | Out-Host
}

function Fail {
  param([string]$Message)
  Write-Log "ERROR: $Message"
  exit 1
}

function Run-Docker {
  param([string[]]$DockerArgs)

  if (-not $DockerArgs -or $DockerArgs.Count -eq 0) {
    throw "Internal error: Run-Docker called with no arguments."
  }

  $out = & docker @DockerArgs 2>&1
  $out | Tee-Object -FilePath $LogFile -Append | Out-Host
  return $LASTEXITCODE
}

function Run-SqlFile {
  param(
    [string]$FileInContainer,
    [string]$Db = $null,
    [string]$Label = $FileInContainer
  )

  Write-Log "Running SQL: $Label"

  $dockerArgs = @(
    "exec", "-i", $ContainerName,
    "/opt/mssql-tools/bin/sqlcmd",
    "-S", "localhost",
    "-U", "sa",
    "-P", $SaPassword,
    "-b"  # -b => non-zero exit on SQL error
  )

  if ($Db) { $dockerArgs += @("-d", $Db) }
  $dockerArgs += @("-i", $FileInContainer)

  $code = Run-Docker -DockerArgs $dockerArgs
  if ($code -ne 0) { Fail "SQL step failed: $Label (exit $code)" }
}

# ----------------------------
# Logging setup
# ----------------------------
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$logDir = Join-Path $root "logs"
New-Item -ItemType Directory -Force -Path $logDir | Out-Null
$stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$LogFile = Join-Path $logDir "${stamp}_run-db.log"

Write-Log "=== Townley DB Runner START ==="
Write-Log "SqlDir: $SqlDir"
Write-Log "Container: $ContainerName"
Write-Log "Image: $Image"
Write-Log "DbName: $DbName"
Write-Log "HostPort: $HostPort"
Write-Log "StartupTimeoutSeconds: $StartupTimeoutSeconds"

# ----------------------------
# Validate Docker
# ----------------------------
& docker version *> $null
if ($LASTEXITCODE -ne 0) {
  Fail "Docker is not available. Install/Start Docker Desktop first."
}

# ----------------------------
# Load SA password
# ----------------------------
$SaPassword = $env:MSSQL_SA_PASSWORD
if ([string]::IsNullOrWhiteSpace($SaPassword)) {
  $sec = Read-Host "Enter MSSQL_SA_PASSWORD (input hidden)" -AsSecureString
  $SaPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
    [Runtime.InteropServices.Marshal]::SecureStringToBSTR($sec)
  )
}
if ($SaPassword.Length -lt 8) {
  Fail "MSSQL_SA_PASSWORD looks too short; SQL Server will reject weak passwords."
}

# ----------------------------
# Validate required files
# ----------------------------
$required = @(
  "townley_deploy_end_to_end.sql",
  "townley_core_schema_new.sql",
  "townley_core_compat_migration.sql",
  "townley_api_views_fastapi_exact.sql",
  "townley_db_roles_and_permissions.sql",
  "townley_schema_patch_nonbreaking.sql",
  "Townleyfulldatabaseschema.sql",
  "parity_legacy_full.sql"
)

if (-not (Test-Path $SqlDir)) {
  Fail "SqlDir not found: $SqlDir"
}

$missing = @()
foreach ($f in $required) {
  $p = Join-Path $SqlDir $f
  if (-not (Test-Path $p)) { $missing += $f }
}

if ($missing.Count -gt 0) {
  Fail ("Missing required SQL files in ${SqlDir}`n - " + ($missing -join "`n - "))
}

Write-Log "All required SQL files present."

# ----------------------------
# Container lifecycle
# ----------------------------
if ($RecreateContainer) {
  Write-Log "RecreateContainer set: removing existing container if present..."
  Run-Docker -DockerArgs @("rm", "-f", $ContainerName) | Out-Null
}

$exists = (& docker ps -a --format "{{.Names}}" | Select-String -SimpleMatch $ContainerName)
if (-not $exists) {
  Write-Log "Container not found. Creating and starting SQL Server container..."

  $mount = "${SqlDir}:/scripts:ro"

  $code = Run-Docker -DockerArgs @(
    "run", "-d",
    "--name", $ContainerName,
    "-e", "ACCEPT_EULA=Y",
    "-e", "MSSQL_SA_PASSWORD=$SaPassword",
    "-p", "$HostPort`:1433",
    "-v", $mount,
    $Image
  )
  if ($code -ne 0) { Fail "Failed to docker run SQL Server container." }
}
else {
  $running = (& docker ps --format "{{.Names}}" | Select-String -SimpleMatch $ContainerName)
  if (-not $running) {
    Write-Log "Container exists but not running. Starting..."
    $code = Run-Docker -DockerArgs @("start", $ContainerName)
    if ($code -ne 0) { Fail "Failed to start container $ContainerName" }
  }
}

# ----------------------------
# Wait for SQL Server readiness
# ----------------------------
Write-Log "Waiting for SQL Server to be ready (timeout ${StartupTimeoutSeconds}s)..."
$deadline = (Get-Date).AddSeconds($StartupTimeoutSeconds)

while ($true) {
  if ((Get-Date) -gt $deadline) {
    Fail "SQL Server did not become ready within ${StartupTimeoutSeconds}s."
  }

  & docker exec $ContainerName /opt/mssql-tools/bin/sqlcmd `
    -S localhost -U sa -P $SaPassword -Q "SELECT 1" -b 2>$null

  if ($LASTEXITCODE -eq 0) { break }
  Start-Sleep -Seconds 2
}

Write-Log "SQL Server is ready."

# ----------------------------
# Run deployment + parity
# ----------------------------
Run-SqlFile -FileInContainer "/scripts/townley_deploy_end_to_end.sql" -Label "Deploy End-to-End"
Run-SqlFile -FileInContainer "/scripts/parity_legacy_full.sql" -Db $DbName -Label "Full Legacy Parity Check"

Write-Log "SUCCESS - DB deployed and legacy parity check completed."
exit 0
