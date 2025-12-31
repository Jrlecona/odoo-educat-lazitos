# Backups

Aquí van scripts para respaldar:
- Base de datos (PostgreSQL)
- Filestore de Odoo

## Idea (próximo paso)
- `backup.sh` o `backup.ps1`:
  - pg_dump
  - tar del filestore
  - (Opcional) subir a S3
