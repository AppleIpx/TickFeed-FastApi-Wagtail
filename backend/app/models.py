from sqlmodel import SQLModel

# Table models are registered on SQLModel.metadata, which Alembic uses for autogenerate
__all__ = ["SQLModel"]
