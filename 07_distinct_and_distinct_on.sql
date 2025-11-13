-- Basic DISTINCT
SELECT DISTINCT rental_rate
FROM film
ORDER BY rental_rate;

-- Multiple columns
SELECT DISTINCT last_name, first_name
FROM actor;

-- DISTINCT on expression
SELECT DISTINCT substring(last_name, 1, 3)
FROM actor;

-- PostgreSQL: DISTINCT ON
SELECT DISTINCT ON (rental_rate)
    rental_rate, title
FROM film;

SELECT DISTINCT ON (inventory_id)
    rental_id, rental_date, inventory_id
FROM rental
ORDER BY inventory_id, rental_date DESC;

-- Homework theme: DISTINCT practice (Homework 4)
SELECT DISTINCT rental_duration
FROM film;

SELECT DISTINCT substring(first_name, 1, 3) AS prefix
FROM actor
ORDER BY prefix;
