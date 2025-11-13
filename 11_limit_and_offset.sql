-- Limit result set
SELECT *
FROM film
ORDER BY title
LIMIT 10;

-- Skip rows
SELECT *
FROM film
ORDER BY title
OFFSET 10
LIMIT 10;

-- Homework theme: TOP actors with OFFSET (Homework 8)

SELECT
    concat(a.first_name, ', ', a.last_name) AS full_name,
    count(*) AS film_count
FROM actor a
JOIN film_actor fa USING (actor_id)
GROUP BY full_name, actor_id
ORDER BY film_count DESC
OFFSET 5
LIMIT 5;
