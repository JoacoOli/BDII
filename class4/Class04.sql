Use sakila

# Mostrar título y características especiales de las películas que tienen clasificación PG-13
SELECT titulo, características_especiales
FROM película
WHERE clasificación = 'PG-13';

# Obtener una lista de todas las duraciones diferentes de las películas
SELECT DISTINCT duración
FROM película;

# Mostrar título, tarifa de alquiler y costo de reposición de las películas que tienen un costo de reposición entre 20.00 y 24.00
SELECT título, tarifa_de_alquiler, costo_de_reposición
FROM película
WHERE costo_de_reposición BETWEEN 20.00 AND 24.00;

# Mostrar título, categoría y clasificación de las películas que tienen 'Detrás de escena' como características especiales
SELECT título, categoría.nombre AS categoría, clasificación
FROM película
JOIN película_categoria ON película.id_pelicula = película_categoria.id_pelicula
JOIN categoría ON película_categoria.id_categoría = categoría.id_categoría
WHERE características_especiales LIKE '%Detrás de escena%';

# Mostrar el nombre y apellido de los actores que actuaron en 'ZOOLANDER FICTION'
SELECT actor.nombre, actor.apellido
FROM actor
JOIN película_actor ON actor.id_actor = película_actor.id_actor
JOIN película ON película_actor.id_pelicula = película.id_pelicula
WHERE película.título = 'ZOOLANDER FICTION';

# Mostrar la dirección, ciudad y país de la tienda con id 1
SELECT dirección, ciudad, país
FROM tienda
WHERE id_tienda = 1;

# Mostrar pares de títulos de películas y clasificación de películas que tienen la misma clasificación
SELECT p1.título AS título1, p2.título AS título2, p1.clasificación
FROM película AS p1, película AS p2
WHERE p1.id_pelicula <> p2.id_pelicula AND p1.clasificación = p2.clasificación;

# Obtener todas las películas disponibles en la tienda con id 2 y el nombre y apellido del gerente de esta tienda
SELECT película.título, película.id_tienda, personal.nombre AS nombre_gerente, personal.apellido AS apellido_gerente
FROM inventario
JOIN película ON inventario.id_pelicula = película.id_pelicula
JOIN tienda ON película.id_tienda = tienda.id_tienda
JOIN personal ON tienda.id_personal_gerente = personal.id_personal
WHERE tienda.id_tienda = 2;
