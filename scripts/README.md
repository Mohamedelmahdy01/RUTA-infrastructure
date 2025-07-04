# MySQL RDS Backup Script

## Usage

```bash
bash mysql_backup.sh <DB_HOST> <DB_USER> <DB_PASS> <DB_NAME> <S3_BUCKET>
```

Example:
```bash
bash mysql_backup.sh ruta-db.xxxxx.eu-central-1.rds.amazonaws.com admin mypassword ruta_db ruta-frontend-bucket
```

## Scheduling (Cron)
To create a daily backup at 2 AM:

```
0 2 * * * /bin/bash /path/to/mysql_backup.sh <DB_HOST> <DB_USER> <DB_PASS> <DB_NAME> <S3_BUCKET>
```

## Requirements
- awscli
- mysqldump 