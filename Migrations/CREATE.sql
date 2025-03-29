-- Crear base de datos y Conectarse
CREATE DATABASE gescon;
\c gescon;

-- Usuario para Ayudante
CREATE USER ayudante WITH ENCRYPTED PASSWORD 'revision';
GRANT ALL PRIVILEGES ON DATABASE gescon TO ayudante;
ALTER DATABASE gescon OWNER TO ayudante;
ALTER USER ayudante WITH SUPERUSER;

-- Tabla de Categorias
CREATE TABLE IF NOT EXISTS categoria (
    id_categoria SERIAL PRIMARY KEY,
    nombre VARCHAR(85) NOT NULL
);

-- Tabla de Articulos
CREATE TABLE IF NOT EXISTS articulo (
    id_articulo SERIAL PRIMARY KEY,
    titulo VARCHAR(50) NOT NULL,
    resumen VARCHAR(150) NOT NULL,
    fecha_envio DATE NOT NULL
);

-- Tabla Topico (relaciona Artículo y Categoria)
CREATE TABLE IF NOT EXISTS topico (
    id_categoria INTEGER REFERENCES categoria(id_categoria),
    id_articulo INTEGER REFERENCES articulo(id_articulo),
    PRIMARY KEY (id_categoria, id_articulo)
);

-- Tabla de Autores 
CREATE TABLE IF NOT EXISTS autor (
    id_autor SERIAL PRIMARY KEY,
    rut CHAR(10) UNIQUE NOT NULL,
    nombre VARCHAR(85) NOT NULL,
    email VARCHAR(95) UNIQUE NOT NULL
);

-- Tabla Propiedad (relaciona Autor y Artículo)
CREATE TABLE IF NOT EXISTS propiedad (
    id_articulo INTEGER REFERENCES articulo(id_articulo),
    id_autor INTEGER REFERENCES autor(id_autor),
    es_contacto INTEGER NOT NULL,
    PRIMARY KEY (id_articulo, id_autor)
);

-- Tabla de Revisores
CREATE TABLE IF NOT EXISTS revisor (
    id_revisor SERIAL PRIMARY KEY,
    rut CHAR(10) UNIQUE NOT NULL,
    nombre VARCHAR(85) NOT NULL,
    email VARCHAR(95) UNIQUE NOT NULL
);

-- Tabla de especialidad (Relaciona Revisor y Categoria)
CREATE TABLE IF NOT EXISTS especialidad (
    id_categoria INTEGER REFERENCES categoria(id_categoria),
    id_revisor INTEGER REFERENCES revisor(id_revisor),
    PRIMARY KEY (id_categoria, id_revisor)
);

-- Tabla de Revisiones (Relaciona Articulo y Revisor)
CREATE TABLE IF NOT EXISTS revision (
    id_articulo INTEGER REFERENCES articulo(id_articulo),
    id_revisor INTEGER REFERENCES revisor(id_revisor),
    PRIMARY KEY (id_articulo, id_revisor)
);