from pathlib import Path
from os import path
from pydantic_settings import BaseSettings, SettingsConfigDict
from pydantic import PostgresDsn,Field

BASE_PATH: Path = Path(__file__).parent

class AuthSetting(BaseSettings):
        
    model_config = SettingsConfigDict(
        env_file=BASE_PATH / '.env',
        extra='ignore',
    )

    db_host: str = Field(default='localhost', alias='POSTGRES_HOST')
    db_port: str = Field(default='5432', alias='POSTGRES_PORT')
    db_user: str = Field(default='user', alias='POSTGRES_USER')
    db_password: str = Field(default='', alias='POSTGRES_PASSWORD')
    db_name: str = Field(default='meditake_db', alias='POSTGRES_DB')

    allowed_origins: list = Field(default=[], alias='CROM')

    db_pool_size: int = Field(default=10, alias='auth_db_pool_size')
    db_max_overflow: int = Field(default=20, alias='auth_db_max_overflow')

    @property
    def db_dns(self)->PostgresDsn:
        dns: PostgresDsn = PostgresDsn.build(
            scheme='postgresql',
            username=self.db_user,
            password=self.db_password,
            host=self.db_host,
            port=int(self.db_port),
            path=self.db_name

        )
        return dns

setting = AuthSetting()
print(setting)