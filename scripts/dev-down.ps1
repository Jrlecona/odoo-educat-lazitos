@"
docker compose --env-file .env -f infra/docker/docker-compose.yml down
"@ | Set-Content .\scripts\dev-down.ps1
