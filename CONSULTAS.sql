-- 1. Obtener los nombres y resumenes de todos los articulos que comiencen con la letra O
SELECT titulo, resumen
FROM articulo
WHERE titulo LIKE 'O%';

-- 2. Obtener la cantidad de articulos enviados por cada autor
SELECT aut.nombre, COUNT(*) AS n_articulos
FROM propiedad p
JOIN usuario aut ON aut.id_usuario = p.id_autor
GROUP BY aut.nombre;

-- 3. Obtener los titulos de los articulos que tienen mas de un topico asignado
SELECT art.titulo
FROM articulo art
JOIN topico top ON top.id_articulo = art.id_articulo
GROUP BY art.titulo
HAVING COUNT(*) > 1;

-- 4. Mostrar el titulo del articulo y toda la informacion acerca del autor de contacto
-- para todos los articulos que contengan la palabra Software en el titulo
SELECT art.titulo, aut.id_usuario, aut.rut, aut.nombre, aut.email, aut.tipo
FROM articulo art
JOIN propiedad pro ON pro.id_articulo = art.id_articulo
JOIN usuario aut ON aut.id_usuario = pro.id_autor
WHERE art.titulo LIKE '%Software%' AND pro.es_contacto = TRUE;

-- 5. Obtener el nombre y la cantidad de articulos asignados a cada revisor
SELECT rv.nombre, COUNT(*) AS n_articulos
FROM usuario rv
JOIN revision rev ON rev.id_revisor = rv.id_usuario
WHERE rev.estado IS NULL    --> Articulos asignados en el presente (En estado pendiente)
GROUP BY rv.nombre;

-- 6. Obtener los nombres de los revisores que tienen asignados mas de 3 articulos
SELECT rv.nombre FROM usuario rv
JOIN revision rev ON rev.id_revisor = rv.id_usuario
WHERE rev.estado IS NULL    --> Articulos asignados en el presente (En estado pendiente)
GROUP BY rv.nombre HAVING COUNT(*) > 3;

-- 7. Obtener los titulos de los articulos y el nombre de los revisores asignados,
-- pero solo para aquellos articulos que tengan la palabra Gestion en el titulo
SELECT art.titulo, STRING_AGG(rv.nombre, ', ') AS revisores_asignados
FROM articulo art
JOIN revision rev ON rev.id_articulo = art.id_articulo
JOIN usuario rv ON rv.id_usuario = rev.id_revisor
WHERE art.titulo LIKE '%Gestion%' GROUP BY art.titulo;

-- 8. Obtener la cantidad de revisores que son especialistas en cada topico
-- (Ej: Bases de datos 5, Analisis de Sistemas: 3, Estadistica: 8)
SELECT cat.nombre, COUNT(esp.id_revisor) AS n_revisores
FROM categoria cat 
JOIN especialidad esp ON esp.id_categoria = cat.id_categoria
GROUP BY cat.nombre;

-- 9. Obtener el Top 10 articulos mas antiguos ingresados en la BD
SELECT art.titulo, art.fecha_envio FROM articulo art                        
ORDER BY art.fecha_envio ASC
LIMIT 10;

-- 10. Obtener los nombres de los articulos, cuyos revisores (cada uno) participa en la revision de 3 o mas articulos
SELECT DISTINCT art.titulo
FROM articulo art
JOIN revision rev ON rev.id_articulo = art.id_articulo
JOIN (
    SELECT id_revisor
    FROM revision
    GROUP BY id_revisor
    HAVING COUNT(*) >= 3
) revisores_validos ON revisores_validos.id_revisor = rev.id_revisor;
