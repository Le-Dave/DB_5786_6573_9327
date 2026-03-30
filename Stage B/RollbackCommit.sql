/* -----------------------------------------------------------------------------
   Scenario: An administrative error occurs where prices are accidentally 
             increased by $50. We will use ROLLBACK to undo this mistake.
   ----------------------------------------------------------------------------- */

-- Step 1: Baseline check - View the original prices of the first 5 items
SELECT menu_item_id, item_name, price 
FROM menu_item 
ORDER BY menu_item_id 
LIMIT 5;

-- Step 2: Start the transaction
BEGIN;

-- Step 3: Simulate the error (Unintended price increase)
UPDATE menu_item 
SET price = price + 50;

-- Step 4: Verification of the "Modified" state
-- The prices are now inflated.
SELECT menu_item_id, item_name, price 
FROM menu_item 
ORDER BY menu_item_id 
LIMIT 5;

-- Step 5: Cancel the transaction and undo the changes
ROLLBACK;

-- Step 6: Final verification - Check that prices returned to their original values
SELECT menu_item_id, item_name, price 
FROM menu_item 
ORDER BY menu_item_id 
LIMIT 5;


/* -----------------------------------------------------------------------------
   Scenario: Management decides to temporarily set all items to "Unavailable" 
             for a system maintenance window. We will COMMIT this change.
   ----------------------------------------------------------------------------- */

-- Step 1: Baseline check - View current availability status
SELECT menu_item_id, item_name, is_available 
FROM menu_item 
ORDER BY menu_item_id 
LIMIT 5;

-- Step 2: Start the transaction
BEGIN;

-- Step 3: Apply the update (Confirming maintenance mode)
UPDATE menu_item 
SET is_available = FALSE;

-- Step 4: Verification of the "Modified" state
-- Items are now correctly marked as unavailable.
SELECT menu_item_id, item_name, is_available 
FROM menu_item 
ORDER BY menu_item_id 
LIMIT 5;

-- Step 5: Save the changes permanently to the database
COMMIT;

-- Step 6: Final verification - Confirm that changes persist after the transaction
SELECT menu_item_id, item_name, is_available 
FROM menu_item 
ORDER BY menu_item_id 
LIMIT 5;