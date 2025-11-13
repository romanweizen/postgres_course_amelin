Понял, давай без лишних экспериментов — просто дам тебе **готовый цельный md-файл**.
Оглавление сделано так, как его генерит GitHub/VS Code: ссылки привязаны к заголовкам строго по их anchor-форме.

Скопируй всё, что ниже, **как есть** в файл `sql_handbook.md`.

---

# Mastering SQL – Professional Handbook

Complete SQL theory: from basics to advanced analytics and optimization.

---

## Table of Contents

- [Mastering SQL – Professional Handbook](#mastering-sql--professional-handbook)
  - [Table of Contents](#table-of-contents)
  - [1 Selecting columns and column aliasing in SQL](#1-selecting-columns-and-column-aliasing-in-sql)
  - [2 Mathematical functions in SQL](#2-mathematical-functions-in-sql)
  - [3 String functions in SQL](#3-string-functions-in-sql)
  - [4 Logical operators and expressions in WHERE](#4-logical-operators-and-expressions-in-where)
  - [5 Null and empty string](#5-null-and-empty-string)
  - [6 Sorting rows with ORDER BY](#6-sorting-rows-with-order-by)
  - [7 Getting unique values with DISTINCT](#7-getting-unique-values-with-distinct)
  - [8 Joining tables inner outer cross joins](#8-joining-tables-inner-outer-cross-joins)
  - [9 Grouping data group-by-and-having](#9-grouping-data-group-by-and-having)
  - [10 Conditions in expressions with CASE](#10-conditions-in-expressions-with-case)
  - [11 Limiting result set with LIMIT and OFFSET](#11-limiting-result-set-with-limit-and-offset)
  - [12 Combining results with UNION EXCEPT INTERSECT](#12-combining-results-with-union-except-intersect)
  - [13 Filter in aggregate functions](#13-filter-in-aggregate-functions)
  - [14 Subqueries](#14-subqueries)
    - [Scalar subquery](#scalar-subquery)
    - [IN subquery](#in-subquery)
    - [EXISTS (correlated subquery)](#exists-correlated-subquery)
  - [15 Common table expressions cte](#15-common-table-expressions-cte)
  - [16 Window functions](#16-window-functions)
    - [Ranking functions](#ranking-functions)
    - [Partitioned ranking](#partitioned-ranking)
    - [Windowed aggregates](#windowed-aggregates)
    - [Running totals](#running-totals)
    - [LAG and LEAD](#lag-and-lead)
  - [17 Order of SQL query execution](#17-order-of-sql-query-execution)
  - [18 Creating tables and data types](#18-creating-tables-and-data-types)
  - [19 Type conversion](#19-type-conversion)
  - [20 Views](#20-views)
    - [Materialized views](#materialized-views)
  - [21 Constraints](#21-constraints)
  - [22 Recursion in SQL](#22-recursion-in-sql)
    - [Generating simple sequences](#generating-simple-sequences)
    - [Hierarchical data (org chart)](#hierarchical-data-org-chart)
  - [23 Query optimization](#23-query-optimization)
    - [Basic tools](#basic-tools)
    - [Indexes](#indexes)
  - [24 Normalization star schema snowflake schema](#24-normalization-star-schema-snowflake-schema)
    - [Normal forms](#normal-forms)
    - [Star schema](#star-schema)
    - [Snowflake schema](#snowflake-schema)
  - [25 Professional roadmap](#25-professional-roadmap)

---

## 1 Selecting columns and column aliasing in SQL

```sql
-- Select all columns (not recommended in production)
SELECT * FROM film;

-- Select specific columns
SELECT title, description FROM film;

-- Column aliases
SELECT
    title       AS film_title,
    description AS film_description
FROM film;

-- Table aliases and readable columns
SELECT
    f.title       AS film_title,
    l.name        AS language_name,
    f.language_id AS language_id
FROM film AS f
JOIN language AS l
    ON f.language_id = l.language_id;
```

**Key ideas**

* Use `SELECT *` only for debugging.
* Use short but clear table aliases: `f` for `film`, `a` for `actor`, etc.
* Always alias expressions and aggregates.

---

## 2 Mathematical functions in SQL

```sql
-- Basic arithmetic
SELECT
    5 + 3  AS sum_value,
    10 - 2 AS diff_value,
    6 * 10 AS mult_value,
    15 / 4 AS int_division,        -- integer division in many DBs
    15.0 / 4 AS real_division;     -- numeric division

-- Remainder
SELECT
    payment_id,
    MOD(payment_id, 10) AS mod10
FROM payment;

-- Derived metric: minutes per rental day
SELECT
    title,
    length,
    rental_duration,
    length / rental_duration AS minutes_per_day
FROM film;
```

**Homework theme**

* Build your own derived metrics (margin %, revenue per user, etc.) using arithmetic.

---

## 3 String functions in SQL

```sql
-- Concatenation
SELECT
    CONCAT(first_name, ' ', last_name) AS full_name
FROM actor;

-- Lower / upper casing
SELECT
    LOWER(title) AS title_lower,
    UPPER(title) AS title_upper
FROM film;

-- Substring
SELECT
    SUBSTRING(title, 1, 5) AS title_prefix
FROM film;

-- First word of title
SELECT
    SUBSTRING(title FROM 1 FOR POSITION(' ' IN title) - 1) AS first_word
FROM film
WHERE POSITION(' ' IN title) > 0;

-- Aggregating strings
SELECT
    rating,
    STRING_AGG(title, '; ') AS titles
FROM film
GROUP BY rating;
```

---

## 4 Logical operators and expressions in WHERE

```sql
-- Simple comparison
SELECT *
FROM film
WHERE rental_rate = 4.99;

SELECT *
FROM film
WHERE rental_rate < 2;

-- BETWEEN
SELECT *
FROM rental
WHERE rental_date BETWEEN '2005-05-26' AND '2005-05-29';

-- LIKE and NOT LIKE
SELECT *
FROM film
WHERE LOWER(title) LIKE '%airport%';

SELECT *
FROM film
WHERE LOWER(description) NOT LIKE '%epic%';

-- IN
SELECT *
FROM film
WHERE rating IN ('PG', 'G');

-- Combined AND / OR
SELECT *
FROM film
WHERE
    rental_duration IN (6, 7)
    AND rental_rate > 1
    AND LOWER(title) LIKE 'p%';
```

**Homework theme**

* Write filters with multiple conditions: price ranges, date ranges, category filters.

---

## 5 Null and empty string

```sql
-- Wrong: comparison with NULL
SELECT *
FROM address
WHERE address2 = NULL;   -- always UNKNOWN, returns 0 rows

-- Correct: IS NULL / IS NOT NULL
SELECT *
FROM address
WHERE address2 IS NULL;

SELECT *
FROM address
WHERE address2 IS NOT NULL;

-- Empty string is not NULL
SELECT '' = ''   AS empty_equals_empty;   -- TRUE
SELECT NULL = '' AS null_equals_empty;   -- UNKNOWN

-- NULL in logical expressions
SELECT
    1 = 1                AS cond1,
    NULL = ''            AS cond2,
    (1 = 1) AND (NULL='') AS and_result,
    (1 = 1) OR  (NULL='') AS or_result;

-- IS DISTINCT FROM handles NULL safely
SELECT *
FROM address
WHERE address2 IS DISTINCT FROM 'Moscow';
```

**Core mental model**

* `NULL` = “unknown / not applicable”.
* Any comparison with `NULL` → `UNKNOWN`.
* Use `IS NULL`, `IS NOT NULL`, `IS DISTINCT FROM`.

---

## 6 Sorting rows with ORDER BY

```sql
-- Basic ordering
SELECT *
FROM actor
ORDER BY first_name;

-- Multiple sort keys
SELECT *
FROM actor
ORDER BY first_name, last_name;

-- ASC / DESC
SELECT *
FROM film
ORDER BY rating ASC, length DESC;

-- ORDER BY expression
SELECT
    first_name,
    last_name
FROM actor
ORDER BY first_name || last_name;

-- NULL handling
SELECT *
FROM address
ORDER BY address2 NULLS FIRST;

SELECT *
FROM address
ORDER BY address2 DESC NULLS LAST;
```

**Homework theme**

* Sort by computed columns: margin %, date parts, concatenated names.

---

## 7 Getting unique values with DISTINCT

```sql
-- Unique values in one column
SELECT DISTINCT rating
FROM film
ORDER BY rating;

-- Unique combinations
SELECT DISTINCT last_name, first_name
FROM actor;

-- Distinct substring prefixes
SELECT DISTINCT SUBSTRING(last_name, 1, 3) AS last_prefix
FROM actor;

-- PostgreSQL: DISTINCT ON
SELECT DISTINCT ON (customer_id)
    customer_id,
    payment_date,
    amount
FROM payment
ORDER BY
    customer_id,
    payment_date DESC;
```

**Use cases**

* Deduplicating data.
* “Latest row per customer” using `DISTINCT ON`.

---

## 8 Joining tables inner outer cross joins

```sql
-- Inner join
SELECT
    f.title,
    l.name AS language_name
FROM film AS f
JOIN language AS l
    ON f.language_id = l.language_id;

-- Multiple joins
SELECT
    f.title,
    CONCAT(a.first_name, ' ', a.last_name) AS actor_name
FROM actor AS a
JOIN film_actor AS fa
    ON a.actor_id = fa.actor_id
JOIN film AS f
    ON fa.film_id = f.film_id;

-- Left join: films without inventory records
SELECT
    f.title
FROM film AS f
LEFT JOIN inventory AS i
    USING (film_id)
WHERE
    i.inventory_id IS NULL;

-- Right / full joins (rarely used but good to know)
SELECT
    f.title
FROM inventory AS i
RIGHT JOIN film AS f
    USING (film_id)
WHERE
    i.inventory_id IS NULL;

SELECT
    f.title
FROM inventory AS i
FULL JOIN film AS f
    USING (film_id)
WHERE
    i.inventory_id IS NULL;

-- Cross join: Cartesian product
SELECT
    f.title,
    a.first_name || ' ' || a.last_name AS actor_name
FROM film AS f
CROSS JOIN actor AS a;
```

**Homework theme**

* For a given actor, list all films.
* For each film, list categories.
* List films that have **no** payments (left join + `WHERE payment_id IS NULL`).

---

## 9 Grouping data group-by-and-having

```sql
-- Basic aggregation
SELECT
    rating,
    COUNT(*) AS film_count
FROM film
GROUP BY rating;

-- Aggregation by multiple keys
SELECT
    rating,
    rental_rate,
    COUNT(*) AS film_count
FROM film
GROUP BY rating, rental_rate;

-- Aggregate functions
SELECT
    rating,
    COUNT(*)      AS film_count,
    SUM(length)   AS total_length,
    AVG(length)   AS avg_length,
    MAX(length)   AS max_length,
    MIN(length)   AS min_length
FROM film
GROUP BY rating;

-- HAVING: filter groups
SELECT
    f.title,
    COUNT(*) AS payment_count
FROM film AS f
JOIN inventory USING (film_id)
JOIN rental   USING (inventory_id)
JOIN payment  USING (rental_id)
GROUP BY f.title
HAVING COUNT(*) > 10
ORDER BY payment_count DESC;
```

**Homework theme**

* For each customer, compute number of rentals and total amount.
* For each rating, compute average length only for films longer than 60 minutes.

---

## 10 Conditions in expressions with CASE

```sql
-- Map rental_rate into price bands
SELECT
    title,
    rental_rate,
    CASE
        WHEN rental_rate >= 4 THEN 'High'
        WHEN rental_rate >= 2 THEN 'Medium'
        ELSE 'Low'
    END AS price_band
FROM film;

-- CASE on one column
SELECT
    title,
    rating,
    CASE rating
        WHEN 'G'  THEN 'Family'
        WHEN 'PG' THEN 'Kids'
        ELSE 'Adult'
    END AS rating_group
FROM film;

-- CASE in combination with aggregates
SELECT
    f.title,
    SUM(p.amount) AS total_amount,
    CASE
        WHEN SUM(p.amount) >= 150 THEN 'Top'
        WHEN SUM(p.amount) >= 100 THEN 'Medium'
        ELSE 'Low'
    END AS performance_class
FROM film AS f
JOIN inventory AS i ON f.film_id = i.film_id
JOIN rental   AS r ON i.inventory_id = r.inventory_id
JOIN payment  AS p ON r.rental_id = p.rental_id
GROUP BY f.title;
```

---

## 11 Limiting result set with LIMIT and OFFSET

```sql
-- First page (10 rows)
SELECT *
FROM film
ORDER BY title
LIMIT 10;

-- Second page (rows 11–20)
SELECT *
FROM film
ORDER BY title
OFFSET 10
LIMIT 10;

-- Homework theme: TOP 5 actors by number of films, skip first 5
SELECT
    CONCAT(a.first_name, ' ', a.last_name) AS full_name,
    COUNT(*) AS film_count
FROM actor AS a
JOIN film_actor AS fa USING (actor_id)
GROUP BY full_name, actor_id
ORDER BY film_count DESC, actor_id
OFFSET 5
LIMIT 5;
```

---

## 12 Combining results with UNION EXCEPT INTERSECT

```sql
-- UNION (remove duplicates)
SELECT title FROM film WHERE rating = 'G'
UNION
SELECT title FROM film WHERE rental_rate > 4;

-- UNION ALL (keep duplicates)
SELECT title FROM film WHERE rating = 'G'
UNION ALL
SELECT title FROM film WHERE rental_rate > 4;

-- EXCEPT (A minus B)
SELECT title FROM film WHERE rating = 'G'
EXCEPT
SELECT title FROM film WHERE rental_rate > 4;

-- INTERSECT (common rows)
SELECT title FROM film WHERE rating = 'G'
INTERSECT
SELECT title FROM film WHERE length > 120;
```

**Homework theme**

* Use `UNION` to merge film titles from several conditions.
* Use `EXCEPT` to find “films with payments but not in category X”.

---

## 13 Filter in aggregate functions

PostgreSQL syntax for conditional aggregates:

```sql
SELECT
    COUNT(*) AS total_films,
    COUNT(*) FILTER (WHERE rating = 'G')  AS g_films,
    COUNT(*) FILTER (WHERE rating = 'PG') AS pg_films,
    COUNT(*) FILTER (WHERE rating = 'R')  AS r_films
FROM film;
```

This is cleaner and often faster than `SUM(CASE WHEN ...)`.

---

## 14 Subqueries

### Scalar subquery

```sql
-- Films longer than average
SELECT
    title,
    length
FROM film
WHERE length > (SELECT AVG(length) FROM film);
```

### IN subquery

```sql
-- Films with given actor
SELECT
    title
FROM film
WHERE film_id IN (
    SELECT film_id
    FROM film_actor
    WHERE actor_id = 5
);
```

### EXISTS (correlated subquery)

```sql
-- Films that have at least one payment > 5
SELECT
    f.title
FROM film AS f
WHERE EXISTS (
    SELECT 1
    FROM inventory AS i
    JOIN rental   AS r USING (inventory_id)
    JOIN payment  AS p USING (rental_id)
    WHERE i.film_id = f.film_id
      AND p.amount > 5
);
```

---

## 15 Common table expressions cte

```sql
WITH long_films AS (
    SELECT
        film_id,
        title,
        length
    FROM film
    WHERE length > 120
),
top_long_films AS (
    SELECT
        title,
        length
    FROM long_films
    ORDER BY length DESC
    LIMIT 10
)
SELECT *
FROM top_long_films;
```

**Benefits**

* Break complex logic into readable steps.
* Reuse intermediate results.
* Great for building analytical queries.

---

## 16 Window functions

This is the key topic for professional analytics in SQL.

### Ranking functions

```sql
SELECT
    title,
    rental_rate,
    ROW_NUMBER() OVER (ORDER BY rental_rate DESC) AS row_num,
    RANK()       OVER (ORDER BY rental_rate DESC) AS rank_num,
    DENSE_RANK() OVER (ORDER BY rental_rate DESC) AS dense_rank_num
FROM film;
```

### Partitioned ranking

```sql
SELECT
    rating,
    title,
    rental_rate,
    RANK() OVER (
        PARTITION BY rating
        ORDER BY rental_rate DESC
    ) AS rating_rank
FROM film;
```

### Windowed aggregates

```sql
SELECT
    title,
    rating,
    rental_rate,
    AVG(rental_rate) OVER ()                    AS avg_global_rate,
    AVG(rental_rate) OVER (PARTITION BY rating) AS avg_rate_by_rating
FROM film;
```

### Running totals

```sql
SELECT
    payment_id,
    payment_date,
    amount,
    SUM(amount) OVER (
        ORDER BY payment_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM payment
ORDER BY payment_date;
```

### LAG and LEAD

```sql
SELECT
    payment_id,
    payment_date,
    amount,
    LAG(amount)  OVER (ORDER BY payment_date) AS prev_amount,
    LEAD(amount) OVER (ORDER BY payment_date) AS next_amount
FROM payment
ORDER BY payment_date;
```

**Homework theme**

* For each customer, compute running total of payments.
* For each film, compute difference between its rental_rate and average rental_rate per rating.

---

## 17 Order of SQL query execution

Logical execution order (not text order):

1. `FROM`
2. `JOIN`
3. `WHERE`
4. `GROUP BY`
5. `HAVING`
6. `SELECT`
7. `DISTINCT`
8. `WINDOW` (window functions)
9. `ORDER BY`
10. `LIMIT` / `OFFSET`

**Why it matters**

* You cannot use `SELECT` aliases in `WHERE` (it runs earlier).
* `HAVING` sees aggregated data, `WHERE` does not.
* Window functions work after aggregation but before LIMIT.

---

## 18 Creating tables and data types

```sql
CREATE TABLE users (
    id          SERIAL PRIMARY KEY,
    name        TEXT NOT NULL,
    email       TEXT UNIQUE,
    age         INT CHECK (age >= 0),
    is_active   BOOLEAN DEFAULT TRUE,
    created_at  TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW()
);
```

**Common PostgreSQL data types**

* Integer: `SMALLINT`, `INT`, `BIGINT`
* Numeric: `NUMERIC(p,s)` / `DECIMAL(p,s)`
* Boolean: `BOOLEAN`
* Text: `TEXT`, `VARCHAR(n)`
* Date/time: `DATE`, `TIME`, `TIMESTAMP`
* JSON: `JSON`, `JSONB`
* UUID: `UUID`

---

## 19 Type conversion

```sql
-- CAST function
SELECT CAST('123' AS INT);

-- PostgreSQL shorthand
SELECT '123'::INT;

-- Text to date/time
SELECT '2024-01-01'::DATE;
SELECT '2024-01-01 10:00'::TIMESTAMP;

-- Formatting
SELECT TO_CHAR(NOW(), 'YYYY-MM-DD HH24:MI:SS');
SELECT TO_CHAR(1234.567, 'FM999999.00');
```

---

## 20 Views

```sql
-- Simple view
CREATE VIEW active_customers AS
SELECT
    customer_id,
    first_name,
    last_name
FROM customer
WHERE active = TRUE;

SELECT * FROM active_customers;
```

### Materialized views

```sql
CREATE MATERIALIZED VIEW mv_film_counts AS
SELECT
    rating,
    COUNT(*) AS film_count
FROM film
GROUP BY rating;

REFRESH MATERIALIZED VIEW mv_film_counts;
```

Views are perfect for:

* Hiding complex joins.
* Providing stable interfaces to BI tools.
* Encapsulating business rules in SQL.

---

## 21 Constraints

Main constraint types:

* `PRIMARY KEY`
* `FOREIGN KEY`
* `UNIQUE`
* `CHECK`
* `NOT NULL`
* `DEFAULT`

```sql
CREATE TABLE orders (
    id         SERIAL PRIMARY KEY,
    user_id    INT NOT NULL,
    amount     NUMERIC(10,2) CHECK (amount >= 0),
    status     TEXT CHECK (status IN ('new', 'paid', 'cancelled')),
    created_at TIMESTAMP DEFAULT NOW(),
    CONSTRAINT fk_orders_user
        FOREIGN KEY (user_id) REFERENCES users(id)
);
```

---

## 22 Recursion in SQL

### Generating simple sequences

```sql
WITH RECURSIVE numbers AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1
    FROM numbers
    WHERE n < 10
)
SELECT *
FROM numbers;
```

### Hierarchical data (org chart)

```sql
-- employees(id, manager_id, name)
WITH RECURSIVE org AS (
    SELECT
        id,
        manager_id,
        name,
        1 AS level
    FROM employees
    WHERE manager_id IS NULL

    UNION ALL

    SELECT
        e.id,
        e.manager_id,
        e.name,
        o.level + 1 AS level
    FROM employees AS e
    JOIN org AS o
      ON e.manager_id = o.id
)
SELECT *
FROM org
ORDER BY level, id;
```

---

## 23 Query optimization

### Basic tools

```sql
EXPLAIN ANALYZE
SELECT *
FROM payment
WHERE amount > 5;
```

### Indexes

```sql
CREATE INDEX idx_payment_amount ON payment(amount);
CREATE INDEX idx_film_rating ON film(rating);
CREATE INDEX idx_rental_dates ON rental(rental_date);
```

**Rules of thumb**

* Index frequently used `WHERE` / `JOIN` columns.
* Avoid functions on indexed columns in `WHERE` (e.g. `LOWER(email)`).
* Avoid unnecessary `SELECT *` in big joins.
* Use `LIMIT` for debug queries.
* Regularly `ANALYZE` tables so planner has fresh statistics.

---

## 24 Normalization star schema snowflake schema

### Normal forms

* **1NF** – no repeating groups, atomic values.
* **2NF** – no partial dependence on part of a composite key.
* **3NF** – no transitive dependence (non-key depends only on key).

Normalization reduces:

* Redundant data
* Update anomalies
* Risk of inconsistent data

### Star schema

* Central fact table (transactions, events, measures).
* Several dimension tables (customer, product, date, location).
* Ideal for OLAP / BI reporting.

### Snowflake schema

* Dimensions further normalized.
* More joins, less duplication.
* Often used when dimensions are large or shared.

---

## 25 Professional roadmap

To become a **real SQL professional**, you should be confident in:

* All join types and complex join conditions.
* Aggregations, `GROUP BY`, `HAVING`, `FILTER`.
* Window functions (this is non-negotiable).
* Subqueries (including correlated) and CTEs (including recursive).
* Data modeling: normalization vs star vs snowflake.
* Reading `EXPLAIN ANALYZE` and designing useful indexes.
* Understanding OLTP vs OLAP workloads.
* Using views and materialized views in real systems.

**Practice path**

1. Re-implement all analytics you do in Excel using pure SQL.
2. Rewrite “loop-style” logic into window functions.
3. Take production-like datasets (millions of rows) and experiment with indexes.
4. Design a small data warehouse with fact + dimension tables and query it.

---

*End of file.*
