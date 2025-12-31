# Odoo EduCat – Lazitos (Kindergarten)

Sistema de gestión para jardín infantil basado en **Odoo + EduCat**, con despliegue vía **Docker Compose**.

> Repo: `odoo-educat-lazitos`

## 🎯 Objetivo (MVP)
- Gestión de alumnos y tutores
- Cursos/salas
- Asistencia básica
- Pagos/cuotas
- Comunicados (básico)
- Portal para padres (opcional)

## 🧱 Arquitectura (simple y sólida)
- Odoo (contenedor)
- PostgreSQL (contenedor)
- Nginx (reverse proxy) + SSL (opcional / futuro)
- Volúmenes persistentes
- Backups (scripts)

## 🚀 Quick start (local/dev)
1) Copia variables de entorno:
```bash
cp env/.env.example .env
```

2) Levanta servicios:
```bash
docker compose -f infra/docker/docker-compose.yml up -d
```

3) Abre:
- Odoo: http://localhost:8069

## 📚 Documentación
- Roadmap: `docs/roadmap.md`
- Decisiones: `docs/decisions.md`
- Guía de setup: `docs/setup-guide.md`

## 🧩 Custom Addons
Tus módulos custom van en:
- `odoo/addons/custom/`

Incluimos un ejemplo mínimo:
- `odoo/addons/custom/lazitos_base/`

## 🧪 Backups
Scripts:
- `infra/backups/`

## 📄 License
MIT (ver `LICENSE`)
