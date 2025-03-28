FROM postgres:17.4

# Environment
ENV POSTGRES_USER=user
ENV POSTGRES_PASSWORD=admin

# Migraciones
COPY Migrations/*.sql /docker-entrypoint-initdb.d/
