/* =============================================================================
   Verify_StageB_merged.sql  --  STAGE C, requirement #7
   Re-run the Stage B queries on the INTEGRATED (12-table) database to prove
   they still work after the fusion.

   - The 8 SELECT queries are run read-only, capped at 5 rows each.
   - The 3 DELETE + 3 UPDATE are run inside a transaction that is ROLLED BACK,
     so they are proven to execute on the merged schema WITHOUT changing data.
   ============================================================================= */
\set ON_ERROR_STOP on

\echo '################ SELECT 1 ################'
SELECT mi.item_name, mi.price, mc.category_name, EXTRACT(YEAR FROM mi.added_date) AS year_added
FROM MENU_ITEM mi
JOIN MENU_CATEGORY mc ON mi.category_id = mc.category_id
WHERE EXTRACT(YEAR FROM mi.added_date) = 2024
LIMIT 5;

\echo '################ SELECT 2 ################'
SELECT i.ingredient_name, i.unit, COUNT(ri.recipe_id) AS total_recipes
FROM INGREDIENT i
JOIN RECIPE_INGREDIENT ri ON i.ingredient_id = ri.ingredient_id
GROUP BY i.ingredient_name, i.unit
HAVING COUNT(ri.recipe_id) > 20
LIMIT 5;

\echo '################ SELECT 3 ################'
SELECT mi.item_name, mi.price, ROUND(sub.avg_cat_price, 2) AS category_average
FROM MENU_ITEM mi
JOIN (SELECT category_id, AVG(price) AS avg_cat_price FROM MENU_ITEM GROUP BY category_id) sub
  ON mi.category_id = sub.category_id
WHERE mi.price > sub.avg_cat_price
LIMIT 5;

\echo '################ SELECT 4 ################'
SELECT mi.item_name, mi.added_date, mi.price
FROM MENU_ITEM mi
WHERE NOT EXISTS (
    SELECT 1 FROM MENU_CHANGE_LOG mcl
    WHERE mcl.menu_item_id = mi.menu_item_id
    AND EXTRACT(YEAR FROM mcl.change_date) = 2026
)
LIMIT 5;

\echo '################ SELECT 5 ################'
SELECT EXTRACT(MONTH FROM change_date) AS month_num,
       TO_CHAR(change_date, 'Month') AS month_name,
       COUNT(*) AS updates_count
FROM MENU_CHANGE_LOG
WHERE EXTRACT(YEAR FROM change_date) = 2024
GROUP BY month_num, month_name
ORDER BY month_num
LIMIT 5;

\echo '################ SELECT 6 ################'
SELECT mi.item_name, r.instructions, i.ingredient_name, ri.quantity, i.unit
FROM MENU_ITEM mi
JOIN RECIPE r ON mi.menu_item_id = r.menu_item_id
JOIN RECIPE_INGREDIENT ri ON r.recipe_id = ri.recipe_id
JOIN INGREDIENT i ON ri.ingredient_id = i.ingredient_id
WHERE mi.is_available = TRUE AND mi.price < 30
ORDER BY mi.item_name
LIMIT 5;

\echo '################ SELECT 7 ################'
SELECT mc.category_name,
       ROUND(AVG(mi.calories), 0) AS avg_calories,
       COUNT(mi.menu_item_id) AS total_items
FROM MENU_CATEGORY mc
JOIN MENU_ITEM mi ON mc.category_id = mi.category_id
WHERE mi.calories IS NOT NULL
GROUP BY mc.category_name
HAVING COUNT(mi.menu_item_id) >= 1
ORDER BY avg_calories DESC
LIMIT 5;

\echo '################ SELECT 8 ################'
SELECT mi.item_name, mcl.change_description,
       TO_CHAR(mcl.change_date, 'Day') AS day_name,
       mcl.change_date
FROM MENU_CHANGE_LOG mcl
JOIN MENU_ITEM mi ON mcl.menu_item_id = mi.menu_item_id
WHERE EXTRACT(DOW FROM mcl.change_date) IN (5, 6)
ORDER BY mcl.change_date DESC
LIMIT 5;

\echo '################ DELETE + UPDATE (inside a rolled-back transaction) ################'
BEGIN;

DELETE FROM MENU_CHANGE_LOG
WHERE change_date < CURRENT_DATE - INTERVAL '2 years';

DELETE FROM MENU_CATEGORY
WHERE category_id NOT IN (SELECT DISTINCT category_id FROM MENU_ITEM);

DELETE FROM RECIPE_INGREDIENT
WHERE quantity < 0.005;

UPDATE MENU_ITEM
SET price = price * 1.12
WHERE menu_item_id IN (
    SELECT r.menu_item_id FROM RECIPE r
    JOIN RECIPE_INGREDIENT ri ON r.recipe_id = ri.recipe_id
    JOIN INGREDIENT i ON ri.ingredient_id = i.ingredient_id
    WHERE i.ingredient_name LIKE '%Beef%'
);

UPDATE MENU_ITEM
SET is_available = FALSE
WHERE category_id IN (SELECT category_id FROM MENU_CATEGORY WHERE category_name LIKE '%BBQ%')
AND added_date < CURRENT_DATE - INTERVAL '2 years';

UPDATE MENU_CHANGE_LOG
SET change_description = 'Routine morning system check'
WHERE change_description IS NULL
AND EXTRACT(HOUR FROM change_date) < 10;

ROLLBACK;

\echo '################ ALL STAGE B QUERIES EXECUTED SUCCESSFULLY ON THE MERGED DB ################'
