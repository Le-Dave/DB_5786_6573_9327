/* -----------------------------------------------------------------------------
   Scenario: An administrative error occurs where prices are accidentally 
             increased by $50. We will use ROLLBACK to undo this mistake.
   ----------------------------------------------------------------------------- */

-- Step 1: Baseline check - View the original prices of the first 5 items
SELECT menu_item_id, item_name, price 
FROM MENU_ITEM 
ORDER BY menu_item_id 
LIMIT 5;

-- Step 2: Start the transaction
BEGIN;

-- Step 3: Simulate the error (Unintended price increase)
UPDATE MENU_ITEM 
SET price = price + 50;

-- Step 4: Verification of the "Modified" state
-- The prices are now inflated.
SELECT menu_item_id, item_name, price 
FROM MENU_ITEM 
ORDER BY menu_item_id 
LIMIT 5;

-- Step 5: Cancel the transaction and undo the changes
ROLLBACK;

-- Step 6: Final verification - Check that prices returned to their original values
SELECT menu_item_id, item_name, price 
FROM MENU_ITEM 
ORDER BY menu_item_id 
LIMIT 5;


/* -----------------------------------------------------------------------------
   Scenario: A nutritional re-evaluation was conducted. Management decided to 
             increase the recorded calorie count of all dishes by 100 units. 
             We will COMMIT this change to make it permanent.
   ----------------------------------------------------------------------------- */

-- Step 1: Baseline check - View current calorie counts for the first 5 items
SELECT menu_item_id, item_name, calories 
FROM MENU_ITEM 
WHERE calories IS NOT NULL
ORDER BY menu_item_id 
LIMIT 5;

-- Step 2: Start the transaction
BEGIN;

-- Step 3: Apply the update (Nutritional adjustment)
-- We increase calories by 100 for all items that have a calorie value recorded
UPDATE MENU_ITEM 
SET calories = calories + 100
WHERE calories IS NOT NULL;

-- Step 4: Verification of the "Modified" state within the transaction
-- Calorie counts should now be 100 units higher than in Step 1
SELECT menu_item_id, item_name, calories 
FROM MENU_ITEM 
WHERE calories IS NOT NULL
ORDER BY menu_item_id 
LIMIT 5;

-- Step 5: Save the changes permanently to the database
COMMIT;

-- Step 6: Final verification - Confirm that the +100 calorie adjustment persists
SELECT menu_item_id, item_name, calories 
FROM MENU_ITEM 
WHERE calories IS NOT NULL
ORDER BY menu_item_id 
LIMIT 5;