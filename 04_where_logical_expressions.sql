-- Basic filters (=, <, BETWEEN, LIKE)
SELECT
    *
FROM
    film
WHERE
    rental_rate = 4.99;

SELECT
    *
FROM
    film
WHERE
    rental_rate < 1;

SELECT
    *
FROM
    rental
WHERE
    rental_date BETWEEN '2005-05-26' AND '2005-05-29';

SELECT
    *
FROM
    film
WHERE
    lower(title) LIKE '%airport%';

SELECT
    *
FROM
    film
WHERE
    lower(title) LIKE '%airport_%';

SELECT
    *
FROM
    film
WHERE
    lower(description) NOT LIKE '%epic%';


-- NOT and <>
SELECT
    *
FROM
    film
WHERE
    rental_duration <> 7;

SELECT
    *
FROM
    film
WHERE
    NOT rental_duration = 7;


-- Combined logic (AND / OR / IN)

SELECT
    *
FROM
    film
WHERE
    rental_duration IN (6, 7)
    AND rental_rate > 1
    AND lower(title) LIKE 'p%';

SELECT
    *
FROM
    film
WHERE
    rental_duration = 1
    OR rental_duration = 6
    OR lower(title) LIKE 'p%';


-- Nested logical expressions

SELECT
    *
FROM
    film
WHERE
    rental_duration IN (6, 7)
    OR (rental_rate > 1
        AND lower(title) LIKE 'p%')
    OR (length BETWEEN 70 AND 120
        AND rating = 'PG');


-- Homework theme: Payment filters & actor filters (Homework #2)

SELECT
    *
FROM
    payment
WHERE
    amount > 7
    AND payment_date BETWEEN '2007-03-01' AND '2007-03-31';

SELECT
    *
FROM
    payment
WHERE
    amount > 7
    OR (amount >= 3.3 AND amount <= 5.5);

SELECT
    *
FROM
    payment
WHERE
    amount <= 7
    AND (amount NOT BETWEEN 3.3 AND 5.5);

SELECT
    *
FROM
    actor
WHERE
    lower(first_name) LIKE 'r%';

SELECT
    *
FROM
    actor
WHERE
    lower(last_name) NOT LIKE '%a%';
