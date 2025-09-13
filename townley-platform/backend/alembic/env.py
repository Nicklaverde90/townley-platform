from __future__ import annotations
from logging.config import fileConfig
from sqlalchemy import engine_from_config, pool
from alembic import context
import urllib.parse

from app.core.config import settings
from app.models.base import Base

# Import models so they are registered with Base.metadata
from app.models import work_orders, users  # noqa: F401

# this is the Alembic Config object, which provides access to the values within the .ini file in use.
config = context.config

def get_url() -> str:
    params = urllib.parse.quote_plus(
        f"DRIVER={{{settings.ODBC_DRIVER}}};SERVER={settings.DB_HOST},{settings.DB_PORT};"
        f"DATABASE={settings.DB_NAME};UID={settings.DB_USER};PWD={settings.DB_PASS};"
        "TrustServerCertificate=yes;"
    )
    return f"mssql+pyodbc:///?odbc_connect={params}"

config.set_main_option("sqlalchemy.url", get_url())

# Interpret the config file for Python logging.
fileConfig(config.config_file_name)

target_metadata = Base.metadata

def run_migrations_offline() -> None:
    url = config.get_main_option("sqlalchemy.url")
    context.configure(url=url, target_metadata=target_metadata, literal_binds=True)
    with context.begin_transaction():
        context.run_migrations()

def run_migrations_online() -> None:
    connectable = engine_from_config(
        config.get_section(config.config_ini_section),
        prefix='sqlalchemy.',
        poolclass=pool.NullPool,
    )
    with connectable.connect() as connection:
        context.configure(connection=connection, target_metadata=target_metadata)
        with context.begin_transaction():
            context.run_migrations()

if context.is_offline_mode():
    run_migrations_offline()
else:
    run_migrations_online()
