-- 1. Create a view named list_of_customers, it should contain the following columns:
-- customer id, customer full name, address, zip code, phone, city, country, status (active/inactive), and store id.
CREATE VIEW list_of_customers AS
SELECT customer_id,
       CONCAT(first_name, ' ', last_name) AS full_name,
       a.address,
       a.postal_code AS zip_code,
       a.phone,
       ci.city,
       co.country,
       CASE active WHEN 1 THEN 'active' ELSE 'inactive' END AS status,
       store_id
FROM customer
INNER JOIN address a USING(address_id)
INNER JOIN city ci USING(city_id)
INNER JOIN country co USING(country_id);

-- Explicación:
-- Se crea la vista 'list_of_customers' uniendo varias tablas (customer, address, city, country) para obtener los datos del cliente, junto con la columna 'status' que depende del valor del campo 'active'.

SELECT * FROM list_of_customers;

-- 2. Create a view named film_details, it should contain the following columns: film id, title, description, category, price, length, rating, and actors (as a string of all the actors separated by a comma)
DROP VIEW IF EXISTS film_details;
CREATE VIEW film_details AS
SELECT f.film_id,
       f.title,
       f.description,
       c.name AS category,
       f.rental_rate AS price,
       f.length,
       f.rating,
       GROUP_CONCAT(CONCAT(a.first_name, ' ', a.last_name) SEPARATOR ', ') AS actors
FROM film f
INNER JOIN film_actor fa USING(film_id)
INNER JOIN actor a USING(actor_id)
INNER JOIN film_category fc USING(film_id)
INNER JOIN category c USING(category_id)
GROUP BY f.film_id, c.name;

-- Explicación:
-- Esta vista muestra los detalles de las películas, incluyendo una lista de actores concatenados separados por comas. Se utiliza `GROUP_CONCAT` para juntar los nombres de los actores.

SELECT * FROM film_details;

-- 3. Create view sales_by_film_category, it should return 'category' and 'total_rental' columns.
DROP VIEW IF EXISTS sales_by_film_category;
CREATE VIEW sales_by_film_category AS
SELECT c.name AS category,
       COUNT(*) AS total_rental
FROM rental r
INNER JOIN inventory i USING(inventory_id)
INNER JOIN film f USING(film_id)
INNER JOIN film_category fc USING(film_id)
INNER JOIN category c USING(category_id)
GROUP BY c.category_id;

-- Explicación:
-- La vista 'sales_by_film_category' devuelve el número total de rentas por cada categoría de película.

SELECT * FROM sales_by_film_category;

-- 4. Create a view called actor_information where it should return actor id, first name, last name, and the amount of films he/she acted on.
DROP VIEW IF EXISTS actor_information;
CREATE VIEW actor_information AS
SELECT a.actor_id,
       a.first_name,
       a.last_name,
       COUNT(fa.film_id) AS film_count
FROM actor a
INNER JOIN film_actor fa USING(actor_id)
GROUP BY a.actor_id;

-- Explicación:
-- Esta vista muestra la información del actor y el número de películas en las que ha actuado.

SELECT * FROM actor_information;

-- 5. Analyze view actor_info, explain the entire query and especially how the subquery works. Be very specific, take some time and decompose each part and give an explanation for each.
SHOW CREATE VIEW actor_info;

-- Explicación:
-- La vista actor_info muestra la información del actor junto con una lista de películas por categoría en las que ha actuado. El subquery en el `GROUP_CONCAT` obtiene las películas de cada categoría.
-- GROUP_CONCAT(DISTINCT CONCAT(c.name, ': ',
-- (SELECT GROUP_CONCAT(f.title ORDER BY f.title SEPARATOR ', ') FROM sakila.film f INNER JOIN sakila.film_category fc ON f.film_id = fc.film_id INNER JOIN sakila.film_actor fa ON f.film_id = fa.film_id WHERE fc.category_id = c.category_id AND fa.actor_id = a.actor_id )) ORDER BY c.name SEPARATOR '; ') AS film_info

-- En este subquery, se selecciona el título de las películas donde el actor haya actuado, agrupadas por categorías. La concatenación y los separadores crean un formato fácil de leer.

-- 6. Materialized views, write a description, why they are used, alternatives, DBMS where they exist, etc.
-- Explicación:
-- Las materialized views son vistas que se almacenan físicamente en el disco, lo que permite un acceso más rápido a los datos. A diferencia de las vistas normales, estas no se actualizan automáticamente cuando cambian las tablas subyacentes. Son útiles cuando se trabaja con grandes volúmenes de datos o consultas complejas.
-- Se pueden actualizar manualmente con un comando `REFRESH`. Algunos sistemas que soportan materialized views incluyen MySQL (con limitaciones), PostgreSQL, SQL Server, e IBM DB2.
