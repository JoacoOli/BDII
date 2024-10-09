use sakila;

#Add a new customer
INSERT INTO customer (store_id, address_id, first_name, last_name, email) 
VALUES (
    1,
    (SELECT MAX(address_id) 
     FROM address a 
     INNER JOIN city c ON c.city_id = a.city_id 
     INNER JOIN country co ON c.country_id = co.country_id 
     WHERE co.country = 'United States'),
    'JUAN INSERTADO',
    'INSERTADO',
    'INSERTADO@gmail.com'
);

#Add a renta
INSERT INTO rental (rental_date, inventory_id, staff_id, customer_id) 
VALUES (
    NOW(),
    (SELECT inventory_id 
     FROM inventory 
     WHERE film_id = (SELECT film_id FROM film WHERE title = 'PRIDE ALAMO' LIMIT 1) 
     LIMIT 1),
    (SELECT staff_id FROM staff WHERE store_id = 2 LIMIT 1),
    (SELECT customer_id FROM customer LIMIT 1)
);

#Update film year based on the rating
UPDATE film
SET release_year = CASE
    WHEN rating = 'G' THEN 2001
    WHEN rating = 'PG' THEN 2005
    WHEN rating = 'PG-13' THEN 2010
    WHEN rating = 'R' THEN 2015
    ELSE release_year  
END;

#Return a film
SELECT rental_id
INTO @latest_rental_id
FROM rental
WHERE return_date IS NULL
ORDER BY rental_date DESC
LIMIT 1;


UPDATE rental
SET return_date = NOW()  
WHERE rental_id = @latest_rental_id;

#Try to delete a film
DELETE FROM film 
WHERE film_id = (SELECT film_id FROM film WHERE title = 'Film Title' LIMIT 1);

#Rent a film
SELECT inventory_id 
INTO @available_inventory_id
FROM inventory 
WHERE film_id = (SELECT film_id FROM film ORDER BY film_id DESC LIMIT 1) 
LIMIT 1;

INSERT INTO rental (rental_date, inventory_id, customer_id, return_date, staff_id)
VALUES (
    NOW(), 
    @available_inventory_id, 
    (SELECT customer_id FROM customer WHERE first_name = 'John' AND last_name = 'Doe'),  
    NULL, 
    (SELECT staff_id FROM staff WHERE store_id = 2 LIMIT 1) 
);

INSERT INTO payment (amount, customer_id, rental_id, payment_date, staff_id)
VALUES (
    5.99, 
    (SELECT customer_id FROM customer WHERE first_name = 'John' AND last_name = 'Doe'),  
    LAST_INSERT_ID(),
    NOW(), 
    (SELECT staff_id FROM staff WHERE store_id = 2 LIMIT 1)  
);
