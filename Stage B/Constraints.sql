-- 1. Standardizing measurement units
ALTER TABLE INGREDIENT ADD CONSTRAINT check_unit_standard CHECK (unit IN ('kg', 'grams', 'ml', 'liters', 'pieces', 'oz'));

-- 2. Preventing pricing entry errors
ALTER TABLE MENU_ITEM ADD CONSTRAINT check_max_price CHECK (price < 500);

-- 3. Ensuring meaningful item names
ALTER TABLE MENU_ITEM ADD CONSTRAINT check_item_name_length CHECK (LENGTH(item_name) >= 3);

-- 4. Validating log dates
ALTER TABLE MENU_CHANGE_LOG ADD CONSTRAINT check_valid_log_date CHECK (change_date >= '2020-01-01');