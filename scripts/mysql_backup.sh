#!/bin/bash
# Backup RDS MySQL and upload to S3

# Setup variables
DB_HOST="$1"      # RDS endpoint
DB_USER="$2"      # Username
DB_PASS="$3"      # Password
DB_NAME="$4"      # Database name
S3_BUCKET="$5"    # Bucket name

DATE=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="/tmp/${DB_NAME}_backup_${DATE}.sql.gz"

# Create backup
mysqldump -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" | gzip > "$BACKUP_FILE"

if [ $? -eq 0 ]; then
  echo "Backup successful, uploading to S3..."
  aws s3 cp "$BACKUP_FILE" "s3://$S3_BUCKET/backups/"
  if [ $? -eq 0 ]; then
    echo "Upload successful."
    rm "$BACKUP_FILE"
  else
    echo "Upload to S3 failed!"
  fi
else
  echo "Backup failed!"
fi 