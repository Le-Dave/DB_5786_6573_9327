/* =============================================================================
   TRIGGER 1 : trg_log_price_change   (AFTER UPDATE on menu_item)
   -----------------------------------------------------------------------------
   Purpose : Whenever a menu item's price is updated, automatically record the
             change in menu_change_log (old price -> new price). This is the
             mandatory UPDATE trigger.

   Programming elements used:
     - trigger on UPDATE
     - branching (only logs when the price actually changed)
     - DML : INSERT into menu_change_log (c)
     - OLD / NEW row references
   ============================================================================= */
CREATE OR REPLACE FUNCTION trg_fn_log_price_change()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    -- only act when the price really changed
    IF NEW.price IS DISTINCT FROM OLD.price THEN
        INSERT INTO menu_change_log (change_description, change_date, menu_item_id)
        VALUES (
            format('Price changed from %s to %s', OLD.price, NEW.price),
            CURRENT_TIMESTAMP,
            NEW.menu_item_id
        );
    END IF;
    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_log_price_change ON menu_item;

CREATE TRIGGER trg_log_price_change
AFTER UPDATE ON menu_item
FOR EACH ROW
EXECUTE FUNCTION trg_fn_log_price_change();
