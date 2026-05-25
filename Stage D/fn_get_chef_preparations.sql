/* =============================================================================
   FUNCTION 2 : fn_get_chef_preparations(p_chef_id)
   -----------------------------------------------------------------------------
   Purpose : Return a REF CURSOR over all the preparations logged by a given
             chef, enriched with the menu item names (kitchen x menu bridge).
             The caller fetches the rows from the returned cursor.

   Programming elements used:
     - returns a REF CURSOR (b)
     - explicit OPEN ... FOR (cursor)
     - EXCEPTION : raises an error if the chef does not exist (f)
   ============================================================================= */
CREATE OR REPLACE FUNCTION fn_get_chef_preparations(p_chef_id INTEGER)
RETURNS refcursor
LANGUAGE plpgsql
AS $$
DECLARE
    v_exists BOOLEAN;
    v_cursor refcursor := 'chef_prep_cursor';   -- named ref cursor
BEGIN
    -- EXCEPTION : the chef does not exist
    SELECT EXISTS (SELECT 1 FROM chef WHERE chef_id = p_chef_id) INTO v_exists;
    IF NOT v_exists THEN
        RAISE EXCEPTION 'Chef % does not exist', p_chef_id;
    END IF;

    -- open the ref cursor over the chef's preparations
    OPEN v_cursor FOR
        SELECT f.log_id,
               mi.item_name,
               f.preparation_time,
               f.prep_date
        FROM   food_prep_log f
        JOIN   menu_item mi ON mi.menu_item_id = f.menu_item_id
        WHERE  f.chef_id = p_chef_id
        ORDER  BY f.prep_date DESC;

    RETURN v_cursor;
END;
$$;
