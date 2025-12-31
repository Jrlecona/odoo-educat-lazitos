# Architectural Decisions

## 1) Docker Compose
**Decision:** Usar Docker Compose para levantar Odoo + PostgreSQL.
**Reason:** Portabilidad, upgrades simples, reproducible.

## 2) Monorepo
**Decision:** Un solo repo con infra + config + addons.
**Reason:** Proyecto personal, menos overhead.

## 3) Odoo 16.0 (por defecto)
**Decision:** Arrancar con Odoo 16.0.
**Reason:** Muy usado, buen balance estabilidad/compatibilidad para módulos.

> Si EduCat que elijas requiere otra versión, se cambia en `.env`.
