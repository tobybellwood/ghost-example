#!/bin/sh
set -eu
echo "Waiting until ${MARIADB_HOST:-mariadb} is ready"
until nc -vzw5 "${MARIADB_HOST:-mariadb}" 3306; do
    sleep 1
done
