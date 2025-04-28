INTEGRANTES:

    -------------------------------------
    | Nombre            | Rol           |
    -------------------------------------
    | Matias Peñaloza   | 202373037-8   |
    | Hans González     | 202373020-3   |
    -------------------------------------


ARCHIVOS:

    ~/Tarea_1/
    |
    |---Populate/               # Archivos usados para generar INSERT
    |   |
    |   +----...py
    |
    |---Migrations/             # Archivos para inicializar y/o poblar la BBDD
    |   |
    |   +----...sql
    |
    |---Tex/                    # Codigo fuente de Modelo.pdf
    |   |
    |   +----...tex
    |
    +----CONSULTAS.sql          # Consultas pedidas por el enunciado
    +----docker-compose.yml     # Configuracion Docker
    +----Modelo.pdf             # Modelo y Diccionario en PDF
    +----README.txt


INSTRUCCIONES DE EJECUCION:
    ! WARNING: En windows probablemente no funcionen los comandos con "sudo",
               si es el caso ejecute los comandos sin "sudo".

    Opcion "Docker": (Recomendada)
        # Generar archivo 02_INSERT.sql
        > python Populate/main.py file

        # Construir imagen e Iniciar contenedor
        > sudo docker-compose up -d

        # Acceder a PostgreSQL
        > sudo docker exec -e POSTGRES_PASSWORD="revision" -it postgresql_gescon psql -U ayudante -d gescon

    Opcion "pgAdmin":
        
        1. Crear base de datos en pgAdmin con el nombre "gescon"
        2. Ejecutar archivo Migrations/01_CREATE.sql en la shell de pgAdmin
        3. Reemplazar los datos de conexion en Populate/.env
        4. Ejecutar script de poblacion
        > python Populate/main.py exec

    Opcion "PostgreSQL Local":
        # Generar archivo 02_INSERT.sql
        > python Populate/main.py file

        # Crear base de datos
        > psql -U <tu_usuario> -c "CREATE DATABASE gescon;"

        ! WARNING: Si tu usuario de PostgreSQL tiene constraseña utiliza:
        > psql -U <tu_usuario> -c "CREATE DATABASE gescon;" -W

        # Ejecutar .sql's
        > psql -U <tu_usuario> -d gescon -f Migrations/01_CREATE.sql -f Migrations/02_INSERT.sql

    Finalmente las consultas estan en ./CONSULTAS.sql tanto en la carpeta de la tarea
    como en el contenedor de Docker (Si se modifica desde afuera, tambien se modifica en el contenedor).
