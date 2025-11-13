# Полное руководство по SQL — от основ до продвинутого уровня

Теория SQL в одном файле: основы, аналитические функции, оптимизация, моделирование данных.

---

## Оглавление

- [Полное руководство по SQL — от основ до продвинутого уровня](#полное-руководство-по-sql--от-основ-до-продвинутого-уровня)
  - [Оглавление](#оглавление)
  - [1 Выбор столбцов и псевдонимы колонок](#1-выбор-столбцов-и-псевдонимы-колонок)
  - [2 Математические функции в SQL](#2-математические-функции-в-sql)
  - [3 Строковые функции в SQL](#3-строковые-функции-в-sql)
  - [4 Логические операторы и выражения в WHERE](#4-логические-операторы-и-выражения-в-where)
  - [5 NULL и пустая строка](#5-null-и-пустая-строка)
  - [6 Сортировка строк с помощью ORDER BY](#6-сортировка-строк-с-помощью-order-by)
  - [7 Уникальные значения с DISTINCT](#7-уникальные-значения-с-distinct)
  - [8 Соединения таблиц inner outer cross join](#8-соединения-таблиц-inner-outer-cross-join)
  - [9 Группировка данных group-by-having](#9-группировка-данных-group-by-having)
  - [10 Условия в выражениях с CASE](#10-условия-в-выражениях-с-case)
  - [11 Ограничение количества строк LIMIT OFFSET](#11-ограничение-количества-строк-limit-offset)
  - [12 Объединение выборок union except intersect](#12-объединение-выборок-union-except-intersect)
  - [13 Фильтр в агрегатных функциях FILTER](#13-фильтр-в-агрегатных-функциях-filter)
  - [14 Подзапросы](#14-подзапросы)
    - [Скаларный подзапрос](#скаларный-подзапрос)
    - [IN](#in)
    - [EXISTS](#exists)
  - [15 Общие табличные выражения CTE](#15-общие-табличные-выражения-cte)
  - [16 Оконные функции](#16-оконные-функции)
    - [Нумерация строк](#нумерация-строк)
    - [PARTITION BY](#partition-by)
    - [Running total](#running-total)
    - [LAG / LEAD](#lag--lead)
  - [17 Порядок выполнения частей SQL-запроса](#17-порядок-выполнения-частей-sql-запроса)
  - [18 Создание таблиц и типы данных](#18-создание-таблиц-и-типы-данных)
  - [19 Преобразование типов данных](#19-преобразование-типов-данных)
  - [20 Представления VIEW и MATERIALIZED VIEW](#20-представления-view-и-materialized-view)
  - [21 Ограничения CONSTRAINTS](#21-ограничения-constraints)
  - [22 Рекурсия в SQL](#22-рекурсия-в-sql)
  - [23 Оптимизация SQL-запросов](#23-оптимизация-sql-запросов)
  - [24 Нормализация и схемы звездой/снежинкой](#24-нормализация-и-схемы-звездойснежинкой)
    - [Нормальные формы](#нормальные-формы)
    - [Звезда (Star Schema)](#звезда-star-schema)
    - [Снежинка (Snowflake)](#снежинка-snowflake)
  - [25 Карьерная дорожная карта SQL-профессионала](#25-карьерная-дорожная-карта-sql-профессионала)

---

## 1 Выбор столбцов и псевдонимы колонок

```sql
SELECT * FROM film;
SELECT title, description FROM film;

SELECT title AS film_title, description AS film_description FROM film;

SELECT f.title AS film_title, l.name AS language_name
FROM film f
JOIN language l ON f.language_id = l.language_id;

````

**Советы**

* `SELECT *` — только для отладки.
* Используй короткие псевдонимы таблиц (`f`, `a`, `p`).
* Всегда давай псевдонимы вычисляемым выражениям.

---

## 2 Математические функции в SQL

```sql
SELECT 5 + 3, 10 - 2, 6 * 10, 15 / 4;
SELECT MOD(payment_id, 10) FROM payment;

SELECT length / rental_duration AS avg_minutes
FROM film;
```

---

## 3 Строковые функции в SQL

```sql
SELECT CONCAT(first_name, ' ', last_name) AS full_name FROM actor;
SELECT LOWER(title), UPPER(description) FROM film;
SELECT SUBSTRING(title, 1, 5) FROM film;

SELECT STRING_AGG(title, ', ')
FROM film
GROUP BY rating;
```

---

## 4 Логические операторы и выражения в WHERE

```sql
SELECT * FROM film WHERE rental_rate > 2;
SELECT * FROM film WHERE title LIKE '%air%';
SELECT * FROM film WHERE rating IN ('PG','G');
SELECT * FROM film WHERE rental_rate > 2 AND length < 120;
```

---

## 5 NULL и пустая строка

```sql
SELECT * FROM address WHERE address2 IS NULL;
SELECT * FROM address WHERE address2 IS DISTINCT FROM 'Москва';

SELECT NULL = NULL; -- UNKNOWN
SELECT '' = '';     -- TRUE

SELECT 1 = 1 AND NULL = ''; -- UNKNOWN
```

---

## 6 Сортировка строк с помощью ORDER BY

```sql
SELECT * FROM actor ORDER BY first_name, last_name;
SELECT * FROM film ORDER BY rating DESC, length ASC;
SELECT * FROM address ORDER BY address2 NULLS LAST;
```

---

## 7 Уникальные значения с DISTINCT

```sql
SELECT DISTINCT rating FROM film;
SELECT DISTINCT first_name, last_name FROM actor;

SELECT DISTINCT ON (customer_id)
       customer_id, payment_date
FROM payment
ORDER BY customer_id, payment_date DESC;
```

---

## 8 Соединения таблиц inner outer cross join

```sql
SELECT f.title, l.name
FROM film f JOIN language l ON f.language_id = l.language_id;

SELECT f.title
FROM film f
LEFT JOIN inventory i USING(film_id)
WHERE i.inventory_id IS NULL;

SELECT f.title, a.first_name
FROM film f CROSS JOIN actor a;
```

---

## 9 Группировка данных group-by-having

```sql
SELECT rating, COUNT(*) FROM film GROUP BY rating;

SELECT f.title, COUNT(*)
FROM film f
JOIN inventory USING(film_id)
JOIN rental USING(inventory_id)
JOIN payment USING(rental_id)
GROUP BY f.title
HAVING COUNT(*) > 10;
```

---

## 10 Условия в выражениях с CASE

```sql
SELECT title,
       CASE
         WHEN rental_rate >= 4 THEN 'Высокая'
         WHEN rental_rate >= 2 THEN 'Средняя'
         ELSE 'Низкая'
       END AS price_band
FROM film;
```

---

## 11 Ограничение количества строк LIMIT OFFSET

```sql
SELECT * FROM film ORDER BY title LIMIT 10;

SELECT * FROM film ORDER BY title OFFSET 10 LIMIT 10;
```

---

## 12 Объединение выборок union except intersect

```sql
SELECT title FROM film WHERE rating='G'
UNION
SELECT title FROM film WHERE rental_rate > 4;

SELECT title FROM film WHERE rating='G'
EXCEPT
SELECT title FROM film WHERE length < 100;

SELECT title FROM film WHERE rating='G'
INTERSECT
SELECT title FROM film WHERE rental_rate > 3;
```

---

## 13 Фильтр в агрегатных функциях FILTER

```sql
SELECT
    COUNT(*) AS total,
    COUNT(*) FILTER (WHERE rating='PG') AS pg_count,
    COUNT(*) FILTER (WHERE rating='G') AS g_count
FROM film;
```

---

## 14 Подзапросы

### Скаларный подзапрос

```sql
SELECT title
FROM film
WHERE length > (SELECT AVG(length) FROM film);
```

### IN

```sql
SELECT title
FROM film
WHERE film_id IN (
    SELECT film_id FROM film_actor WHERE actor_id = 5
);
```

### EXISTS

```sql
SELECT title
FROM film f
WHERE EXISTS (
    SELECT 1
    FROM inventory i
    WHERE i.film_id = f.film_id
);
```

---

## 15 Общие табличные выражения CTE

```sql
WITH long_films AS (
    SELECT film_id, title, length
    FROM film
    WHERE length > 120
)
SELECT * FROM long_films;
```

---

## 16 Оконные функции

### Нумерация строк

```sql
SELECT title,
       rental_rate,
       ROW_NUMBER() OVER (ORDER BY rental_rate DESC) AS rn,
       RANK() OVER (ORDER BY rental_rate DESC) AS rnk
FROM film;
```

### PARTITION BY

```sql
SELECT rating, title, rental_rate,
       RANK() OVER (PARTITION BY rating ORDER BY rental_rate DESC)
FROM film;
```

### Running total

```sql
SELECT payment_id, amount,
       SUM(amount) OVER (
           ORDER BY payment_id
           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) AS running_total
FROM payment;
```

### LAG / LEAD

```sql
SELECT payment_id, amount,
       LAG(amount) OVER (ORDER BY payment_id) AS prev_amount,
       LEAD(amount) OVER (ORDER BY payment_id) AS next_amount
FROM payment;
```

---

## 17 Порядок выполнения частей SQL-запроса

1. FROM
2. JOIN
3. WHERE
4. GROUP BY
5. HAVING
6. SELECT
7. DISTINCT
8. WINDOW
9. ORDER BY
10. LIMIT / OFFSET

---

## 18 Создание таблиц и типы данных

```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    age INT CHECK (age >= 0),
    email TEXT UNIQUE,
    created_at TIMESTAMP DEFAULT NOW()
);
```

Основные типы PostgreSQL:

* INT / BIGINT
* NUMERIC
* BOOLEAN
* TEXT / VARCHAR
* DATE / TIMESTAMP
* JSON / JSONB
* UUID

---

## 19 Преобразование типов данных

```sql
SELECT '123'::INT;
SELECT CAST('2024-01-01' AS DATE);
SELECT TO_CHAR(NOW(), 'YYYY-MM-DD HH24:MI:SS');
```

---

## 20 Представления VIEW и MATERIALIZED VIEW

```sql
CREATE VIEW active_customers AS
SELECT customer_id, first_name
FROM customer
WHERE active = TRUE;
```

```sql
CREATE MATERIALIZED VIEW mv_film_stats AS
SELECT rating, COUNT(*) FROM film GROUP BY rating;

REFRESH MATERIALIZED VIEW mv_film_stats;
```

---

## 21 Ограничения CONSTRAINTS

Типы:

* PRIMARY KEY
* FOREIGN KEY
* UNIQUE
* CHECK
* NOT NULL
* DEFAULT

```sql
ALTER TABLE users
ADD CONSTRAINT email_unique UNIQUE(email);
```

---

## 22 Рекурсия в SQL

```sql
WITH RECURSIVE nums AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1
    FROM nums
    WHERE n < 10
)
SELECT * FROM nums;
```

---

## 23 Оптимизация SQL-запросов

```sql
EXPLAIN ANALYZE
SELECT * FROM payment WHERE amount > 5;
```

Индексы:

```sql
CREATE INDEX idx_payment_amount ON payment(amount);
CREATE INDEX idx_film_rating ON film(rating);
```

Правила:

* Индексируй часто используемые столбцы в WHERE и JOIN.
* Не используй функции поверх индексных колонок (`LOWER(email)`).
* Избегай `SELECT *` в тяжёлых запросах.
* Статистика таблиц должна быть актуальна (`ANALYZE`).

---

## 24 Нормализация и схемы звездой/снежинкой

### Нормальные формы

* **1NF** — атомарность
* **2NF** — нет частичных зависимостей
* **3NF** — нет транзитивных зависимостей

### Звезда (Star Schema)

* Факт таблица
* Измерения (customer, product, date, store)

### Снежинка (Snowflake)

* Измерения дополнительно нормализованы
* Больше JOIN-ов, меньше дублирования

---

## 25 Карьерная дорожная карта SQL-профессионала

Для реального профессионализма нужно уметь:

* Писать сложные JOIN-ы
* Работать с агрегатами и оконными функциями
* Читать и оптимизировать `EXPLAIN ANALYZE`
* Проектировать индексы
* Проектировать модели данных (OLTP и OLAP)
* Работать со звёздной и снежинчатой схемой
* Писать сложные аналитические запросы без лишних подзапросов

Практические советы:

* Перепиши свои Excel-аналитики в SQL.
* Построй мини-DWH (звезда).
* Попробуй разные индексы и сравни планы выполнения.
* Освой оконные функции на 100%.

---

*Конец файла.*

```

---

Если нужно:

✅ версия **английский + русский вместе**,  
✅ версия с **задачами** по каждой теме,  
✅ разбивка на **отдельные модули**,

— скажи, сделаю.
```
