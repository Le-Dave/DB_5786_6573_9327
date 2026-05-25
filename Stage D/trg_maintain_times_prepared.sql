/* =============================================================================
   TRIGGER 2 : trg_maintain_times_prepared  (AFTER INSERT OR DELETE on food_prep_log)
   -----------------------------------------------------------------------------
   Purpose : Keep menu_item.times_prepared (added in AlterTable.sql) in sync with
             the kitchen log. On a new preparation -> +1 ; on a deleted/archived
             log -> -1. Demonstrates a trigger that maintains a denormalized
             counter across the integration bridge.

   Programming elements used:
     - trigger on INSERT and DELETE
     - branching on TG_OP (d)
     - DML : UPDATE menu_item (c)
     - NEW / OLD row references
   ============================================================================= */
CREATE OR REPLACE FUNCTION trg_fn_maintain_times_prepared()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE menu_item
        SET    times_prepared = times_prepared + 1
        WHERE  menu_item_id = NEW.menu_item_id;
        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        UPDATE menu_item
        SET    times_prepared = times_prepared - 1
        WHERE  menu_item_id = OLD.menu_item_id;
        RETURN OLD;
    END IF;

    RETURN NULL;
END;
$$;

DROP TRIGGER IF EXISTS trg_maintain_times_prepared ON food_prep_log;

CREATE TRIGGER trg_maintain_times_prepared
AFTER INSERT OR DELETE ON food_prep_log
FOR EACH ROW
EXECUTE FUNCTION trg_fn_maintain_times_prepared();
