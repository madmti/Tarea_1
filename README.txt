INTEGRANTES:

    -------------------------------------
    | Nombre            | Rol           |
    -------------------------------------
    | Matias Peñaloza   | 202373037-8   |
    | Nombre 2          | Rol 2         |
    -------------------------------------

INSTRUCCIONES DE EJECUCION:

    1. Levantar la base de datos POSTGRESQL: (2 Opciones)

        - Opcion (PostgreSQL Local):
            
            # Crear base de datos
            > sudo -u postgres psql -f Migrations/CREATE.sql

            # Conectarse a la base de datos
            > POSTGRES_PASSWORD="revision" psql -U ayudante -d gescon

        - Opcion (Docker):

            # Construir la imagen
            > sudo docker build -t postgresql_gescon_image .

            # Iniciar el contenedor
            > sudo docker run --name postgresql_gescon -d postgresql_gescon_image

            # Conectarse a POSTGRESQL
            > sudo docker exec -e POSTGRES_PASSWORD="revision" -it postgresql_gescon psql -U ayudante -d gescon

    2. Poblar base de datos:
    
        !PAQUETES UTILIZADOS:
            - faker             # genera datos aleatorios
            - psycopg2-binary   # conexion con postgresql

        # Ejecutar el script de python
        > python -u ./Scripts/INSERT.py

    3. Ejecutar consultas


INSTRUCCIONES DETENCION (Docker):

    # Detener Contenedor
    > sudo docker kill postgresql_gescon

    # Eliminar Contenedor
    > sudo docker container postgresql_gescon

    # Eliminar Imagen
    > sudo docker image postgresql_gescon_image

