-- Query order
SELECT
	f.title,
	f.rating,
	count(*) OVER (PARTITION BY f.rating) AS film_rating_cnt
FROM
	film f
LIMIT 10;


-- 1 with
WITH film_amount AS (
SELECT
		i.film_id,
		sum(p.amount) AS total_amount
FROM
		inventory i
JOIN rental r
		USING(inventory_id)
JOIN payment p
		USING(rental_id)
GROUP BY
	i.film_id
)
-- 6 select
-- 7 distinct
SELECT
	DISTINCT substring(f.title, 1, 3) AS short_title,
	f.rental_duration,
	count(*) OVER (PARTITION BY f.rental_duration) AS rent_dur_film_cnt,
	sum(fa.total_amount) AS total_amount
-- 2 from 
FROM
	film f
JOIN film_amount fa
		USING(film_id)
-- 3 where
WHERE
	f.rating = 'G'
-- 4 group by
GROUP BY
	substring(f.title, 1, 3),
	f.rental_duration
-- 5 having
HAVING
	count(*) = 1
-- 8 order by
ORDER BY
	total_amount
-- 9 limit offset
LIMIT 10
OFFSET 5;