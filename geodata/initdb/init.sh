#!/usr/bin/env bash

set -ex

# Perform all actions as $POSTGRES_USER
export PGUSER="$POSTGRES_USER"

echo "max_wal_size = 2GB" >> /var/lib/postgresql/data/postgresql.conf

# Create the 'template_postgis' template db
"${psql[@]}" <<- 'EOSQL'
CREATE DATABASE template_postgis;
UPDATE pg_database SET datistemplate = TRUE WHERE datname = 'template_postgis';
EOSQL

# Load PostGIS into both template_database and $POSTGRES_DB
for DB in template_postgis "$POSTGRES_DB"; do
	echo "Loading PostGIS extensions into $DB"
	"${psql[@]}" --dbname="$DB" <<-'EOSQL'
		CREATE EXTENSION IF NOT EXISTS postgis;
		CREATE EXTENSION IF NOT EXISTS postgis_topology;
		CREATE EXTENSION IF NOT EXISTS fuzzystrmatch;
		CREATE EXTENSION IF NOT EXISTS postgis_tiger_geocoder;
EOSQL
done

createdb geodata -U postgres --no-password

IFS=',' read -r -a GDS <<< "$GEODATASETS"

for dataset in ${GDS[@]}; do
  bash /datasets/${dataset}.sh
done