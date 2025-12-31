# Setup Guide

## Requisitos
- Docker Desktop (Windows/Mac) o Docker Engine (Linux)
- Docker Compose v2

## Inicialización
1) Variables:
```bash
cp env/.env.example .env
```

2) Levantar:
```bash
docker compose -f infra/docker/docker-compose.yml up -d
```

3) Primer acceso:
- http://localhost:8069
- Crear base de datos desde UI (Odoo setup)

## Addons custom
- Ubicación: `odoo/addons/custom`
- El ejemplo `lazitos_base` se monta automáticamente como addons path.

## Notas
- Persistencia: volúmenes en `infra/docker/odoo-data` y `infra/docker/postgres-data`
- No comitear data (ya está en `.gitignore`)
