-- Basic sorting
SELECT *
FROM actor
ORDER BY first_name;

SELECT *
FROM actor
ORDER BY first_name, last_name;

-- ASC / DESC
SELECT *
FROM actor
ORDER BY first_name DESC, last_name ASC;

-- ORDER BY expression
SELECT *
FROM actor
ORDER BY first_name || last_name;

-- ORDER BY MOD expression
SELECT MOD(actor_id, 10) AS mod_id, *
FROM actor
ORDER BY MOD(actor_id, 10);

-- Alias / position
SELECT title, length AS len
FROM film
ORDER BY len;

SELECT title, length AS len
FROM film
ORDER BY 2;

-- NULL ordering
SELECT *
FROM address
ORDER BY address2 NULLS FIRST;

SELECT *
FROM address
ORDER BY address2 DESC NULLS LAST;

-- Homework theme: ORDER BY practice (Homework 3)
SELECT
    length,
    rental_duration,
    title,
    length / rental_duration AS div
FROM film
ORDER BY div DESC;
