-- Exercises
/* Create two or three queries using address table in sakila db:
include postal_code in where (try with in/not it operator)
eventually join the table with city/country tables.
measure execution time.
Then create an index for postal_code on address table.
measure execution time again and compare with the previous ones.
Explain the results
*/

-- Query 1: Using IN operator with postal_code
SELECT *, CASE active WHEN 1 THEN 'active' ELSE 'inactive' END AS status 
FROM address 
INNER JOIN customer USING(address_id) 
INNER JOIN city USING(city_id) 
INNER JOIN country USING(country_id) 
WHERE postal_code IN (35200, 17886, 53561, 42399) 
AND store_id = 1 
ORDER BY district DESC; 
-- Execution Time: 0.0035 seconds

-- Query 2: Using NOT IN operator with postal_code
SELECT a.address, a.postal_code, c.city, co.country 
FROM address a 
INNER JOIN city c ON a.city_id = c.city_id 
INNER JOIN country co ON c.country_id = co.country_id 
WHERE a.postal_code NOT IN ('12345', '67890', '54321');
-- Execution Time: 0.0058 seconds

-- Creating index on postal_code
CREATE INDEX index_postal_code ON address(postal_code);

-- Measure execution time of Query 1 after index creation
SELECT *, CASE active WHEN 1 THEN 'active' ELSE 'inactive' END AS status 
FROM address 
INNER JOIN customer USING(address_id) 
INNER JOIN city USING(city_id) 
INNER JOIN country USING(country_id) 
WHERE postal_code IN (35200, 17886, 53561, 42399) 
AND store_id = 1 
ORDER BY district DESC; 
-- Execution Time after index: 0.0030 seconds

-- Measure execution time of Query 2 after index creation
SELECT a.address, a.postal_code, c.city, co.country 
FROM address a 
INNER JOIN city c ON a.city_id = c.city_id 
INNER JOIN country co ON c.country_id = co.country_id 
WHERE a.postal_code NOT IN ('12345', '67890', '54321');
-- Execution Time after index: 0.0036 seconds

/*
La creación del índice en postal_code permite que las búsquedas sean más rápidas, ya que el motor de la base de datos puede acceder a la información en el índice en lugar de escanear toda la tabla. 
Como resultado, las consultas que usan postal_code después de la creación del índice muestran tiempos de ejecución más bajos en comparación con los tiempos antes de crear el índice.
*/

/* Run queries using actor table, searching for first and last name columns independently. 
Explain the differences and why is that happening? 
*/

SELECT first_name FROM actor WHERE first_name LIKE "%A"; 
-- Execution Time: 0.0011 seconds

SELECT last_name FROM actor WHERE last_name LIKE "%A"; 
-- Execution Time: 0.0010 seconds

/*
La diferencia en los tiempos de ejecución se debe a que last_name tiene un índice, lo que permite que el motor de la base de datos acceda más rápidamente a los datos almacenados. 
Esto significa que la consulta en last_name se ejecuta más rápido que la de first_name, ya que esta última puede requerir un escaneo completo de la tabla si no tiene un índice.
*/

/* Compare results finding text in the description on table film with LIKE 
and in the film_text using MATCH ... AGAINST. Explain the results. 
*/

SELECT * FROM film WHERE description LIKE "%feminist%"; 
-- Execution Time: 0.0068 seconds

SELECT * FROM film_text WHERE MATCH (title, description) AGAINST("%feminist%"); 
-- Execution Time: 0.0030 seconds

/*
La consulta utilizando MATCH ... AGAINST es más rápida porque la tabla film_text tiene un índice de texto completo en las columnas title y description, 
lo que optimiza la búsqueda en comparación con el uso de LIKE, que no aprovecha un índice y puede requerir un escaneo completo de la tabla.
*/
