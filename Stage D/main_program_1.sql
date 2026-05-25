/* =============================================================================
   MAIN PROGRAM 1
   -----------------------------------------------------------------------------
   Calls ONE procedure + ONE function:
     - PROCEDURE sp_apply_category_price_increase : raises the prices of the
       category that item #1 belongs to (+10%).
     - FUNCTION  fn_menu_item_kitchen_stats : prints the updated fact sheet of
       item #1 (new price, kitchen stats, popularity).

   Run it and read the NOTICE output to see both the procedure and the function
   in action. (The price UPDATE inside the procedure also triggers the automatic
   logging in menu_change_log via trg_log_price_change.)
   ============================================================================= */
DO $$
DECLARE
    v_item_id INTEGER := 1;
    v_cat_id  INTEGER;
    rec       RECORD;
BEGIN
    SELECT category_id INTO v_cat_id FROM menu_item WHERE menu_item_id = v_item_id;

    RAISE NOTICE '=== MAIN PROGRAM 1 : item % (category %) ===', v_item_id, v_cat_id;

    -- 1) call the PROCEDURE
    CALL sp_apply_category_price_increase(v_cat_id, 10);

    -- 2) call the FUNCTION and print its row(s)
    FOR rec IN SELECT * FROM fn_menu_item_kitchen_stats(v_item_id) LOOP
        RAISE NOTICE 'Item: % | Category: % | Price: % | Prepared % time(s) | Avg time: % | Popularity: %',
            rec.item_name, rec.category_name, rec.price,
            rec.times_prepared, rec.avg_prep_time, rec.popularity_label;
    END LOOP;
END;
$$;
