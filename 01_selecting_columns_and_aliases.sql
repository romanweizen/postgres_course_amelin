-- 1. SELECT all columns
SELECT
    *
FROM
    film;

SELECT
    *
FROM
    actor;

-- 2. Select specific columns
SELECT
    title,
    description
FROM
    film;

SELECT
    first_name,
    last_name
FROM
    actor;

-- 3. Using AS for column aliasing
SELECT
    title AS film_title,
    description AS film_description
FROM
    film;

SELECT
    first_name AS name,
    last_name  AS surname
FROM
    actor;

-- 4. Table aliases + readable column names
SELECT
    f.title       AS film_title,
    l.name        AS language_name,
    f.language_id AS lang_id
FROM
    film f
JOIN "language" l
    ON f.language_id = l.language_id;

-- 5. Ordering by aliases and positions
SELECT
    first_name AS f,
    last_name  AS l,
    actor_id   AS i
FROM
    actor
ORDER BY
    f,
    l;

SELECT
    last_name AS l,
    first_name AS f,
    actor_id AS i
FROM
    actor
ORDER BY
    1,
    2;
