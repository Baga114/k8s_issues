#!/bin/bash

BACKUP_DIR="/root/backups_DB/$(date --iso)"

# Create a directory for database backups
mkdir -p "$BACKUP_DIR"

# List databases excluding system databases
mysql -e "show databases" | grep -v -E "^Database|information_schema|performance_schema|phpmyadmin" > "$BACKUP_DIR/dblist.txt"

# Move to the backup directory
cd "$BACKUP_DIR" || exit

# Loop through each database and perform a mysqldump
while read -r database; do
  mysqldump "$database" > "$database-db-bak-$(date +%F).sql"
done < "$BACKUP_DIR/dblist.txt"

# Create a tar archive containing SQL backup files
tar czvf "/root/backups_DB/db_backups-$(date --iso).tar.gz" *.sql

# Transfer the tar archive to the remote server
REMOTE_SERVER="root@belbackup.010-101.com"
REMOTE_PORT="3222"
scp -P "$REMOTE_PORT" "/root/backups_DB/db_backups-$(date --iso).tar.gz" "$REMOTE_SERVER:/home/backups/webserver5/DB_Backups/"

# Remove local backup files
rm -rf /root/backups_DB/*

