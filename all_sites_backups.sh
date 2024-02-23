#!/bin/bash

SHELL=/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Define the backup directory
BACKUP_DIR="/root/backups/BACKUPS_$(date +%Y-%m-%d)"
mkdir -p "$BACKUP_DIR"
cd "$BACKUP_DIR"

# Backup all domains in /home
for site_dir in /home/*; do
    if [ -d "$site_dir" ]; then
        site_name=$(basename "$site_dir")
        tar zcvf "$site_name-$(date +%Y-%m-%d).tar.gz" "$site_dir"
    fi
done

# Transfer backup files to remote server
REMOTE_SERVER="root@belbackup.010-101.com"
REMOTE_PORT="3222"
scp -P "$REMOTE_PORT" -r "$BACKUP_DIR" "$REMOTE_SERVER:/home/backups/webserver5/File_Backups/"

# Remove local backup files
rm -rf "$BACKUP_DIR"
