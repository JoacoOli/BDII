# Write a query that gets all the customers that live in Argentina. Show the first and last name in one column, the address and the city.
SELECT CONCAT(cu.first_name, ' ', cu.last_name) AS full_name, 
       a.address, 
       ci.city 
FROM customer cu 
INNER JOIN address a USING(address_id) 
INNER JOIN city ci USING(city_id) 
INNER JOIN country co USING(country_id) 
WHERE co.country = 'Argentina';

# Write a query that shows the film title, language and rating.
SELECT title, 
       CASE rating
           WHEN 'G' THEN 'G (General Audiences) – All ages admitted.'
           WHEN 'PG' THEN 'PG (Parental Guidance Suggested) – Some material may not be suitable for children.'
           WHEN 'PG-13' THEN 'PG-13 (Parents Strongly Cautioned) – Some material may be inappropriate for children under 13.'
           WHEN 'R' THEN 'R (Restricted) – Under 17 requires accompanying parent or adult guardian.'
           WHEN 'NC-17' THEN 'NC-17 (Adults Only) – No one 17 and under admitted.'
           ELSE 'Not Rated'
       END AS rating_formatted,
       l.name 
FROM film 
INNER JOIN language l USING(language_id);

#Write a search query that shows all the films (title and release year) an actor was part of. Assume the actor comes from a text box introduced by hand from a web page. Make sure to "adjust" the input text to try to find the films as effectively as you think is possible.
SELECT f.title, 
       f.release_year, 
       CONCAT(a.first_name, ' ', a.last_name) AS actor_name 
FROM film_actor fa 
INNER JOIN film f USING(film_id) 
INNER JOIN actor a USING(actor_id) 
WHERE LOWER(CONCAT(a.first_name, ' ', a.last_name)) LIKE LOWER('%PENELOPE GUINESS%');

#Find all the rentals done in the months of May and June. Show the film title, customer name and if it was returned or not. There should be returned column with two possible values 'Yes' and 'No'.
SELECT f.title, 
       CONCAT(c.first_name, ' ', c.last_name) AS customer_name, 
       CASE 
           WHEN r.return_date IS NOT NULL THEN 'Yes'
           ELSE 'No'
       END AS returned
FROM rental r 
INNER JOIN inventory USING(inventory_id)
INNER JOIN film f USING(film_id)
INNER JOIN customer c USING(customer_id)
WHERE MONTH(rental_date) IN (5, 6);

# Investigate CAST and CONVERT functions. Explain the differences if any, write examples based on sakila DB.
SELECT title, CAST(rental_rate AS SIGNED) AS rental_rate_int 
FROM film;

SELECT title, CONVERT(rental_rate, SIGNED) AS rental_rate_int 
FROM film;

# Investigate NVL, ISNULL, IFNULL, COALESCE, etc type of function. Explain what they do. Which ones are not in MySql and write usage examples.
-- IFNULL (MySQL)
SELECT IFNULL(rental_rate, 0) AS rental_rate 
FROM film;

-- COALESCE (universal en SQL)
SELECT COALESCE(rental_rate, 0) AS rental_rate 
FROM film;

- `NVL`: Función utilizada en Oracle para reemplazar un valor `NULL` con un valor por defecto.
- `ISNULL`: Disponible en SQL Server y MySQL para reemplazar valores `NULL`.
- `IFNULL`: Función específica de MySQL para manejar valores `NULL`.
- `COALESCE`: Función más flexible y compatible con la mayoría de las bases de datos, que retorna el primer valor no `NULL` de una lista de expresiones.
