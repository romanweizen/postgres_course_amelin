-- common table expression CTE
WITH filtered_category AS (
SELECT
	fc.category_id,
	c."name" AS category_name,
	count(*) AS film_cnt
FROM
	film_category fc
JOIN category c
		USING(category_id)
GROUP BY
	fc.category_id,
	category_name
HAVING
	count(*) > 70
)
SELECT
	f.title,
	c.category_name,
	c.film_cnt AS film_category_cnt
FROM
	film f
JOIN film_category fc ON
	f.film_id = fc.film_id
JOIN filtered_category c ON
	c.category_id = fc.category_id;