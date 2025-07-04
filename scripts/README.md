# MySQL RDS Backup Script

## الاستخدام

```bash
bash mysql_backup.sh <DB_HOST> <DB_USER> <DB_PASS> <DB_NAME> <S3_BUCKET>
```

مثال:
```bash
bash mysql_backup.sh ruta-db.xxxxx.eu-central-1.rds.amazonaws.com admin mypassword ruta_db ruta-frontend-bucket
```

## الجدولة (كرون)
لعمل باك أب يومي الساعة 2 صباحًا:

```
0 2 * * * /bin/bash /path/to/mysql_backup.sh <DB_HOST> <DB_USER> <DB_PASS> <DB_NAME> <S3_BUCKET>
```

## المتطلبات
- awscli
- mysqldump 