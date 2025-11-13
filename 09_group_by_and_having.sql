-- Simple grouping
SELECT rating FROM film GROUP BY rating;

-- Aggregations by rating
SELECT
    rating,
    count(*) AS films_count,
    sum(length),
    max(length),
    min(length),
    avg(length)
FROM film
GROUP BY rating;

-- Grouping with substring
SELECT
    rating,
    rental_rate,
    substring(title, 1, 1) AS letter,
    count(*)
FROM film
GROUP BY rating, rental_rate, substring(title,1,1);

-- Inventory count per film
SELECT f.title, count(i.film_id)
FROM inventory i
JOIN film f USING (film_id)
GROUP BY f.title;

-- HAVING: filter after aggregation
SELECT
    f.title,
    count(*) AS payment_count
FROM film f
JOIN inventory USING (film_id)
JOIN rental USING (inventory_id)
JOIN payment USING (rental_id)
GROUP BY f.title
HAVING count(*) > 10;

-- Homework theme: Aggregation tasks (Homework 6)

-- Total revenue per film
SELECT f.title, sum(p.amount) AS amount
FROM film f
JOIN inventory i USING (film_id)
JOIN rental r USING (inventory_id)
JOIN payment p USING (rental_id)
GROUP BY f.title
ORDER BY amount DESC;

-- Actors with >= 20 films
SELECT
    concat(a.first_name, ' ', a.last_name) AS actor,
    count(fa.film_id) AS film_count
FROM actor a
JOIN film_actor fa USING (actor_id)
GROUP BY actor
HAVING count(fa.film_id) >= 20;

-- Number of films longer than 120 min
SELECT count(*)
FROM film
WHERE length > 120;
