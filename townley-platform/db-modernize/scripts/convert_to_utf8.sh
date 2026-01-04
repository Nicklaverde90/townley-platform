#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
SRC="$ROOT_DIR/original/Townleyfulldatabaseschema.sql"
OUT="$ROOT_DIR/working/01_schema_utf8.sql"

mkdir -p "$(dirname "$OUT")"

if [ ! -f "$SRC" ]; then
  echo "Source dump $SRC not found" >&2
  exit 1
fi

iconv -f UTF-16LE -t UTF-8 "$SRC" > "$OUT"
sed -i 's/\r$//' "$OUT"

echo "Wrote UTF-8 copy to: $OUT"
