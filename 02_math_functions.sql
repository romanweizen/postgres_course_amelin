-- Basic arithmetic
SELECT
    1 AS one,
    5 + 6 AS sum_result,
    10 - 3 AS diff_result,
    4 * 5 AS mult_result,
    15 / 2 AS int_div_result;

-- Compute film length per rental day
SELECT
    length,
    rental_duration,
    title,
    length / rental_duration AS length_per_day
FROM
    film;

-- MOD (remainder)
SELECT
    *
FROM
    payment
WHERE
    MOD(payment_id, 10) = 1;

SELECT
    MOD(actor_id, 10) AS mod_id,
    *
FROM
    actor
ORDER BY
    MOD(actor_id, 10);

-- Safe division using CASE
SELECT
    CASE
        WHEN div(f.rental_rate, 1) = 0 THEN 0
        ELSE 1 / div(f.rental_rate, 1)
    END AS inverted_rate
FROM
    film f;
