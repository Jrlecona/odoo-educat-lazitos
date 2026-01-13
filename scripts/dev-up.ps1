New-Item -ItemType Directory -Force .\scripts | Out-Null
@"
docker compose --env-file .env -f infra/docker/docker-compose.yml up -d
"@ | Set-Content .\scripts\dev-up.ps1
