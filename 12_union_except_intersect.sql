-- Homework theme: max price model across PC/Laptop/Printer
WITH union_table AS (
    SELECT model, price FROM PC
    UNION
    SELECT model, price FROM Laptop
    UNION
    SELECT model, price FROM Printer
)
SELECT model
FROM union_table
WHERE price = (SELECT max(price) FROM union_table);

-- UNION (deduplicated)
SELECT title FROM film WHERE rating='G'
UNION
SELECT title FROM film WHERE rental_rate > 4;

-- UNION ALL (keeps duplicates)
SELECT title, 'A' AS src FROM film WHERE rating='G'
UNION ALL
SELECT title, 'B' AS src FROM film WHERE rental_rate > 4;

-- EXCEPT (left minus right)
SELECT title FROM film WHERE rating='G'
EXCEPT
SELECT title FROM film WHERE rental_rate > 4;

-- INTERSECT (common rows)
SELECT title FROM film WHERE rating='G'
INTERSECT
SELECT title FROM film WHERE length > 120;

-- Homework theme: Homework 9
SELECT f.title
FROM film f
WHERE f.rating = 'G'
UNION ALL
SELECT f.title
FROM film f
JOIN film_actor fa USING (film_id)
JOIN actor a USING (actor_id)
WHERE a.last_name = 'Grant';
