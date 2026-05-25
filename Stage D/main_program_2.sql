/* =============================================================================
   MAIN PROGRAM 2
   -----------------------------------------------------------------------------
   Calls ONE procedure + ONE function:
     - PROCEDURE sp_archive_old_prep_logs : archives (deletes) preparation logs
       older than a cutoff date. A safe old cutoff is used here so the demo does
       not destroy current data (it reports how many rows matched).
     - FUNCTION  fn_get_chef_preparations : returns a REF CURSOR of chef #1's
       preparations; the program fetches and prints the first 5 rows.

   Demonstrates calling a procedure and consuming a returned ref cursor.
   ============================================================================= */
DO $$
DECLARE
    v_cursor refcursor;
    rec      RECORD;
    v_count  INTEGER := 0;
BEGIN
    RAISE NOTICE '=== MAIN PROGRAM 2 : archive old logs + chef #1 preparations ===';

    -- 1) call the PROCEDURE (safe old cutoff)
    CALL sp_archive_old_prep_logs(DATE '2024-01-01');

    -- 2) call the FUNCTION returning a ref cursor, then fetch the first 5 rows
    v_cursor := fn_get_chef_preparations(1);
    LOOP
        FETCH v_cursor INTO rec;
        EXIT WHEN NOT FOUND;
        v_count := v_count + 1;
        RAISE NOTICE 'Log %: % | % min | %',
            rec.log_id, rec.item_name, rec.preparation_time, rec.prep_date;
        EXIT WHEN v_count >= 5;
    END LOOP;
    CLOSE v_cursor;

    RAISE NOTICE 'Displayed % preparation(s) for chef #1', v_count;
END;
$$;
