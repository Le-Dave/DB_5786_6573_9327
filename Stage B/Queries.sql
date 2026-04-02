-- QUERY 1: List all menu items added in 2024 with their category names.
-- Explanation: This query extracts the year from the date and joins two tables to provide context.

-- Version A: Using a JOIN (More efficient as it uses Foreign Key indexes in one pass)
SELECT mi.item_name, mi.price, mc.category_name, EXTRACT(YEAR FROM mi.added_date) AS year_added
FROM MENU_ITEM mi
JOIN MENU_CATEGORY mc ON mi.category_id = mc.category_id
WHERE EXTRACT(YEAR FROM mi.added_date) = 2024;

-- Version B: Using a Correlated Subquery (Less efficient as it executes a lookup for every row)
SELECT item_name, price, 
       (SELECT category_name FROM MENU_CATEGORY mc WHERE mc.category_id = mi.category_id) AS category_name,
       EXTRACT(YEAR FROM added_date) AS year_added
FROM MENU_ITEM mi
WHERE EXTRACT(YEAR FROM added_date) = 2024;


-- QUERY 2: Find ingredients used in more than 20 different recipes.
-- Explanation: Aggregation on an associative table to identify high-usage raw materials.

-- Version A: Using GROUP BY / HAVING (Optimized for large-scale data aggregation)
SELECT i.ingredient_name, i.unit, COUNT(ri.recipe_id) AS total_recipes
FROM INGREDIENT i
JOIN RECIPE_INGREDIENT ri ON i.ingredient_id = ri.ingredient_id
GROUP BY i.ingredient_name, i.unit
HAVING COUNT(ri.recipe_id) > 20;

-- Version B: Using a Subquery in the SELECT and WHERE (Less efficient, redundant calculations)
SELECT i.ingredient_name, i.unit, 
       (SELECT COUNT(*) FROM RECIPE_INGREDIENT ri WHERE ri.ingredient_id = i.ingredient_id) AS total_recipes
FROM INGREDIENT i
WHERE (SELECT COUNT(*) FROM RECIPE_INGREDIENT ri WHERE ri.ingredient_id = i.ingredient_id) > 20;


-- QUERY 3: List items that cost more than the average price of their category.
-- Explanation: Compares individual record values against a group-level aggregate.

-- Version A: Using a Derived Table/JOIN (More efficient, calculates the average only once per category)
SELECT mi.item_name, mi.price, ROUND(sub.avg_cat_price, 2) AS category_average
FROM MENU_ITEM mi
JOIN (SELECT category_id, AVG(price) AS avg_cat_price FROM MENU_ITEM GROUP BY category_id) sub
  ON mi.category_id = sub.category_id
WHERE mi.price > sub.avg_cat_price;

-- Version B: Using a Scalar Subquery (Less efficient, recalculates the average for every item processed)
SELECT mi.item_name, mi.price, 
       (SELECT ROUND(AVG(price), 2) FROM MENU_ITEM mi2 WHERE mi2.category_id = mi.category_id) AS category_average
FROM MENU_ITEM mi
WHERE mi.price > (SELECT AVG(price) FROM MENU_ITEM mi3 WHERE mi3.category_id = mi.category_id);


-- QUERY 4: Identify items that have NOT been modified during the year 2026.
-- Explanation: A negation query using a date filter to find items that remained "static" this year.

-- Version A: Using NOT EXISTS (More efficient)
SELECT mi.item_name, mi.added_date, mi.price
FROM MENU_ITEM mi
WHERE NOT EXISTS (
    SELECT 1 
    FROM MENU_CHANGE_LOG mcl 
    WHERE mcl.menu_item_id = mi.menu_item_id 
    AND EXTRACT(YEAR FROM mcl.change_date) = 2026
);

-- Version B: Using LEFT JOIN / IS NULL (Less efficient)
SELECT mi.item_name, mi.added_date, mi.price
FROM MENU_ITEM mi
LEFT JOIN MENU_CHANGE_LOG mcl ON mi.menu_item_id = mcl.menu_item_id 
    AND EXTRACT(YEAR FROM mcl.change_date) = 2026
WHERE mcl.change_id IS NULL;


-- QUERY 5: Monthly change statistics for the year 2024.
-- Explanation: Groups data by month to analyze system activity over time.
SELECT EXTRACT(MONTH FROM change_date) AS month_num, 
       TO_CHAR(change_date, 'Month') AS month_name, 
       COUNT(*) AS updates_count
FROM MENU_CHANGE_LOG
WHERE EXTRACT(YEAR FROM change_date) = 2024
GROUP BY month_num, month_name
ORDER BY month_num;


-- QUERY 6: Full technical sheets (Item, Instructions, Ingredients, and Quantities).
-- Explanation: Complex 4-table join to provide a complete view for kitchen staff.
SELECT mi.item_name, r.instructions, i.ingredient_name, ri.quantity, i.unit
FROM MENU_ITEM mi
JOIN RECIPE r ON mi.menu_item_id = r.menu_item_id
JOIN RECIPE_INGREDIENT ri ON r.recipe_id = ri.recipe_id
JOIN INGREDIENT i ON ri.ingredient_id = i.ingredient_id
WHERE mi.is_available = TRUE AND mi.price < 30
ORDER BY mi.item_name;


-- QUERY 7: Top 5 categories with the highest average calories.
-- Explanation: Nutritional report identifying the most caloric categories in the menu.
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


-- QUERY 8: Detailed history of changes made during weekends (Friday/Saturday).
-- Explanation: Security audit focused on specific days of the week.
SELECT mi.item_name, mcl.change_description, 
       TO_CHAR(mcl.change_date, 'Day') AS day_name, 
       mcl.change_date
FROM MENU_CHANGE_LOG mcl
JOIN MENU_ITEM mi ON mcl.menu_item_id = mi.menu_item_id
WHERE EXTRACT(DOW FROM mcl.change_date) IN (5, 6) -- 5=Friday, 6=Saturday
ORDER BY mcl.change_date DESC;


-- DELETE 1: Archive/Remove modification logs older than 2 years.
-- Explanation: Maintenance task to prevent the log table from growing excessively.
DELETE FROM MENU_CHANGE_LOG 
WHERE change_date < CURRENT_DATE - INTERVAL '2 years';


-- DELETE 2: Remove empty categories (categories with no associated items).
-- Explanation: Ensures logical menu structure by removing unused groups.
DELETE FROM MENU_CATEGORY
WHERE category_id NOT IN (SELECT DISTINCT category_id FROM MENU_ITEM);


-- DELETE 3: Clean up recipe lines with negligible quantities.
-- Explanation: Simplification of recipe technical sheets for kitchen use.
DELETE FROM RECIPE_INGREDIENT
WHERE quantity < 0.005;


-- UPDATE 1: Apply inflation adjustment (12% increase) to items containing "Beef".
-- Explanation: Updates prices based on recipe composition and ingredient keywords.
UPDATE MENU_ITEM 
SET price = price * 1.12
WHERE menu_item_id IN (
    SELECT r.menu_item_id 
    FROM RECIPE r
    JOIN RECIPE_INGREDIENT ri ON r.recipe_id = ri.recipe_id
    JOIN INGREDIENT i ON ri.ingredient_id = i.ingredient_id
    WHERE i.ingredient_name LIKE '%Beef%'
);


-- UPDATE 2: Mark old "BBQ" items as unavailable.
-- Explanation: Administrative update for seasonal menu cleanup.
UPDATE MENU_ITEM
SET is_available = FALSE
WHERE category_id IN (SELECT category_id FROM MENU_CATEGORY WHERE category_name LIKE '%BBQ%')
AND added_date < CURRENT_DATE - INTERVAL '2 years';


-- UPDATE 3: Populate empty log descriptions for morning system updates.
-- Explanation: Data cleanup for logs created before 10 AM.
UPDATE MENU_CHANGE_LOG
SET change_description = 'Routine morning system check'
WHERE change_description IS NULL 
AND EXTRACT(HOUR FROM change_date) < 10;