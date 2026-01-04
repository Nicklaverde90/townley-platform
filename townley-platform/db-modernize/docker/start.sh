#!/bin/bash
set -euo pipefail
set +H   # disable bash history expansion so passwords with '!' work safely

/opt/mssql/bin/sqlservr &
sqlservr_pid=$!
trap "kill -TERM $sqlservr_pid" INT TERM

echo "Waiting for SQL Server startup..."
sleep 8
ready=0
for i in {1..120}; do
  if /opt/mssql-tools18/bin/sqlcmd -C -S localhost -U sa -P "$MSSQL_SA_PASSWORD" -Q "SELECT 1" >/dev/null 2>&1; then
    ready=1
    break
  fi
  sleep 2
  if ! kill -0 $sqlservr_pid >/dev/null 2>&1; then
    echo "sqlservr process exited unexpectedly" >&2
    wait $sqlservr_pid || true
    exit 1
  fi
done

if [ "$ready" -ne 1 ]; then
  echo "SQL Server did not become ready in time" >&2
  exit 1
fi

echo "Running init scripts..."
for script in /docker-init/*.sql; do
  [ -f "$script" ] || continue
  echo "Executing $(basename "$script")"
  /opt/mssql-tools18/bin/sqlcmd -C -S localhost -U sa -P "$MSSQL_SA_PASSWORD" -i "$script"
done

echo "Initialization complete."
wait $sqlservr_pid
