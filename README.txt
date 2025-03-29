INTEGRANTES:

    -------------------------------------
    | Nombre            | Rol           |
    -------------------------------------
    | Matias Peñaloza   | 202373037-8   |
    | Nombre 2          | Rol 2         |
    -------------------------------------

INSTRUCCIONES DE EJECUCION:

    1. Levantar la base de datos POSTGRESQL: (2 Opciones)

        - Opcion "Docker": (Recomendada)

            # Construir imagen e Iniciar contenedor
            > sudo docker-compose up -d

        - Opcion "PostgreSQL Local":
            
            # Crear base de datos
            > sudo -u postgres psql -f Migrations/initdb.sql

            !Opcion sin sudo
            > psql -U postgres -f Migrations/initdb.sql


    2. Poblar base de datos:
    
        !PAQUETES UTILIZADOS:
            - faker             # genera datos aleatorios
            - psycopg2-binary   # conexion con postgresql

        # Ejecutar el script de python
        > python -u ./Scripts/INSERT.py


    3. Conectar con POSTGRESQL

        - Opcion "Docker": (Recomendada)

            # Conectarse a POSTGRESQL
            > sudo docker exec -e POSTGRES_PASSWORD="revision" -it postgresql_gescon psql -U ayudante -d gescon

        - Opcion "PostgreSQL Local":

            # Conectarse a la base de datos
            > POSTGRES_PASSWORD="revision" psql -U ayudante -d gescon


PRECAUCIONES AL USAR WINDOWS:

    - Si "sudo" no esta configurado, ejecute los comandos sin "sudo"
