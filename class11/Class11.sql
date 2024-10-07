use sakila;

#Find all the film titles that are not in the inventory.
SELECT i.inventory_id, f.* 
FROM film f 
LEFT OUTER JOIN inventory i USING(film_id) 
WHERE i.inventory_id IS NULL;

#Find all the films that are in the inventory but were never rented.
SELECT f.title, i.inventory_id 
FROM film f
JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.rental_id IS NULL;

#Generate a report with customer (first, last) name, store id, film title, when the film was rented and returned for each of these customers. Order by store_id, customer last_name.
SELECT c.first_name, c.last_name, r.store_id, f.title, r.rental_date, r.return_date
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
ORDER BY r.store_id, c.last_name;

#Show sales per store (money of rented films).
#Show store's city, country, manager info, and total sales (money). (Optional: Use concat to show city and country and manager's first and last name).
SELECT s.store_id, 
       CONCAT(c.city, ', ', co.country) AS Location, 
       CONCAT(st.first_name, ' ', st.last_name) AS Manager,
       CONCAT('$', COALESCE(SUM(p.amount), 0)) AS total_sales
FROM store s
JOIN address a ON s.address_id = a.address_id
JOIN city c ON a.city_id = c.city_id
JOIN country co ON c.country_id = co.country_id
JOIN staff st ON s.manager_staff_id = st.staff_id
LEFT JOIN inventory i ON s.store_id = i.store_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
LEFT JOIN payment p ON r.rental_id = p.rental_id
GROUP BY s.store_id, c.city, co.country, st.first_name, st.last_name;

#Which actor has appeared in the most films?
SELECT a.first_name, a.last_name, COUNT(fa.film_id) AS film_count
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
ORDER BY film_count DESC
LIMIT 1;
