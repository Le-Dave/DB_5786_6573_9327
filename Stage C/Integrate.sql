/* =============================================================================
   Integrate.sql  --  STAGE C : Database Integration (method A - Fusion)
   Project : Restaurant Management System
   Modules : MENU MANAGEMENT (ours)  x  KITCHEN OPERATIONS (received backup)

   PRE-CONDITION
   -------------
   The received backup (6 kitchen tables + their data) has already been
   RESTORED INTO the existing menu database, which already holds the 6 menu
   tables (menu_category, ingredient, menu_item, recipe, menu_change_log,
   recipe_ingredient).

   After the restore, the unified database physically contains the 12 tables
   side by side, but the two worlds are NOT yet logically connected.

   This script performs the actual INTEGRATION using ALTER commands only.
   No existing table is dropped or recreated (per stage requirement).
   ============================================================================= */


/* -----------------------------------------------------------------------------
   STEP 1 - Data reconciliation check (documented design decision)
   -----------------------------------------------------------------------------
   In the received module, food_prep_log.menu_item_id was a FREE integer
   (no foreign key) pointing at a dish that did not exist in their schema.

   Verified ranges:
     - menu_item (ours)            : menu_item_id in [1 .. 500]
     - food_prep_log.menu_item_id  : values in [1 .. 100]  (20017 rows)

   => Every referenced menu_item_id already exists in our menu_item table,
      so NO remapping / deletion is required before adding the foreign key.

   Verification query (must return 0):
----------------------------------------------------------------------------- */
SELECT COUNT(*) AS orphan_menu_item_refs
FROM   food_prep_log f
WHERE  NOT EXISTS (SELECT 1
                   FROM   menu_item m
                   WHERE  m.menu_item_id = f.menu_item_id);


/* -----------------------------------------------------------------------------
   STEP 2 - THE BRIDGE  (core of the integration)
   -----------------------------------------------------------------------------
   Turn food_prep_log.menu_item_id into a REAL foreign key that references our
   menu_item table. This is the single semantic link that fuses the two
   modules: "menu design (what dishes exist)" <-> "kitchen execution (dishes
   actually prepared)".

   ON DELETE CASCADE is chosen to stay consistent with our existing log table
   (menu_change_log -> menu_item also uses CASCADE): when a dish is removed
   from the menu, its related kitchen preparation records are removed too.
----------------------------------------------------------------------------- */
ALTER TABLE food_prep_log
    ADD CONSTRAINT fk_food_prep_log_menu_item
    FOREIGN KEY (menu_item_id)
    REFERENCES menu_item (menu_item_id)
    ON DELETE CASCADE;


/* -----------------------------------------------------------------------------
   STEP 3 - Keep the bridge column mandatory
   -----------------------------------------------------------------------------
   menu_item_id is already NOT NULL in the received schema; we re-assert it
   explicitly so the integrated model guarantees every prep log refers to a
   real menu item.
----------------------------------------------------------------------------- */
ALTER TABLE food_prep_log
    ALTER COLUMN menu_item_id SET NOT NULL;


/* -----------------------------------------------------------------------------
   STEP 4 - Performance: index the new foreign-key column
   -----------------------------------------------------------------------------
   The bridge column will be used to JOIN kitchen activity with menu data
   (see Views.sql). Index it to speed up those joins and the FK checks.
----------------------------------------------------------------------------- */
CREATE INDEX IF NOT EXISTS idx_food_prep_log_menu_item
    ON food_prep_log (menu_item_id);


/* -----------------------------------------------------------------------------
   STEP 5 - Post-integration verification
   -----------------------------------------------------------------------------
   Confirm the 12 tables coexist and the bridge is in place.
----------------------------------------------------------------------------- */
-- List all base tables of the unified database (expected: 12)
SELECT table_name
FROM   information_schema.tables
WHERE  table_schema = 'public' AND table_type = 'BASE TABLE'
ORDER  BY table_name;

-- Confirm the new foreign key exists
SELECT conname AS constraint_name
FROM   pg_constraint
WHERE  conname = 'fk_food_prep_log_menu_item';
