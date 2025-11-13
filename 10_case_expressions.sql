-- Translate language names
SELECT
    f.title,
    CASE
        WHEN l.name = 'English'  THEN 'English Language'
        WHEN l.name = 'Italian'  THEN 'Italian Language'
        WHEN l.name = 'Japanese' THEN 'Japanese Language'
        WHEN l.name = 'French'   THEN 'French Language'
        ELSE 'Unknown'
    END AS language_label
FROM film f
JOIN "language" l USING (language_id);

-- CASE inside JOIN condition
SELECT
    f.title,
    f.rating,
    CASE l.name
        WHEN 'English' THEN 'English'
        ELSE 'Other'
    END AS lang_group
FROM film f
JOIN "language" l
    ON CASE WHEN f.rating='G' THEN 2 ELSE f.language_id END = l.language_id;

-- Revenue classification
SELECT
    f.title,
    sum(p.amount) AS total_amount,
    CASE
        WHEN sum(p.amount) >= 150 THEN 'High Revenue'
        WHEN sum(p.amount) >= 100 THEN 'Medium Revenue'
        ELSE 'Low Revenue'
    END AS revenue_class
FROM film f
JOIN inventory i USING (film_id)
JOIN rental r USING (inventory_id)
JOIN payment p USING (rental_id)
GROUP BY f.title;

-- Homework theme: CASE for actor name shortening
SELECT
    CASE
        WHEN length(concat(a.first_name, ' ', a.last_name)) > 15
        THEN substring(a.first_name, 1, 7) || ' ' || substring(a.last_name, 1, 7)
        ELSE concat(a.first_name, ' ', a.last_name)
    END AS short_name
FROM actor a;
