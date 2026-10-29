# TickFeed FastAPI

Переписывание [tickfeeddmr](../tickfeeddmr) (сервис рыночных данных: Binance, MOEX, ЦБ РФ, REST/SSE API, ИИ-чат) с Django на FastAPI.

Стек: FastAPI, SQLModel, Alembic, PostgreSQL, Python 3.14, зависимости через `uv`.

## Локальный запуск (Docker)

`justfile` оборачивает `docker compose`, файл по умолчанию — `docker-compose.local.yml`:

```
just up                 # postgres + fastapi (миграции, затем fastapi dev на :8000)
just down               # остановить контейнеры
just prune              # остановить и удалить тома (локальную БД)
just build              # пересобрать образы
just logs               # логи контейнеров (следит, выход по Ctrl+C)
just alembic <args>     # alembic в контейнере, напр. just alembic revision --autogenerate -m "..."
just pytest <args>      # pytest в контейнере
just test-ci            # тесты в изолированном стеке, как в CI
```

| Файл | Назначение |
|---|---|
| `docker-compose.local.yml` | Локальная разработка: репозиторий смонтирован в `/app`, автоперезагрузка, API на :8000 |
| `docker-compose.test.yml` | Тесты и CI: отдельный проект `tickfeed_test` со своей БД, без портов |
| `compose/local/fastapi/` | Dockerfile и `start` (миграции → `fastapi dev`) |
| `compose/production/fastapi/entrypoint` | Ждёт Postgres (`wait-for-it`) перед запуском команды |
| `compose/production/postgres/` | Образ Postgres со скриптами бэкапа: `docker compose exec postgres backup` / `backups` / `restore <файл>` / `rmbackup <файл>` |

## Переменные окружения

`.envs/.local/.fastapi` и `.envs/.local/.postgres` — настройки локального окружения, они в git (пароль только от локальной БД в Docker). Настоящие секреты (ключи внешних API) сюда не класть — для них будет отдельный файл вне git.

## Проверки без Docker

```
uv sync --all-packages
uv run prek run --all-files     # все хуки pre-commit
cd backend
bash scripts/lint.sh            # mypy, ty, ruff
```
