-- 1. Standardizing measurement units
ALTER TABLE INGREDIENT ADD CONSTRAINT check_unit_standard CHECK (unit IN ('kg', 'grams', 'ml', 'liters', 'pieces', 'oz'));

-- 2. Preventing pricing entry errors
ALTER TABLE MENU_ITEM ADD CONSTRAINT check_max_price CHECK (price < 500);

-- 3. Ensuring meaningful item names
ALTER TABLE MENU_ITEM ADD CONSTRAINT check_item_name_length CHECK (LENGTH(item_name) >= 3);

-- 4. Validating log dates
ALTER TABLE MENU_CHANGE_LOG ADD CONSTRAINT check_valid_log_date CHECK (change_date >= '2020-01-01');


/* =============================================================================
   CONSTRAINT VIOLATION SAMPLES FOR STAGE B REPORT
   These queries are designed to intentionally fail in order to prove that
   the database integrity constraints are functioning correctly.
   ============================================================================= */

-- TEST 1: Violating 'check_unit_standard' in INGREDIENT table
-- Purpose: Attempting to insert an ingredient with a non-standard unit ('box').
-- Expected Result: Database error (Check constraint violation).
INSERT INTO INGREDIENT (ingredient_name, unit) 
VALUES ('Test Ingredient', 'box');


-- TEST 2: Violating 'check_max_price' in MENU_ITEM table
-- Purpose: Attempting to set a price ($650) that exceeds the $500 safety cap.
-- Expected Result: Database error (Check constraint violation).
INSERT INTO MENU_ITEM (item_name, price, is_available, added_date, category_id) 
VALUES ('Gold Burger', 650.00, TRUE, CURRENT_DATE, 1);


-- TEST 3: Violating 'check_item_name_length' in MENU_ITEM table
-- Purpose: Attempting to insert a name that is too short (only 1 character).
-- Expected Result: Database error (Check constraint violation).
INSERT INTO MENU_ITEM (item_name, price, is_available, added_date, category_id) 
VALUES ('A', 15.00, TRUE, CURRENT_DATE, 1);


-- TEST 4: Violating 'check_valid_log_date' in MENU_CHANGE_LOG table
-- Purpose: Attempting to insert a log entry with a date (1995) prior to the system's operational start (2020).
-- Expected Result: Database error (Check constraint violation).
INSERT INTO MENU_CHANGE_LOG (change_description, change_date, menu_item_id) 
VALUES ('Legacy change', '1995-01-01', 1);