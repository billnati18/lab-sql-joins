-- 1. List the number of films per category.
SELECT * FROM category;
SELECT 
category_id,
COUNT(*) 
FROM film_category
GROUP BY category_id;

SELECT 
name,
number_of_movies
FROM 
(SELECT 
category_id,
COUNT(*) AS number_of_movies
FROM film_category
GROUP BY category_id) as grouped_category
JOIN category ON category.category_id=grouped_category.category_id;

SELECT 
category.name,
COUNT(film_category.film_id) 
FROM category
INNER JOIN film_category ON category.category_id=film_category.category_id
GROUP BY category.name;

SELECT 
IFNULL(category.name,'No category') AS category,
COUNT(film_category.film_id) AS number_film
FROM category
INNER JOIN film_category ON category.category_id=film_category.category_id
RIGHT JOIN film ON film_category.film_id=film.film_id
GROUP BY IFNULL(category.name,'No category');

-- 2. Retrieve the store ID, city, and country for each store.
SELECT * FROM store;
SELECT * FROM city;

SELECT *
FROM store LEFT JOIN address ON store.address_id = address.address_id
LEFT JOIN city ON city.city_id=address.city_id
LEFT JOIN country ON country.country_id=city.country_id;

SELECT 
store.store_id,
city.city,
country.country
FROM country RIGHT JOIN city ON country.country_id=city.country_id 
RIGHT JOIN address ON city.city_id=address.city_id
RIGHT JOIN store ON store.address_id = address.address_id;
    
-- 3. Calculate the total revenue generated by each store in dollars.
SELECT * FROM staff;
SELECT * FROM customer;
SELECT * FROM rental;
SELECT * FROM inventory;
SELECT * FROM payment;

SELECT 
store_id,
SUM(amount)
FROM payment
JOIN staff ON payment.staff_id=staff.staff_id
GROUP BY store_id;

SELECT 
store_id,
SUM(amount)
FROM payment
JOIN customer ON payment.customer_id=customer.customer_id
GROUP BY store_id;

select s.store_id, 
sum(p.amount) as `total_revenue`
from store as s
join payment as p
on s.manager_staff_id=p.staff_id 
group by s.store_id;

SELECT 
staff_id,
SUM(amount)
FROM payment
GROUP BY staff_id;

-- 4. Determine the average running time of films for each category    
SELECT 
category.name,
AVG(length) AS average_running_time
FROM film
JOIN film_category ON film_category.film_id=film.film_id
JOIN category ON film_category.category_id=	category.category_id
GROUP BY category.name;

-- 5. Identify the film categories with the longest average running time.
SELECT 
category.name,
ROUND(AVG(length)) AS average_running_time
FROM film
JOIN film_category ON film_category.film_id=film.film_id
JOIN category ON film_category.category_id=	category.category_id
GROUP BY category.name
ORDER BY AVG(length) DESC
LIMIT 2;


SELECT 
	category.name,
	ROUND(AVG(length)) AS average_running_time
FROM film
JOIN film_category ON film_category.film_id=film.film_id
JOIN category ON film_category.category_id=	category.category_id
GROUP BY category.name
HAVING ROUND(AVG(length)) = (SELECT 
MAX( average_running_time)
FROM
(SELECT 
category.name,
ROUND(AVG(length)) AS average_running_time
FROM film
JOIN film_category ON film_category.film_id=film.film_id
JOIN category ON film_category.category_id=	category.category_id
GROUP BY category.name) as grouped_length);


-- 6. Display the top 10 most frequently rented movies in descending order.

SELECT * FROM rental;
SELECT * FROM inventory;
SELECT * FROM film;

SELECT 
	film.title,
    COUNT(rental.rental_id)
FROM rental
JOIN inventory ON rental.inventory_id=inventory.inventory_id
JOIN film ON inventory.film_id=film.film_id
GROUP BY film.film_id,film.title
ORDER BY COUNT(rental.rental_id) DESC
LIMIT 10;

-- 7. Determine if "Academy Dinosaur" can be rented from Store 1
SELECT *
 FROM inventory 
 JOIN film ON inventory.film_id=film.film_id
 WHERE store_id=1 and title='ACADEMY DINOSAUR';

-- 8. Provide a list of all distinct film titles, along with their availability status in 
--    the inventory. Include a column indicating whether each title is 'Available' or 
--   'NOT available.' Note that there are 42 titles that are not in the inventory, 
--    and this information can be obtained using a CASE statement combined with IFNULL."
SELECT 
title,
IF(inventory_id is null,'Not available','Available'),
CASE WHEN inventory_id is null then 'Not available' else 'Available' END,
IFNULL(inventory_id,'Not available')
FROM inventory 
RIGHT JOIN film ON inventory.film_id=film.film_id
ORDER BY inventory_id;

