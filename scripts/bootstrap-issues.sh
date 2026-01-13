#!/usr/bin/env bash
set -euo pipefail

OWNER="jrlecona"
REPO="odoo-educat-lazitos"
PROJECT_TITLE="Odoo EduCat Lazitos – Roadmap"

# 1) Get repo and user IDs
OWNER_ID=$(gh api graphql -f query='
query($login:String!){ user(login:$login){ id } }
' -F login="$OWNER" -q .data.user.id)

# 2) Find project by title (assumes it already exists)
PROJECT_ID=$(gh api graphql -f query='
query($login:String!){
  user(login:$login){
    projectsV2(first:50){
      nodes{ id title }
    }
  }
}
' -F login="$OWNER" \
  --jq '.data.user.projectsV2.nodes[] | select(.title=="'"$PROJECT_TITLE"'") | .id')

if [[ -z "${PROJECT_ID}" ]]; then
  echo "❌ Project not found: $PROJECT_TITLE (create it first in GitHub Projects)"
  exit 1
fi

# Helper to create issue and add to project
create_issue () {
  local title="$1"
  local body="$2"
  local labels="$3"  # comma-separated, e.g. "feature,educat"
  local issue_url
  # Create issue and capture URL from stdout
  issue_url=$(gh issue create -R "$OWNER/$REPO" \
    --title "$title" \
    --body "$body" \
    --label "$labels" \
    | tail -n 1 | tr -d '\r')

  # Get Issue node ID using resource(url: URI!)
  issue_node_id=$(gh api graphql -f query='
  query($url:URI!){
    resource(url:$url){
        ... on Issue { id }
    }
  }
  ' -F url="$issue_url" -q .data.resource.id)

  # Add to Project
  gh api graphql -f query='
  mutation($project:ID!,$content:ID!){
    addProjectV2ItemById(input:{projectId:$project, contentId:$content}){ item { id } }
  }' -F project="$PROJECT_ID" -F content="$issue_node_id" >/dev/null

  echo "✅ Created + added: $title"
}

# -----------------------------
# PHASE 0 – Discovery
# -----------------------------
create_issue "Phase 0: Definir MVP funcional del jardín" \
"**Type:** Feature\n**Priority:** High\n\n## Alcance\n- Relevar procesos actuales\n- Identificar dolor principal\n- Definir MVP (qué entra / qué NO)\n\n## Acceptance Criteria\n- Documento corto (1–2 páginas) con alcance validado\n- Lista de funcionalidades MVP cerrada\n" \
"feature"

create_issue "Phase 0: Definir roles y permisos" \
"**Type:** Task\n\n## Roles\n- Admin\n- Docente\n- Padre/Tutor\n\n## Acceptance Criteria\n- Matriz de permisos por rol (qué puede ver/editar)\n" \
"task"

# -----------------------------
# PHASE 1 – Infra
# -----------------------------
create_issue "Phase 1: Provisionar servidor base (VM)" \
"**Type:** Infra\n\n## Tasks\n- Crear VM (Ubuntu 22.04)\n- Usuario no-root\n- Firewall básico\n\n## Acceptance Criteria\n- Acceso SSH seguro\n- Puertos mínimos abiertos\n" \
"infra"

create_issue "Phase 1: Setup Docker & Docker Compose" \
"**Type:** Infra\n\n## Tasks\n- Instalar Docker\n- Instalar Docker Compose v2\n\n## Acceptance Criteria\n- docker compose version OK\n- Servicios pueden levantar\n" \
"infra"

create_issue "Phase 1: Configurar dominio + SSL (opcional)" \
"**Type:** Infra\n\n## Tasks\n- DNS\n- Nginx reverse proxy\n- Let's Encrypt\n\n## Acceptance Criteria\n- HTTPS válido\n- Redirección HTTP→HTTPS\n" \
"infra"

# -----------------------------
# PHASE 2 – Odoo + EduCat
# -----------------------------
create_issue "Phase 2: Desplegar Odoo base (Docker)" \
"**Type:** Feature\n\n## Tasks\n- Levantar Odoo + Postgres con docker-compose\n- Persistencia de volúmenes\n\n## Acceptance Criteria\n- Odoo accesible\n- DB persiste reinicios\n" \
"feature,odoo"

create_issue "Phase 2: Instalar EduCat Core" \
"**Type:** Feature\n\n## Tasks\n- Instalar EduCat Core\n- Validar dependencias\n\n## Acceptance Criteria\n- Módulos EduCat visibles y activables\n" \
"feature,educat"

create_issue "Phase 2: Instalar módulos académicos (Students/Parents/Courses/Attendance)" \
"**Type:** Feature\n\n## Includes\n- Students\n- Parents\n- Courses\n- Attendance\n\n## Acceptance Criteria\n- Flujos básicos operativos\n" \
"feature,educat"

# -----------------------------
# PHASE 3 – Configuración
# -----------------------------
create_issue "Phase 3: Configurar cursos y salas" \
"**Type:** Config\n\n## Tasks\n- Crear cursos por edad\n- Asignar docentes\n\n## Acceptance Criteria\n- Cursos operativos\n" \
"config"

create_issue "Phase 3: Configurar alumnos y padres/tutores" \
"**Type:** Config\n\n## Tasks\n- Relación alumno ↔ tutor\n- Acceso por rol\n\n## Acceptance Criteria\n- Login funcional para padres\n" \
"config,parents"

create_issue "Phase 3: Configurar pagos y cuotas" \
"**Type:** Feature\n\n## Tasks\n- Cuotas mensuales\n- Estado de cuenta\n\n## Acceptance Criteria\n- Pagos visibles por alumno\n" \
"feature,payments"

# -----------------------------
# PHASE 4 – UX
# -----------------------------
create_issue "Phase 4: Simplificar UI para personal no técnico" \
"**Type:** Task\n\n## Tasks\n- Ocultar menús innecesarios\n- Renombrar labels\n\n## Acceptance Criteria\n- UI validada por usuaria final\n" \
"ux,task"

create_issue "Phase 4: Portal para padres (mínimo)" \
"**Type:** Feature\n\n## Includes\n- Estado de pagos\n- Comunicados\n\n## Acceptance Criteria\n- Padres acceden sin ayuda\n" \
"feature,parents,ux"

# -----------------------------
# PHASE 5 – Mejoras
# -----------------------------
create_issue "Phase 5: Backups automáticos + restore probado" \
"**Type:** Infra\n\n## Tasks\n- Backup DB (pg_dump)\n- Backup filestore\n- Restore probado\n\n## Acceptance Criteria\n- Se puede restaurar en ambiente limpio\n" \
"infra"

create_issue "Phase 5: Emails automáticos (avisos + recordatorios)" \
"**Type:** Feature\n\n## Tasks\n- SMTP / provider\n- Plantillas básicas\n\n## Acceptance Criteria\n- Emails enviados y auditables\n" \
"feature,automation"
