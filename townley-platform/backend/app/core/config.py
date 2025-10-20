from __future__ import annotations

from functools import lru_cache
from typing import Optional
from urllib.parse import quote_plus

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    """Application configuration sourced from environment variables."""

    model_config = SettingsConfigDict(
        env_file=".env", env_file_encoding="utf-8", case_sensitive=False
    )

    # App / security
    app_name: str = "Townley API"
    secret_key: str = "change-me"
    algorithm: str = "HS256"
    access_token_expire_minutes: int = 60

    # Database (SQL Server via pyodbc)
    db_server: str = "localhost"
    db_port: int = 1433
    db_name: str = "master"
    db_user: str = "sa"
    db_password: str = "yourStrong(!)Password"
    db_driver: str = "ODBC Driver 18 for SQL Server"
    db_encrypt: Optional[str] = "yes"
    db_trust_server_certificate: Optional[str] = "yes"

    @property
    def database_url(self) -> str:
        """SQLAlchemy URL for SQL Server using pyodbc."""
        user = quote_plus(self.db_user)
        password = quote_plus(self.db_password)
        driver = quote_plus(self.db_driver)
        query_params = [f"driver={driver}"]
        if self.db_encrypt:
            query_params.append(f"Encrypt={self.db_encrypt}")
        if self.db_trust_server_certificate:
            query_params.append(
                f"TrustServerCertificate={self.db_trust_server_certificate}"
            )
        query = "&".join(query_params)
        return f"mssql+pyodbc://{user}:{password}@{self.db_server}:{self.db_port}/{self.db_name}?{query}"

    # Compatibility aliases for legacy code paths
    @property
    def SECRET_KEY(self) -> str:  # noqa: N802
        return self.secret_key

    @property
    def ALGORITHM(self) -> str:  # noqa: N802
        return self.algorithm

    @property
    def ACCESS_MINUTES(self) -> int:  # noqa: N802
        return self.access_token_expire_minutes

    @property
    def JWT_SECRET(self) -> str:  # noqa: N802
        return self.secret_key

    @property
    def JWT_ALG(self) -> str:  # noqa: N802
        return self.algorithm


@lru_cache
def get_settings() -> Settings:
    return Settings()


settings = get_settings()
