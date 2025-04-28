-- Usuario para ayudante
CREATE USER ayudante WITH ENCRYPTED PASSWORD 'revision';
GRANT ALL PRIVILEGES ON DATABASE gescon TO ayudante;--damos permisos
ALTER DATABASE gescon OWNER TO ayudante;--lo hacemos dueño
ALTER USER ayudante WITH SUPERUSER;--lo hacemos un superusuario, para que puede hacer lo que quiera

-- Categoría
CREATE TABLE IF NOT EXISTS categoria (
    id_categoria SERIAL PRIMARY KEY,--crea un numero incremental
    nombre VARCHAR(85) NOT NULL
);

-- Artículo
CREATE TABLE IF NOT EXISTS articulo (
    id_articulo SERIAL PRIMARY KEY,
    titulo VARCHAR(50) NOT NULL,
    resumen VARCHAR(150) NOT NULL,
    fecha_envio DATE NOT NULL,
    aprobado BOOLEAN NULL DEFAULT NULL
);

-- Usuario
CREATE TABLE IF NOT EXISTS usuario (
    id_usuario SERIAL PRIMARY KEY,
    rut CHAR(10) UNIQUE NOT NULL,
    email VARCHAR(95) UNIQUE NOT NULL,
    nombre VARCHAR(85) UNIQUE NOT NULL,
    contrasena VARCHAR(30) NOT NULL,
    tipo CHAR(3) NOT NULL CHECK (tipo IN ('AUT', 'REV', 'ADM'))
);

-- Topico (relaciona Artículo y Categoria)   referenciamos al id_categoria de categoria
CREATE TABLE IF NOT EXISTS topico ( 
    id_categoria INTEGER REFERENCES categoria(id_categoria) ON DELETE CASCADE,      --> Si se elimina una categoria, se eliminan los topicos asociados
    id_articulo INTEGER REFERENCES articulo(id_articulo) ON DELETE CASCADE,         --> Si se elimina un articulo, se eliminan los topicos asociados
    PRIMARY KEY (id_categoria, id_articulo)
);

-- Especialidad (Relaciona Revisor y Categoria)  
CREATE TABLE IF NOT EXISTS especialidad (
    id_categoria INTEGER REFERENCES categoria(id_categoria) ON DELETE CASCADE,      --> Si se elimina una categoria, se eliminan las especialidades asociadas
    id_revisor INTEGER REFERENCES usuario(id_usuario) ON DELETE CASCADE,            --> Si se elimina un revisor, se eliminan las especialidades asociadas
    PRIMARY KEY (id_categoria, id_revisor)
);

-- Propiedad (relaciona Autor y Artículo)
CREATE TABLE IF NOT EXISTS propiedad (
    id_articulo INTEGER REFERENCES articulo(id_articulo),
    id_autor INTEGER REFERENCES usuario(id_usuario) ON DELETE RESTRICT,             --> No se pueden eliminar autores con articulos asignados
    es_contacto BOOLEAN NOT NULL,
    PRIMARY KEY (id_articulo, id_autor)
);

-- Revision (relaciona Artículo y Revisor)
CREATE TABLE IF NOT EXISTS revision (
    id_articulo INTEGER REFERENCES articulo(id_articulo),
    id_revisor INTEGER REFERENCES usuario(id_usuario) ON DELETE RESTRICT,           --> No se pueden eliminar revisores con revisiones asignadas
    estado BOOLEAN NULL,

    calidad_tecnica INTEGER NULL,
    originalidad INTEGER NULL,
    valoracion_global INTEGER NULL,
    fecha_emision DATE NULL,
    argumentos JSON NULL,

    constraint todo_o_nada  --> Asegura que al enviar todos los campos sean ingresados,
        CHECK (             --> y sino se quede en estado pendiente sin completar campos.
            (
                calidad_tecnica IS NOT NULL --verificamos si todos los campos fueron llenados
                AND originalidad IS NOT NULL 
                AND valoracion_global IS NOT NULL 
                AND fecha_emision IS NOT NULL 
                AND argumentos IS NOT NULL
                AND estado IS NOT NULL
            )
            OR
            (
                calidad_tecnica IS NULL  --o si no se lleno ninguno, asi no se dejan campos a medias
                AND originalidad IS NULL 
                AND valoracion_global IS NULL 
                AND fecha_emision IS NULL 
                AND argumentos IS NULL
                AND estado IS NULL
            )
        ),

    PRIMARY KEY (id_articulo, id_revisor)
);


-- TRIGGER para revisar si el revisor es autor
CREATE OR REPLACE FUNCTION verificar_revisor_no_autor()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (                                     --> Revisa si el id del revisor esta en la propiedad del articulo
        SELECT 1 FROM propiedad
        WHERE id_articulo = NEW.id_articulo
        AND id_autor = NEW.id_revisor
    ) THEN
        RAISE EXCEPTION 'El revisor no puede ser autor del articulo';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_verificar_revisor_no_autor  --se activa la funcion antes de insertar o actualizar  una fila, para evitar que el autor de un articulo sea igual al revisor
BEFORE INSERT OR UPDATE ON revision
FOR EACH ROW
EXECUTE FUNCTION verificar_revisor_no_autor();


-- TRIGGER para la columna calculada articulo.aprobado
CREATE OR REPLACE FUNCTION calcular_aprobado()
RETURNS TRIGGER AS $$
DECLARE
    total_revisiones INTEGER;--se declaran las revisiones
    revisiones_aprobadas INTEGER;
    revisiones_rechazadas INTEGER;
BEGIN
    -- Numero total de revisiones  // se cuentan cuantas revisiones totales, hay y despues contamos cuantas hay aprobadas y rechazadas
    SELECT COUNT(*) INTO total_revisiones
    FROM revision
    WHERE id_articulo = NEW.id_articulo;

    -- Numero de revisiones aprobadas
    SELECT COUNT(*) INTO revisiones_aprobadas
    FROM revision
    WHERE id_articulo = NEW.id_articulo AND estado = TRUE;

    -- Numero de revisiones rechazadas
    SELECT COUNT(*) INTO revisiones_rechazadas
    FROM revision
    WHERE id_articulo = NEW.id_articulo AND estado = FALSE;

    IF total_revisiones = 3 THEN                                                        --> Si tiene 3 revisiones, se evalua el estado
        IF revisiones_aprobadas = total_revisiones THEN                                 --> Si todas las revisiones son TRUE, se deja TRUE(aprobado)
            UPDATE articulo SET aprobado = TRUE WHERE id_articulo = NEW.id_articulo;
        ELSIF revisiones_rechazadas > 0 THEN                                            --> Si alguna revision es FALSE, se deja FALSE(rechazado)
            UPDATE articulo SET aprobado = FALSE WHERE id_articulo = NEW.id_articulo;
        ELSE                                                                            --> Si alguna revision es NULL, se deja en NULL(pendiente)
            UPDATE articulo SET aprobado = NULL WHERE id_articulo = NEW.id_articulo;
        END IF;
    ELSE
        UPDATE articulo SET aprobado = NULL WHERE id_articulo = NEW.id_articulo;        --> Si no tiene 3 revisiones, se deja en NULL(pendiente)
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_calcular_aprobado
AFTER INSERT OR UPDATE ON revision
FOR EACH ROW
EXECUTE FUNCTION calcular_aprobado();