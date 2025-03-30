INTEGRANTES:

    -------------------------------------
    | Nombre            | Rol           |
    -------------------------------------
    | Matias Peñaloza   | 202373037-8   |
    | Hans Gonzales     | 202373020-3   |
    -------------------------------------


ARCHIVOS:

    ~/T1/
    |
    |---Generate/               # Archivos usados para general INSERT.sql
    |   |
    |   +----...py
    |
    |---Migrations/             # Archivos para inicializar y poblar la BBDD
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
        # Construir imagen e Iniciar contenedor
        > sudo docker-compose up -d

        # Acceder a PostgreSQL
        > sudo docker exec -e POSTGRES_PASSWORD="revision" -it postgresql_gescon psql -U ayudante -d gescon


    Opcion "PostgreSQL Local":
        # Crear base de datos
        > psql -U <tu_usuario> -c "CREATE DATABASE gescon;"

        ! WARNING: Si tu usuario de PostgreSQL tiene constraseña utiliza:
        > psql -U <tu_usuario> -c "CREATE DATABASE gescon;" -W

        # Crear tablas y Poblar base de datos
        > psql -U <tu_usuario> -d gescon -f ./Migrations/CREATE.sql -f ./Migrations/INSERT.sql

    
    Finalmente las consultas estan en ./CONSULTAS.sql tanto en "PostgreSQL Local" como en "Docker".
    En caso de querer ejecutar todas las consultas al mismo tiempo:

        En la shell de PostgreSQL:
        gescon=# \i CONSULTAS.sql

        En bash:
        > psql -U <tu_usuario> -d gescon -f ./CONSULTAS.sql
