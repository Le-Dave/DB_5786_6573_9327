/* =============================================================================
   AlterTable.sql  --  STAGE D : schema change needed by the programs
   -----------------------------------------------------------------------------
   We add a denormalized counter `times_prepared` on menu_item.
   It is kept in sync automatically by the trigger trg_maintain_times_prepared
   (fired on INSERT/DELETE of food_prep_log). It lets functions/reports read the
   preparation count of a dish in O(1) instead of aggregating 20k+ log rows.
   ============================================================================= */

-- 1. Add the counter column (default 0 so existing rows are valid)
ALTER TABLE menu_item
    ADD COLUMN IF NOT EXISTS times_prepared INTEGER NOT NULL DEFAULT 0;

-- 2. Back-fill the counter from the existing food_prep_log data
UPDATE menu_item mi
SET times_prepared = COALESCE((
    SELECT COUNT(*)
    FROM   food_prep_log f
    WHERE  f.menu_item_id = mi.menu_item_id
), 0);

-- 3. Safety constraint: the counter can never be negative
ALTER TABLE menu_item
    ADD CONSTRAINT chk_times_prepared_non_negative CHECK (times_prepared >= 0);
