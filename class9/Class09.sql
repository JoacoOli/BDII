-- Obtener la cantidad de ciudades por país en la base de datos. Ordenar por país y country_id.
SELECT CO.COUNTRY, COUNT(*) AS AMOUNT_CITIES 
FROM CITY CI
INNER JOIN COUNTRY CO ON CO.COUNTRY_ID = CI.COUNTRY_ID
GROUP BY CO.COUNTRY_ID
ORDER BY CO.COUNTRY, CO.COUNTRY_ID;
-- Obtener la cantidad de ciudades por país en la base de datos. Mostrar solo los países con más de 10 ciudades, ordenados de mayor a menor cantidad de ciudades.
SELECT CO.COUNTRY, COUNT(*) AS AMOUNT_CITIES 
FROM CITY CI
INNER JOIN COUNTRY CO ON CO.COUNTRY_ID = CI.COUNTRY_ID
GROUP BY CO.COUNTRY_ID
HAVING COUNT(*) > 10
ORDER BY AMOUNT_CITIES DESC;

-- Generar un informe con el nombre del cliente (nombre, apellido), dirección, total de películas alquiladas y el dinero total gastado en alquilar películas. Mostrar primero los que gastaron más dinero.
SELECT FIRST_NAME, LAST_NAME, A.*, 
(SELECT COUNT(*) FROM RENTAL R WHERE R.CUSTOMER_ID = C.CUSTOMER_ID) AS TOTAL_FILMS_RENTED, 
(SELECT SUM(AMOUNT) FROM PAYMENT P WHERE P.CUSTOMER_ID = C.CUSTOMER_ID) AS TOTAL_MONEY_SPENT 
FROM CUSTOMER C
INNER JOIN ADDRESS A ON C.ADDRESS_ID = A.ADDRESS_ID
ORDER BY TOTAL_MONEY_SPENT DESC;

-- ¿Qué categorías de películas tienen mayor duración (comparando el promedio)? Ordenar por promedio en orden descendente.
SELECT C.NAME, AVG(LENGTH) AS AVERAGE_DURATION 
FROM CATEGORY C
INNER JOIN FILM_CATEGORY FC ON FC.CATEGORY_ID = C.CATEGORY_ID
INNER JOIN FILM F ON F.FILM_ID = FC.FILM_ID
GROUP BY C.NAME
ORDER BY AVERAGE_DURATION DESC;

-- Mostrar ventas por calificación de película.
SELECT RATING, CONCAT(SUM(P.AMOUNT), ' USD') AS SALES 
FROM FILM F
INNER JOIN INVENTORY I ON I.FILM_ID = F.FILM_ID
INNER JOIN RENTAL R ON R.INVENTORY_ID = I.INVENTORY_ID
INNER JOIN PAYMENT P ON R.RENTAL_ID = P.RENTAL_ID
GROUP BY RATING
ORDER BY SALES DESC;
