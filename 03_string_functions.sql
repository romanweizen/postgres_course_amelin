-- Homework theme: Basic string operations (Homework #1)

-- Concatenation
SELECT
    'title: ' || title ||
    '; description: ' || description AS full_title
FROM
    film;

-- Trim
SELECT
    ltrim(description, 'A') AS trimmed_description
FROM
    film;

-- First word of title
SELECT
    substring(title FROM 1 FOR (POSITION(' ' IN title)) - 1) AS title_first_word
FROM
    film;

-- Example trimming in output formatting
SELECT
    '``' || '||' || ltrim(first_name) || '||' || '``'
FROM
    actor;

SELECT
    '``' || '||' || rtrim(first_name) || '||' || '``'
FROM
    actor;

-- Full name
SELECT
    concat(first_name, ' ', last_name) AS full_name
FROM
    actor;

-- Lowercase + substring
SELECT
    lower(first_name) AS fn_lower,
    substring(last_name, 1, 3) AS last_3
FROM
    actor;

-- string_agg — concatenation with a separator
SELECT
    rating,
    string_agg(title, '; ') AS titles
FROM
    film
GROUP BY
    rating;


-- Homework theme: CASE + strings (actor name shortening)

SELECT
    concat(a.first_name, ' ', a.last_name) AS full_name,
    length(concat(a.first_name, ' ', a.last_name)) AS full_len,
    CASE
        WHEN length(concat(a.first_name, ' ', a.last_name)) > 15
        THEN substring(a.first_name, 1, 7) || ' ' || substring(a.last_name, 1, 7)
        ELSE concat(a.first_name, ' ', a.last_name)
    END AS short_name
FROM
    actor a;
