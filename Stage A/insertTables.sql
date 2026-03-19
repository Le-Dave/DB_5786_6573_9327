-- ==========================================
-- METHOD 1: MANUAL INSERTS (Example rows)
-- ==========================================

-- 1. MENU_CATEGORY
INSERT INTO MENU_CATEGORY (category_name, description) VALUES 
('Appetizers', 'Small starting dishes'),
('Main Courses', 'Hearty primary meals'),
('Desserts', 'Sweet treats and cakes');

-- 2. INGREDIENT
INSERT INTO INGREDIENT (ingredient_name, unit) VALUES 
('All-purpose Flour', 'kg'),
('Sea Salt', 'g'),
('Whole Milk', 'liters');

-- 3. MENU_ITEM
-- Linked to categories 1, 2 and 3
INSERT INTO MENU_ITEM (item_name, price, description, is_available, added_date, calories, category_id) VALUES 
('Garlic Bread', 8.50, 'Toasted bread with garlic butter', TRUE, '2023-01-15', 350, 1),
('Grilled Salmon', 24.00, 'Fresh Atlantic salmon fillet', TRUE, '2023-05-20', 650, 2),
('Chocolate Lava Cake', 9.99, 'Warm cake with melting center', TRUE, '2024-03-01', 800, 3);

-- 4. RECIPE
-- Linked to menu items 1, 2 and 3 (1:1 relation)
INSERT INTO RECIPE (instructions, menu_item_id) VALUES 
('Slice bread at 2cm, rub with raw garlic, spread butter and toast at 200C.', 1),
('Season salmon with salt and pepper, grill skin-side down for 6 minutes.', 2),
('Whisk cocoa and eggs, bake in ramekins for 12 minutes at 180C.', 3);

-- 5. MENU_CHANGE_LOG
-- Linked to menu items 1, 2 and 3
INSERT INTO MENU_CHANGE_LOG (change_description, change_date, menu_item_id) VALUES 
('Price updated for winter season', TO_TIMESTAMP('01/11/2024 10:00:00', 'DD/MM/YYYY HH24:MI:SS'), 1),
('Description refined for marketing', TO_TIMESTAMP('10/01/2025 14:30:00', 'DD/MM/YYYY HH24:MI:SS'), 2),
(NULL, TO_TIMESTAMP('15/02/2025 08:00:00', 'DD/MM/YYYY HH24:MI:SS'), 3);

-- 6. RECIPE_INGREDIENT
-- Linked to recipes and ingredients
INSERT INTO RECIPE_INGREDIENT (quantity, recipe_id, ingredient_id) VALUES 
(0.250, 1, 1), -- 250g of flour for Garlic Bread
(0.005, 2, 2), -- 5g of salt for Salmon
(0.300, 3, 3); -- 300ml of milk for Cake