# Question 1:
# Task: Create a list of all the different (distinct) replacement costs of the films.
# Question: What's the lowest replacement cost?
# Answer: 9.99
	
SELECT DISTINCT(MIN(replacement_cost))
FROM film
	
# Question 2:
# Task: Write a query that gives an overview of how many films have replacements costs in the following cost ranges
# low: 9.99 - 19.99
# medium: 20.00 - 24.99
# high: 25.00 - 29.99
# Question: How many films have a replacement cost in the "low" group?
# Answer: 514
	
SELECT 
	SUM(CASE WHEN replacement_cost BETWEEN 9.99 AND 19.99 THEN 1 ELSE 0 END) AS low,
	SUM(CASE WHEN replacement_cost BETWEEN 20.00 AND 24.99 THEN 1 ELSE 0 END) AS medium,
	SUM(CASE WHEN replacement_cost BETWEEN 25.00 AND 29.99 THEN 1 ELSE 0 END) AS high
FROM film
	
# Question 3:
# Task: Create a list of the film titles including their title, length, and category name ordered descendingly by length. Filter the results to only the movies in the category 'Drama' or 'Sports'.
# Question: In which category is the longest film and how long is it?
# Answer: Sports and 184
	
SELECT title, length, c.name
FROM film f
LEFT JOIN film_category fc
ON f.film_id = fc.film_id
JOIN category c
ON fc.category_id = c.category_id
WHERE c.name LIKE '%Drama%' OR c.name LIKE '%Sport%'
ORDER BY 3 DESC, 2 DESC
	
# Question 4:
# Task: Create an overview of how many movies (titles) there are in each category (name).
# Question: Which category (name) is the most common among the films?
# Answer: Sports with 74 titles

SELECT c.name, COUNT(*)
FROM film f
LEFT JOIN film_category fc
ON f.film_id = fc.film_id
JOIN category c
ON fc.category_id = c.category_id
GROUP BY 1
ORDER BY 2 DESC

# Question 5:
# Task: Create an overview of the actors' first and last names and in how many movies they appear in.
# Question: Which actor is part of most movies??
# Answer: Susan Davis with 54 movies

SELECT first_name, last_name, COUNT(*)
FROM film f
LEFT JOIN film_actor fa
ON f.film_id = fa.film_id
JOIN actor a
ON fa.actor_id = a.actor_id
GROUP BY 1,2
ORDER BY 3 DESC

# Question 6:
# Task: Create an overview of the addresses that are not associated to any customer.
# Question: How many addresses are that?
# Answer: 4

SELECT COUNT(*)
FROM address a
LEFT JOIN customer c
ON c.address_id = a.address_id
WHERE a.address_id NOT IN (SELECT address_id FROM customer)

# Question 7:
# Task: Create an overview of the cities and how much sales (sum of amount) have occurred there.
# Question: Which city has the most sales?
# Answer: Cape Coral with a total amount of 221.55

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

# Question 8:
# Task: Create an overview of the revenue (sum of amount) grouped by a column in the format "country, city".
# Question: Which country, city has the least sales?
# Answer: United States, Tallahassee with a total amount of 50.85.
					   
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

# Question 9:
# Task: Create a list with the average of the sales amount each staff_id has per customer.
# Question: Which staff_id makes on average more revenue per customer?
# Answer: staff_id 2 with an average revenue of 56.64 per customer.

SELECT staff_id, ROUND(AVG(total_amt),2)
FROM
(SELECT staff_id, customer_id, SUM(AMOUNT) AS total_amt
FROM payment
GROUP BY 1,2) A
GROUP BY 1

# Question 10:
# Task: Create a query that shows average daily revenue of all Sundays.
# Question: What is the daily average revenue of all Sundays?
# Answer: 1410.65

SELECT ROUND(AVG(total_rev),2) AS daily_rev
FROM
(SELECT EXTRACT(dow from payment_date),EXTRACT(day from payment_date),
 SUM(amount) AS total_rev
FROM payment
WHERE EXTRACT(dow from payment_date) = 0
GROUP BY 1,2
) A

# Question 11:
# Task: Create a list of movies - with their length and their replacement cost - that are longer than the average length in each replacement cost group.
# Question: Which two movies are the shortest on that list and how long are they?
# Answer: CELEBRITY HORN and SEATTLE EXPECTATIONS with 110 minutes.

SELECT title,length
FROM film f1
WHERE length >
(SELECT AVG(length) FROM film f2
WHERE f1.replacement_cost = f2.replacement_cost)
ORDER BY 2 

# Question 12:
# Task: Create a list that shows the "average customer lifetime value" grouped by the different districts.
# Example: If there are two customers in "District 1" where one customer has a total (lifetime) spent of $1000 and the second customer has a total spent of $2000 then the "average customer lifetime spent" in this district is $1500.
# So, first, you need to calculate the total per customer and then the average of these totals per district.
# Question: Which district has the highest average customer lifetime value?
# Answer: Saint-Denis with an average customer lifetime value of 216.54.
	
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

# Question 13:
# Task: Create a list that shows all payments including the payment_id, amount, and the film category (name) plus the total amount that was made in this category. Order the results ascendingly by the category (name) and as second order criterion by the payment_id ascendingly.
# Question: What is the total revenue of the category 'Action' and what is the lowest payment_id in that category 'Action'?
# Answer: Total revenue in the category 'Action' is 4375.85 and the lowest payment_id in that category is 16055.

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

# Bonus question 14:
# Task: Create a list with the top overall revenue of a film title (sum of amount per title) for each category (name).
# Question: Which is the top-performing film in the animation category?
# Answer: DOGMA FAMILY with 178.70.
	
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

