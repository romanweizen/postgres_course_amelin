SELECT
	*
FROM
	address a;

SELECT
	*
FROM
	customer c;

SELECT
	*
FROM
	address a
WHERE
	NOT EXISTS (
	SELECT 
		1
	FROM
		customer c
	WHERE
		c.address_id = a.address_id
	);

SELECT
	*
FROM
	customer c
WHERE
	c.address_id = 1;

SELECT
	*
FROM
	film f
WHERE
	f.rental_duration IN (3, 4);

SELECT
	fc.category_id
FROM
	film_category fc
GROUP BY fc.category_id
HAVING count(*) > 70;
	
SELECT
	f.title,
	c."name" AS category_name
FROM
	film f
JOIN film_category fc ON
	fc.film_id = f.film_id
JOIN category c ON
	c.category_id = fc.category_id
WHERE
	fc.category_id IN (
	SELECT
		fc.category_id
	FROM
		film_category fc
	GROUP BY
		fc.category_id
	HAVING
		count(*) > 70);
	
SELECT 1 IN (1, 2);
	
SELECT 1 IN (12, 2);

SELECT 1 IN (1, 2, NULL);

SELECT 1 IN (2, 3, NULL);

SELECT NULL IN (2, 3, NULL);

SELECT NULL IN (2, 3);

SELECT
	DISTINCT p.amount
FROM
	payment p
ORDER BY
	p.amount;

SELECT
	*
FROM
	payment p
WHERE
	p.amount > ANY(SELECT
	DISTINCT p2.amount
FROM
	payment p2
)
ORDER BY p.amount
;

SELECT
	*
FROM
	payment p
WHERE
	p.amount >= ALL(SELECT
	DISTINCT p2.amount
FROM
	payment p2
)
ORDER BY p.amount
;

SELECT
	f.title,
	f.rating,
	(
	SELECT
		count(*)
	FROM
		film f2
	WHERE
		f2.rating = f.rating ) AS film_rating_cnt,
	(
	SELECT
		count(*)
	FROM
		film f2) AS film_cnt,
	(
	SELECT
		c."name"
	FROM
		film_category fc
	JOIN category c ON
		c.category_id = fc.category_id
	WHERE
		fc.film_id = f.film_id)  AS category_name
FROM
	film f
ORDER BY
	film_rating_cnt DESC;

SELECT
	fa.film_id
FROM
	film_actor fa
GROUP BY
	fa.film_id
HAVING count(*) > 10;

SELECT
	f.title
FROM
	film f
WHERE
	10 < (
	SELECT
		count(*)
	FROM
		film_actor fa
	WHERE
		fa.film_id = f.film_id
);

SELECT
	f.rating,
	count(*) AS cnt
FROM
	film f
GROUP BY
	f.rating;

SELECT
	f.title,
	f.rating,
	fr.cnt AS rating_film_cnt
FROM
	film f
JOIN
(
	SELECT
		f.rating,
		count(*) AS cnt
	FROM
		film f
	GROUP BY
		f.rating) AS fr ON
	f.rating = fr.rating;

-- Homework

SELECT
	l."name"
FROM
	"language" l
WHERE
	NOT EXISTS (
	SELECT 
		1
	FROM
		film f
	WHERE
		f.language_id = l.language_id
	);

SELECT
	f.title
FROM
	film f
JOIN film_actor fa
USING (film_id)
WHERE
	fa.actor_id IN (
	SELECT
		actor_id
	FROM
		actor
	WHERE
		last_name LIKE 'Chase%')
;

SELECT
	f.title,
	(
	SELECT
		DISTINCT
		l."name"
	FROM
		"language" l
	JOIN film f2 ON
		l.language_id = f2.language_id
	) AS "language"
FROM
	film f;

SELECT
	f.title,
	f.rental_duration,
	(
	SELECT
		count(f2.title)
	FROM
		film f2
	WHERE
		f.rental_duration = f2.rental_duration)
FROM
	film f
ORDER BY
	rental_duration;

SELECT * FROM film




