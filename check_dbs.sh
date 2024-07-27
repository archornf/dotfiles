#!/usr/bin/env bash

read -p "Enter MySQL user: " MYSQL_USER
read -sp "Enter MySQL password: " MYSQL_PASSWORD
echo ""
read -p "Enter MySQL host (default: localhost): " MYSQL_HOST
MYSQL_HOST=${MYSQL_HOST:-localhost}
read -p "Enter MySQL port (default: 3306): " MYSQL_PORT
MYSQL_PORT=${MYSQL_PORT:-3306}

# Databases to check
databases=("acore_world" "world" "vmangos_mangos")

# Function to check if a database exists
check_database_exists() {
    local db_name=$1
    result=$(mysql -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" -h"$MYSQL_HOST" -P"$MYSQL_PORT" -e "SHOW DATABASES LIKE '$db_name';" 2>/dev/null)
    if [[ "$result" == *"$db_name"* ]]; then
        echo "Database $db_name exists."
    else
        echo "Database $db_name does not exist."
    fi
}

for db in "${databases[@]}"; do
    check_database_exists "$db"
done

