# TickFeed FastAPI

Переписывание [tickfeeddmr](../tickfeeddmr) (сервис рыночных данных: Binance, MOEX, ЦБ РФ, REST/SSE API, ИИ-чат) с Django на FastAPI.

Стек: FastAPI, SQLModel, Alembic, PostgreSQL, Python 3.14, зависимости через `uv`.

## Локальный запуск

```
docker compose watch          # db + backend (fastapi dev на :8000)
```

Переменные окружения берутся из `.env` в корне репозитория. Он не коммитится: скопируйте `.env.example` в `.env` и задайте пароль.

## Проверки

```
uv sync --all-packages
cd backend
bash scripts/lint.sh          # mypy, ty, ruff
bash scripts/test.sh          # pytest + coverage (нужна запущенная БД)
```

Миграции: `alembic revision --autogenerate -m "..."` и `alembic upgrade head` из `backend/`.
