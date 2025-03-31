-- 1. Obtener los nombres y resumenes de todos los articulos que comiencen con la letra O
SELECT titulo, resumen FROM articulo WHERE titulo LIKE 'O%';
-- 2. Obtener la cantidad de articulos enviados por cada autor
SELECT aut.nombre, COUNT (*) AS n_articulos FROM propiedad p JOIN autor aut ON aut.id_autor = p.id_autor GROUP BY aut.nombre;
-- 3. Obtener los titulos de los articulos que tienen mas de un topico asignado

-- 4. Mostrar el titulo del articulo y toda la informacion acerca del autor de contacto
-- para todos los articulos que contengan la palabra Software en el titulo

-- 5. Obtener el nombre y la cantidad de articulos asignados a cada revisor

-- 6. Obtener los nombres de los revisores que tienen asignados mas de 3 articulos

-- 7. Obtener los titulos de los articulos y el nombre de los revisores asignados,
-- pero solo para aquellos articulos que tengan la palabra Gestion en el titulo

-- 8. Obtener la cantidad de revisores que son especialistas en cada topico
-- (Ej: Bases de datos 5, Analisis de Sistemas: 3, Estadistica: 8)

-- 9. Obtener el Top 10 articulos mas antiguos ingresados en la BD

-- 10. Obtener los nombres de los articulos, cuyos revisores (cada uno) participa en la revision de 3 o mas articulos
