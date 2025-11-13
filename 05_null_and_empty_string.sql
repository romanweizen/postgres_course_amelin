-- NULL vs empty string
SELECT NULL = 'hello!';  -- UNKNOWN
SELECT ''   = 'hello!';  -- FALSE

-- Concatenation
SELECT NULL || 'hello!' AS concat_null;  -- NULL
SELECT ''   || 'hello!' AS concat_empty;

-- Wrong comparison
SELECT *
FROM address
WHERE address2 = NULL;  -- ALWAYS UNKNOWN, returns nothing

-- Correct checks
SELECT *
FROM address
WHERE address2 IS NULL;

SELECT *
FROM address
WHERE address2 IS NOT NULL;

-- NULL in logical expressions
SELECT 1 = 1 AND NULL = '';  -- UNKNOWN
SELECT 1 = 1 OR  NULL = '';  -- TRUE

-- Handling NULL with IS DISTINCT FROM
SELECT *
FROM address
WHERE address2 IS DISTINCT FROM 'Moscow';

-- IN with NULL
SELECT *
FROM address
WHERE address2 IN ('Moscow', '', NULL);
