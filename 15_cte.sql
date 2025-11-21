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
	COALESCE(ac.actor_cnt, 0) AS actor_cnt,
	COALESCE(ams.amount, 0) AS amount
FROM
	film f
LEFT JOIN actors_cnt ac  -- чтобы отобразить фильмы без актёров
		USING (film_id)
LEFT JOIN amount_sum ams  -- чтобы отобразить фильмы без продаж
		USING (film_id)

WITH film_total_sales AS (
SELECT
	i.film_id AS film_id,
	sum(p.amount) AS amount
FROM
	inventory i
JOIN rental r
		USING (inventory_id)
JOIN payment p
		USING (rental_id)
GROUP BY
	film_id
),
total_sales AS (  -- можно было присоединить верхнее CTE film_total_sales
SELECT
	sum(p.amount) AS total_amount
FROM
	inventory i
JOIN rental r
		USING (inventory_id)
JOIN payment p
		USING (rental_id)
)
SELECT
	f.title,
	COALESCE (fts.amount, 0) AS film_total_amount,
	COALESCE (ts.total_amount, 0) AS total_amount,
	COALESCE(round((fts.amount / ts.total_amount * 100), 3), 0) || '%' AS share_of_sales
FROM
	film f
LEFT JOIN film_total_sales fts
		USING (film_id)
CROSS JOIN total_sales ts
ORDER BY share_of_sales DESC;

		



WITH makers AS (
SELECT
	p.maker AS maker
FROM
	product p
JOIN printer pr
ON
	p.model = pr.model
INTERSECT
SELECT
	p.maker AS maker
FROM
	product p
JOIN pc pc
ON
	p.model = pc.model
)
SELECT
	m.maker AS maker,
	avg(pc.speed) AS avg_pc_speed
FROM
	makers m
JOIN product p
ON
	m.maker = p.maker
JOIN pc pc
ON
	p.model = pc.model
GROUP BY
	m.maker;

SELECT
	p.maker,
	avg(hd) AS avg_hd_size_pc
FROM
	product p
JOIN pc pc
ON
	p.model = pc.model
WHERE
	p.maker IN (
	SELECT
		p.maker
	FROM
		product p
	JOIN printer pr ON
		p.model = pr.model)
GROUP BY
	p.maker;



