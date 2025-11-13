-- INNER JOIN
SELECT f.title, l.name AS language_name
FROM film f
JOIN "language" l ON f.language_id = l.language_id;

-- Multi-table join
SELECT f.title, concat(a.first_name, ' ', a.last_name) AS actor_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id;

-- JOIN using USING
SELECT DISTINCT concat(a.first_name, ' ', a.last_name)
FROM actor a
JOIN film_actor fa USING (actor_id)
JOIN film f       USING (film_id);

-- LEFT JOIN (films without inventory)
SELECT f.title
FROM film f
LEFT JOIN inventory i USING (film_id)
WHERE i.inventory_id IS NULL;

-- RIGHT JOIN
SELECT f.title
FROM inventory i
RIGHT JOIN film f USING (film_id)
WHERE i.inventory_id IS NULL;

-- FULL JOIN
SELECT f.title
FROM inventory i
FULL JOIN film f USING (film_id)
WHERE i.inventory_id IS NULL;

-- CROSS JOIN
SELECT f.title, a.first_name || ' ' || a.last_name
FROM film f CROSS JOIN actor a;

-- Homework theme: JOIN tasks (Homework 5)

-- Actors in "Chamber Italian"
SELECT
    a.first_name || ' ' || a.last_name AS actor_name
FROM actor a
JOIN film_actor fa USING (actor_id)
JOIN film f USING (film_id)
WHERE f.title = 'Chamber Italian';
