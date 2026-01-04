#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
COMPOSE_FILE="$SCRIPT_DIR/../docker/docker-compose.yml"
SERVICE="mssql"
SA_PASSWORD="YourStrong!Passw0rd"

run_sql() {
  docker compose -f "$COMPOSE_FILE" exec -T "$SERVICE" \
    /opt/mssql-tools18/bin/sqlcmd -C -S localhost -U sa -P "$SA_PASSWORD" "$@"
}

if ! docker compose -f "$COMPOSE_FILE" ps --status running --services | grep -q "^$SERVICE$"; then
  echo "Service '$SERVICE' is not running. Start it with:"
  echo "  (cd db-modernize/docker && docker compose up --build)"
  exit 1
fi

echo "Databases:"
run_sql -Q "SELECT name, compatibility_level FROM sys.databases;"

echo "\nObject counts in NewDB1:"
run_sql -d NewDB1 -Q "SELECT (SELECT COUNT(*) FROM sys.tables) AS tables, (SELECT COUNT(*) FROM sys.views) AS views, (SELECT COUNT(*) FROM sys.procedures) AS procedures;"

echo "\nTables without primary keys (schema.table):"
run_sql -d NewDB1 -Q "SELECT CONCAT(s.name, '.', t.name) AS table_name FROM sys.tables t JOIN sys.schemas s ON s.schema_id = t.schema_id LEFT JOIN sys.key_constraints kc ON kc.parent_object_id = t.object_id AND kc.type = 'PK' WHERE kc.name IS NULL ORDER BY table_name;"