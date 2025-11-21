-- Оконные функции  БАЗА

SELECT
	f.title,
	f.rating,
	f.length,
	min(f.length) OVER (PARTITION BY f.rating) AS min_rating_length,
	max(f.length) OVER (PARTITION BY f.rating) AS max_rating_length,
	sum(f.length) OVER (PARTITION BY f.rating) AS sum_rating_length,
	avg(f.length) OVER (PARTITION BY f.rating) AS avg_rating_length,
	count(f.length) OVER (PARTITION BY f.rating) AS count_rating_length,
	min(f.length) OVER () AS min_length
FROM
	film f
ORDER BY
	f.rating,
	f.length;

SELECT
	f.title,
	f.rating,
	f.length,
	min(f.length) OVER (w) AS min_rating_length,
	max(f.length) OVER (w) AS max_rating_length,
	sum(f.length) OVER (w) AS sum_rating_length,
	avg(f.length) OVER (w) AS avg_rating_length,
	count(f.length) OVER (w) AS count_rating_length,
	min(f.length) OVER (w) AS min_length
FROM
	film f
WINDOW w AS (PARTITION BY f.rating)
ORDER BY
	f.rating,
	f.length;

SELECT
	f.title,
	f.rating,
	f.length,
	ROW_NUMBER() OVER(PARTITION BY f.rating) AS rn,
	ROW_NUMBER() OVER(PARTITION BY f.rating ORDER BY f.length) AS rn,
	RANK() OVER(PARTITION BY f.rating ORDER BY f.length) AS rk,
	dense_rank() OVER(PARTITION BY f.rating ORDER BY f.length) AS drk
FROM
	film f

SELECT
	f.title,
	f.rating,
	f.length,
	lag(f.length, 1) OVER (PARTITION BY f.rating ORDER BY f.length) AS prev_len,
	lead(f.length, 1) OVER (PARTITION BY f.rating ORDER BY f.length) AS next_len,
	f.length - lag(f.length, 1) OVER (PARTITION BY f.rating ORDER BY f.length) AS diff_len
FROM
	film f
	
-- -- Оконные функции  ДОПОЛНИТЕЛЬНО
	
SELECT
	c."name",
	c.category_id,
	ntile(8) OVER (ORDER by c.category_id) AS group_id
FROM
	category c
	
SELECT
	r.rental_date::date,
	count(*),
	lag(count(*), 1) OVER(ORDER BY r.rental_date::date) AS prev_cnt,
	lead(count(*), 1) OVER(ORDER BY r.rental_date::date) AS lead_cnt,
	count(*) - lag(count(*), 1) OVER(ORDER BY r.rental_date::date) AS diff_cnt
FROM
	rental r
GROUP BY r.rental_date::date
ORDER BY r.rental_date::date

WITH rent_day AS (
SELECT
	r.rental_date::date AS rent_day,
	count(*) AS cnt
FROM
	rental r
GROUP BY
	r.rental_date::date
)
SELECT
	r.rent_day,
	r.cnt,
	sum(r.cnt) OVER (ORDER BY r.rent_day ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS three_days_cnt, -- создаются рамки для сравнения
	sum(r.cnt) OVER (ORDER BY r.rent_day ROWS BETWEEN CURRENT ROW AND CURRENT ROW) AS current_cnt,
	sum(r.cnt) OVER (ORDER BY r.rent_day ROWS BETWEEN 3 PRECEDING AND 3 FOLLOWING) AS week_cnt,
	sum(r.cnt) OVER (ORDER BY r.rent_day ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_total,
	sum(r.cnt) OVER (ORDER BY r.rent_day ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS total
FROM
	rent_day r;

SELECT
	f.title,
	f.rating,
	f.length,
	sum(f.length) OVER(PARTITION BY f.rating ORDER BY f.length ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cum_length_row,
	sum(f.length) OVER(PARTITION BY f.rating ORDER BY f.length RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cum_length_range,
	-- считает все родственные строки (с одинаковыми значениями)
	sum(f.length) OVER(PARTITION BY f.rating),
	sum(f.length) OVER(PARTITION BY f.rating ORDER BY f.length),
	sum(f.length) OVER(PARTITION BY f.rating ORDER BY f.length, f.film_id), -- правильный накопительный итог
	sum(f.length) OVER(PARTITION BY f.rating ORDER BY f.length RANGE BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING)
	FROM
	film f;

SELECT
	f.title,
	f.rating,
	f.length,
	first_value(f.length) OVER(PARTITION BY f.rating ORDER BY f.length) AS frst_length,
	last_value(f.length) OVER(PARTITION BY f.rating ORDER BY f.length) AS last_length,
	last_value(f.length) OVER(PARTITION BY f.rating ORDER BY f.length RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS last_length
FROM
	film f
	


