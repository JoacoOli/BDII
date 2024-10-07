use sakila;

#Find the films with the shortest duration, show the title and rating.
SELECT title, rating 
FROM film 
WHERE length = (SELECT MIN(length) FROM film);

#Write a query that returns the title of the film which duration is the lowest. If there is more than one film with the lowest duration, the query returns an empty result set.
SELECT title 
FROM film 
WHERE length = (SELECT MIN(length) 
                FROM film) 
HAVING COUNT(*) = 1;

#Generate a report with a list of customers showing the lowest payments done by each of them. Show customer information, the address, and the lowest amount. Provide both solutions using ALL/ANY and MIN.
SELECT c.customer_id, c.first_name, c.last_name, a.address, MIN(p.amount) AS lowest_payment 
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
JOIN address a ON c.address_id = a.address_id
GROUP BY c.customer_id, c.first_name, c.last_name, a.address;


SELECT c.customer_id, c.first_name, c.last_name, a.address, p.amount AS lowest_payment 
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
JOIN address a ON c.address_id = a.address_id
WHERE p.amount <= ALL (SELECT MIN(amount) 
                       FROM payment 
                       WHERE customer_id = c.customer_id)
GROUP BY c.customer_id, c.first_name, c.last_name, a.address, p.amount;

#Generate a report that shows the customers information with the highest payment and the lowest payment in the same row.
SELECT c.customer_id, c.first_name, c.last_name, 
       MAX(p.amount) AS highest_payment, 
       MIN(p.amount) AS lowest_payment
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;
