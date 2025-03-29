-- Crear base de datos y Conectarse
CREATE DATABASE gescon;
\c gescon;

-- Usuario para Ayudante
CREATE USER ayudante WITH ENCRYPTED PASSWORD 'revision';
GRANT ALL PRIVILEGES ON DATABASE gescon TO ayudante;
ALTER DATABASE gescon OWNER TO ayudante;
ALTER USER ayudante WITH SUPERUSER;

-- Tabla de Topicos/Especialidades
CREATE TABLE IF NOT EXISTS top_esp (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(85) NOT NULL
);

-- Tabla de Articulos
CREATE TABLE IF NOT EXISTS articulo (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(50) NOT NULL,
    resumen VARCHAR(150) NOT NULL,
    fecha_publicacion DATE NOT NULL,
    topicos INTEGER[] REFERENCES top_esp(id)
    CONSTRAINT topicos_min CHECK (array_length(topicos, 1) >= 1)
);

-- Tabla de Revisores
CREATE TABLE IF NOT EXISTS revisor (
    id SERIAL PRIMARY KEY,
    rut CHAR(10) UNIQUE NOT NULL,
    nombre VARCHAR(85) NOT NULL,
    email VARCHAR(95) UNIQUE NOT NULL,
    especialidades INTEGER[] REFERENCES top_esp(id)
    CONSTRAINT especialidades_min CHECK (array_length(especialidades, 1) >= 1)
);

-- Tabla de Autores
CREATE TABLE IF NOT EXISTS autor (
    id SERIAL PRIMARY KEY,
    rut CHAR(10) UNIQUE NOT NULL,
    nombre VARCHAR(85) NOT NULL,
    email VARCHAR(95) UNIQUE NOT NULL
);

-- Tabla de Revisiones RELACIONA(Articulo y Revisor)
CREATE TABLE IF NOT EXISTS revision (
    id SERIAL PRIMARY KEY,
    id_articulo INTEGER REFERENCES articulo(id),
    id_revisor INTEGER REFERENCES revisor(id)
);

-- Tabla de Propiedad RELACIONA(Articulo y Autor)
CREATE TABLE IF NOT EXISTS propiedad (
    id SERIAL PRIMARY KEY,
    id_articulo INTEGER REFERENCES articulo(id),
    id_autor INTEGER REFERENCES autor(id),
    es_contacto BOOLEAN NOT NULL
);
