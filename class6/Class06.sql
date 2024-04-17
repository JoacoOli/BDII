--1: Listar todos los actores que comparten el mismo apellido, ordenados alfabéticamente por apellido
SELECT *
FROM actors
WHERE last_name IN (
    SELECT last_name
    FROM actors
    GROUP BY last_name
    HAVING COUNT(*) > 1
)
ORDER BY last_name;

--2: Encontrar actores que no trabajan en ninguna película
SELECT *
FROM actors
WHERE actor_id NOT IN (
    SELECT DISTINCT actor_id
    FROM film_actor
);

--3: Encontrar clientes que alquilaron solo una película
SELECT customer_id, COUNT(*) AS rental_count
FROM rental
GROUP BY customer_id
HAVING rental_count = 1;

--4: Encontrar clientes que alquilaron más de una película
SELECT customer_id, COUNT(*) AS rental_count
FROM rental
GROUP BY customer_id
HAVING rental_count > 1;

--5: Listar los actores que actuaron en 'BETRAYED REAR' o 'CATCH AMISTAD'
SELECT DISTINCT a.*
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
WHERE f.title IN ('BETRAYED REAR', 'CATCH AMISTAD');

--6: Listar los actores que actuaron en 'BETRAYED REAR' pero no en 'CATCH AMISTAD'
SELECT DISTINCT a.*
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
WHERE f.title = 'BETRAYED REAR'
AND a.actor_id NOT IN (
    SELECT a.actor_id
    FROM actor a
    JOIN film_actor fa ON a.actor_id = fa.actor_id
    JOIN film f ON fa.film_id = f.film_id
    WHERE f.title = 'CATCH AMISTAD'
);

-- 7: Listar los actores que actuaron en ambos 'BETRAYED REAR' y 'CATCH AMISTAD'
SELECT DISTINCT a.*
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
WHERE f.title = 'BETRAYED REAR'
AND a.actor_id IN (
    SELECT a.actor_id
    FROM actor a
    JOIN film_actor fa ON a.actor_id = fa.actor_id
    JOIN film f ON fa.film_id = f.film_id
    WHERE f.title = 'CATCH AMISTAD'
);

--8: Listar todos los actores que no trabajaron en 'BETRAYED REAR' o 'CATCH AMISTAD'
SELECT *
FROM actor
WHERE actor_id NOT IN (
    SELECT DISTINCT a.actor_id
    FROM actor a
    JOIN film_actor fa ON a.actor_id = fa.actor_id
    JOIN film f ON fa.film_id = f.film_id
    WHERE f.title IN ('BETRAYED REAR', 'CATCH AMISTAD')
);
