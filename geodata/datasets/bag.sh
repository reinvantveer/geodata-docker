#!/usr/bin/env bash

set -ex

psql --dbname="geodata" <<-'EOSQL'
  CREATE EXTENSION IF NOT EXISTS POSTGIS;
  CREATE USER kademo;
  ALTER DATABASE geodata OWNER TO kademo;
EOSQL

echo "BAG database restore procedure started, wait for completion to connect to the database..."
time pg_restore \
  --host=localhost \
  --port=5432 \
  --username=postgres \
  --dbname=geodata \
  --jobs=$(nproc) \
  --no-password \
  --verbose \
  "./bag.backup"
echo "BAG database restore procedure succeeded, you may now connect to the database."
