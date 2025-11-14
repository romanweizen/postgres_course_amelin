-- FILTER

SELECT
	count(*)
FROM
	film;

SELECT
	count(*)
FROM
	film
WHERE length > 100;

SELECT
	count(*),
	count(*) FILTER (WHERE length > 100),
	count(*) FILTER (WHERE length > 120),
	count(*) FILTER (WHERE length > 140)
FROM
	film;

SELECT
	f.rating,
	count(*),
	count(*) FILTER (WHERE length > 100),
	count(*) FILTER (WHERE length > 120),
	count(*) FILTER (WHERE length > 140)
FROM
	film f
GROUP BY rating;

SELECT
	*
FROM
	film f
ORDER BY
	rating,
	length DESC;

-- Homework
SELECT
	f.rating,
	count(*) AS films_by_rating,
	count(*) FILTER (
WHERE
	f.rental_duration >= 5) AS film_rd_more_or_equal_5
FROM
	film f
GROUP BY
	f.rating;