-- Version A : JOIN (Plus efficace car utilise les index de FK)
SELECT mi.item_name, mi.price, mc.category_name, EXTRACT(YEAR FROM mi.added_date) AS year_added
FROM MENU_ITEM mi
JOIN MENU_CATEGORY mc ON mi.category_id = mc.category_id
WHERE EXTRACT(YEAR FROM mi.added_date) = 2024;

-- Version B : Sous-requête corrélée (Moins efficace, exécute une recherche par ligne)
SELECT item_name, price, 
       (SELECT category_name FROM MENU_CATEGORY mc WHERE mc.category_id = mi.category_id) AS category_name,
       EXTRACT(YEAR FROM added_date) AS year_added
FROM MENU_ITEM mi
WHERE EXTRACT(YEAR FROM added_date) = 2024;

-- Version A : GROUP BY / HAVING (Optimisé pour les agrégations massives)
SELECT i.ingredient_name, i.unit, COUNT(ri.recipe_id) AS total_recipes
FROM INGREDIENT i
JOIN RECIPE_INGREDIENT ri ON i.ingredient_id = ri.ingredient_id
GROUP BY i.ingredient_name, i.unit
HAVING COUNT(ri.recipe_id) > 20;

-- Version B : IN avec sous-requête (Moins performant sur 20 000 lignes)
SELECT i.ingredient_name, i.unit, 
       (SELECT COUNT(*) FROM RECIPE_INGREDIENT ri WHERE ri.ingredient_id = i.ingredient_id) AS total_recipes
FROM INGREDIENT i
WHERE (SELECT COUNT(*) FROM RECIPE_INGREDIENT ri WHERE ri.ingredient_id = i.ingredient_id) > 20;

-- Version A : Derived Table (Jointure sur table calculée - Très efficace)
SELECT mi.item_name, mi.price, ROUND(sub.avg_cat_price, 2) AS category_average
FROM MENU_ITEM mi
JOIN (SELECT category_id, AVG(price) AS avg_cat_price FROM MENU_ITEM GROUP BY category_id) sub
  ON mi.category_id = sub.category_id
WHERE mi.price > sub.avg_cat_price;

-- Version B : Sous-requête dans le WHERE (Lourd, recalculé pour chaque plat)
SELECT mi.item_name, mi.price, 
       (SELECT ROUND(AVG(price), 2) FROM MENU_ITEM mi2 WHERE mi2.category_id = mi.category_id) AS category_average
FROM MENU_ITEM mi
WHERE mi.price > (SELECT AVG(price) FROM MENU_ITEM mi3 WHERE mi3.category_id = mi.category_id);

-- Version A : NOT EXISTS (Plus rapide dans Postgres pour la négation)
SELECT item_name, added_date, is_available
FROM MENU_ITEM mi
WHERE NOT EXISTS (SELECT 1 FROM MENU_CHANGE_LOG mcl WHERE mcl.menu_item_id = mi.menu_item_id);

-- Version B : LEFT JOIN / IS NULL (Standard mais parfois plus lent)
SELECT mi.item_name, mi.added_date, mi.is_available
FROM MENU_ITEM mi
LEFT JOIN MENU_CHANGE_LOG mcl ON mi.menu_item_id = mcl.menu_item_id
WHERE mcl.change_id IS NULL;

SELECT EXTRACT(MONTH FROM change_date) as month_num, 
       TO_CHAR(change_date, 'Month') as month_name, 
       COUNT(*) as updates_count
FROM MENU_CHANGE_LOG
WHERE EXTRACT(YEAR FROM change_date) = 2024
GROUP BY month_num, month_name
ORDER BY month_num;

SELECT mi.item_name, r.instructions, i.ingredient_name, ri.quantity, i.unit
FROM MENU_ITEM mi
JOIN RECIPE r ON mi.menu_item_id = r.menu_item_id
JOIN RECIPE_INGREDIENT ri ON r.recipe_id = ri.recipe_id
JOIN INGREDIENT i ON ri.ingredient_id = i.ingredient_id
WHERE mi.is_available = TRUE AND mi.price < 30
ORDER BY mi.item_name;

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

SELECT mi.item_name, mcl.change_description, 
       TO_CHAR(mcl.change_date, 'Day') as day_name, 
       mcl.change_date
FROM MENU_CHANGE_LOG mcl
JOIN MENU_ITEM mi ON mcl.menu_item_id = mi.menu_item_id
WHERE EXTRACT(DOW FROM mcl.change_date) IN (5, 6) -- 5=Friday, 6=Saturday
ORDER BY mcl.change_date DESC;

UPDATE MENU_ITEM 
SET price = price * 1.12
WHERE menu_item_id IN (
    SELECT r.menu_item_id 
    FROM RECIPE r
    JOIN RECIPE_INGREDIENT ri ON r.recipe_id = ri.recipe_id
    JOIN INGREDIENT i ON ri.ingredient_id = i.ingredient_id
    WHERE i.ingredient_name LIKE '%Beef%'
);

UPDATE MENU_ITEM
SET is_available = FALSE
WHERE category_id IN (SELECT category_id FROM MENU_CATEGORY WHERE category_name LIKE '%Seafood%')
AND added_date < CURRENT_DATE - INTERVAL '2 years';

UPDATE MENU_CHANGE_LOG
SET change_description = 'Routine morning system check'
WHERE change_description IS NULL 
AND EXTRACT(HOUR FROM change_date) < 10;

DELETE FROM MENU_CHANGE_LOG 
WHERE change_date < CURRENT_DATE - INTERVAL '3 years';

DELETE FROM MENU_CATEGORY
WHERE category_id NOT IN (SELECT DISTINCT category_id FROM MENU_ITEM);

DELETE FROM RECIPE_INGREDIENT
WHERE quantity < 0.001;