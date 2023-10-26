SELECT DISTINCT(MIN(replacement_cost))
FROM film

SELECT 
	SUM(CASE WHEN replacement_cost BETWEEN 9.99 AND 19.99 THEN 1 ELSE 0 END) AS low,
	SUM(CASE WHEN replacement_cost BETWEEN 20.00 AND 24.99 THEN 1 ELSE 0 END) AS medium,
	SUM(CASE WHEN replacement_cost BETWEEN 25.00 AND 29.99 THEN 1 ELSE 0 END) AS high
FROM film

SELECT title, length, c.name
FROM film f
LEFT JOIN film_category fc
ON f.film_id = fc.film_id
JOIN category c
ON fc.category_id = c.category_id
WHERE c.name LIKE '%Drama%' OR c.name LIKE '%Sport%'
ORDER BY 3 DESC, 2 DESC

SELECT c.name, COUNT(*)
FROM film f
LEFT JOIN film_category fc
ON f.film_id = fc.film_id
JOIN category c
ON fc.category_id = c.category_id
GROUP BY 1
ORDER BY 2 DESC

SELECT first_name, last_name, COUNT(*)
FROM film f
LEFT JOIN film_actor fa
ON f.film_id = fa.film_id
JOIN actor a
ON fa.actor_id = a.actor_id
GROUP BY 1,2
ORDER BY 3 DESC

SELECT COUNT(*)
FROM address a
LEFT JOIN customer c
ON c.address_id = a.address_id
WHERE a.address_id NOT IN (SELECT address_id FROM customer)
					   
SELECT city, SUM(amount)
FROM payment p
JOIN customer c1
ON p.customer_id = c1.customer_id
JOIN address a
ON c1.address_id = a.address_id
JOIN city c2
ON a.city_id = c2.city_id
GROUP BY 1
ORDER BY 2 DESC

SELECT country ||', '|| city, SUM(amount)
FROM payment p
JOIN customer c1
ON p.customer_id = c1.customer_id
JOIN address a
ON c1.address_id = a.address_id
JOIN city c2
ON a.city_id = c2.city_id
JOIN country c3
ON c2.country_id = c3.country_id
GROUP BY 1
ORDER BY 2 

SELECT staff_id, ROUND(AVG(total_amt),2)
FROM
(SELECT staff_id, customer_id, SUM(AMOUNT) AS total_amt
FROM payment
GROUP BY 1,2) A
GROUP BY 1

SELECT ROUND(AVG(total_rev),2) AS daily_rev
FROM
(SELECT EXTRACT(dow from payment_date),EXTRACT(day from payment_date),
 SUM(amount) AS total_rev
FROM payment
WHERE EXTRACT(dow from payment_date) = 0
GROUP BY 1,2
) A

SELECT title,length
FROM film f1
WHERE length >
(SELECT AVG(length) FROM film f2
WHERE f1.replacement_cost = f2.replacement_cost)
ORDER BY 2 

SELECT district, ROUND(AVG(life_time_value),2) AS avg_life_time_value
FROM 
(SELECT c.customer_id, district, SUM(amount) AS life_time_value FROM payment p
JOIN customer c
ON p.customer_id = c.customer_id
JOIN address a	 
ON c.address_id = a.address_id
GROUP BY 1,2) sq1
GROUP BY 1
ORDER BY 2 DESC

SELECT title, amount, name, payment_id, 
(SELECT SUM(amount) FROM payment p
LEFT JOIN rental r
ON p.rental_id = r.rental_id
LEFT JOIN inventory i
ON r.inventory_id = i.inventory_id
LEFT JOIN film f
ON i.film_id = f.film_id
LEFT JOIN film_category fc
ON f.film_id = fc.film_id
LEFT JOIN category c1
ON fc.category_id = c1.category_id
WHERE c1.name = c.name)

FROM payment p 
LEFT JOIN rental r
ON p.rental_id = r.rental_id
LEFT JOIN inventory i
ON r.inventory_id = i.inventory_id
LEFT JOIN film f
ON i.film_id = f.film_id
LEFT JOIN film_category fc
ON f.film_id = fc.film_id
LEFT JOIN category c
ON fc.category_id = c.category_id
ORDER BY 3 ,4

SELECT title, name, SUM(amount) 
FROM payment p
LEFT JOIN rental r
ON p.rental_id = r.rental_id
LEFT JOIN inventory i
ON r.inventory_id = i.inventory_id
LEFT JOIN film f
ON i.film_id = f.film_id
LEFT JOIN film_category fc
ON f.film_id = fc.film_id
LEFT JOIN category c
ON fc.category_id = c.category_id
WHERE name  = 'Animation'
GROUP BY 2,1
ORDER BY 3 DESC

