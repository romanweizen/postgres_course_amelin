-- CTE (common table expression, общее табличное выражение), COALESCE, MATERIALIZED, NOT MATERIALIZED

WITH filtered_category AS (
SELECT
	fc.category_id,
	c."name" AS category_name,
	count(*) AS film_cnt
FROM
	film_category fc
JOIN category c
	ON
	fc.category_id = c.category_id
GROUP BY
	fc.category_id,
	category_name
HAVING
	count(*) > 70
)
SELECT
	f.title AS film_name,
	fc2.category_name,
	fc2.film_cnt
FROM
	film f
JOIN film_category fc
ON
	f.film_id = fc.film_id
JOIN filtered_category fc2
ON
	fc2.category_id = fc.category_id;

WITH filtered_category AS (
SELECT
	fc.category_id,
	c."name" AS category_name,
	count(*) AS film_cnt
FROM
	film_category fc
JOIN category c
	ON
	fc.category_id = c.category_id
GROUP BY
	fc.category_id,
	category_name
HAVING
	count(*) > 70
),
film_amount AS (
SELECT
	i.film_id,
	sum(p.amount) AS amount
FROM
	inventory i
JOIN rental r
	ON
	i.inventory_id = r.inventory_id
JOIN payment p
	ON
	r.rental_id = p.rental_id
GROUP BY
	film_id
)
SELECT
	f.title AS film_name,
	fc2.category_name,
	fc2.film_cnt,
	COALESCE(fa.amount, 0) AS film_amount
FROM
	film f
JOIN film_category fc
ON
	f.film_id = fc.film_id
JOIN filtered_category fc2
ON
	fc2.category_id = fc.category_id
LEFT JOIN film_amount fa
ON
	fa.film_id = fc.film_id;

WITH filtered_category AS (
SELECT
	fc.category_id,
	c."name" AS category_name,
	count(*) AS film_cnt
FROM
	film_category fc
JOIN category c
	ON
	fc.category_id = c.category_id
GROUP BY
	fc.category_id,
	category_name
HAVING
	count(*) > 70
),
film_amount AS (
SELECT
	i.film_id,
	sum(p.amount) AS amount
FROM
	inventory i
JOIN rental r
	ON
	i.inventory_id = r.inventory_id
JOIN payment p
	ON
	r.rental_id = p.rental_id
GROUP BY
	film_id
),
total_amount AS (
	SELECT sum(fa.amount) AS total_amount
	FROM film_amount fa
)
SELECT
	f.title AS film_name,
	fc2.category_name,
	fc2.film_cnt,
	COALESCE(fa.amount, 0) AS film_amount,
	ta.total_amount
FROM
	film f
JOIN film_category fc
ON
	f.film_id = fc.film_id
JOIN filtered_category fc2
ON
	fc2.category_id = fc.category_id
LEFT JOIN film_amount fa
ON
	fa.film_id = fc.film_id
CROSS JOIN total_amount ta;

WITH filtered_category AS (
SELECT
	fc.category_id,
	c."name" AS category_name,
	count(*) AS film_cnt
FROM
	film_category fc
JOIN category c
	ON
	fc.category_id = c.category_id
GROUP BY
	fc.category_id,
	category_name
HAVING
	count(*) > 70
),
film_amount AS (
SELECT
	i.film_id,
	sum(p.amount) AS amount
FROM
	inventory i
JOIN rental r
	ON
	i.inventory_id = r.inventory_id
JOIN payment p
	ON
	r.rental_id = p.rental_id
GROUP BY
	film_id
),
total_amount AS (
	SELECT sum(fa.amount) AS total_amount
	FROM film_amount fa
)
SELECT
	*
FROM
	film_amount fa;

WITH filtered_category AS MATERIALIZED (  -- MATERIALIZED указывает на то, что CTE будет создано, как временная таблица (по умолчанию CTE подставляется как подзапрос в запросе)
SELECT
	fc.category_id,
	c."name" AS category_name,
	count(*) AS film_cnt
FROM
	film_category fc
JOIN category c
	ON
	fc.category_id = c.category_id
GROUP BY
	fc.category_id,
	category_name
HAVING
	count(*) > 70
),
film_amount AS NOT MATERIALIZED (  -- NOT MATERIALIZED прямо указывает на то, чтобы временная таблица не создавалась
SELECT
	i.film_id,
	sum(p.amount) AS amount
FROM
	inventory i
JOIN rental r
	ON
	i.inventory_id = r.inventory_id
JOIN payment p
	ON
	r.rental_id = p.rental_id
GROUP BY
	film_id
),
total_amount AS NOT MATERIALIZED (  -- по умолчанию, если CTE используется 1 раз - оно не материализуется, более 1 раза - материализуется (создается временная таблица)
	SELECT sum(fa.amount) AS total_amount
	FROM film_amount fa
)
SELECT
	f.title AS film_name,
	fc2.category_name,
	fc2.film_cnt,
	COALESCE(fa.amount, 0) AS film_amount,
	ta.total_amount
FROM
	film f
JOIN film_category fc
ON
	f.film_id = fc.film_id
JOIN filtered_category fc2
ON
	fc2.category_id = fc.category_id
LEFT JOIN film_amount fa
ON
	fa.film_id = fc.film_id
CROSS JOIN total_amount ta;

-- Homework
WITH actors_cnt AS (
SELECT
	fa.film_id,
	count(fa.actor_id) AS actor_cnt
FROM
	film_actor fa
GROUP BY
	fa.film_id),
amount_sum AS (
SELECT
	i.film_id,
	sum(p.amount) AS amount
FROM
	inventory i
JOIN rental r
		USING (inventory_id)
JOIN payment p
		USING (rental_id)
GROUP BY
	i.film_id
)
SELECT
	f.title,
	ac.actor_cnt,
	"as".amount
FROM
	film f
JOIN actors_cnt ac
		USING (film_id)
JOIN amount_sum "as"
		USING (film_id)
