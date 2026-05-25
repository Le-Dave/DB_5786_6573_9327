/* =============================================================================
   PROCEDURE 2 : sp_archive_old_prep_logs(p_cutoff_date)
   -----------------------------------------------------------------------------
   Purpose : Delete (archive) every food_prep_log row older than a cutoff date,
             iterating with an EXPLICIT cursor and counting the rows removed.
             (Each DELETE fires trg_maintain_times_prepared, which decrements
             menu_item.times_prepared accordingly.)

   Programming elements used:
     - EXPLICIT cursor declared FOR UPDATE (a)
     - LOOP / FETCH (e)
     - DML : DELETE ... WHERE CURRENT OF cursor (c)
     - RECORD variable (g)
     - EXCEPTION block with re-raise (f)
   ============================================================================= */
CREATE OR REPLACE PROCEDURE sp_archive_old_prep_logs(p_cutoff_date DATE)
LANGUAGE plpgsql
AS $$
DECLARE
    -- explicit cursor (FOR UPDATE allows DELETE WHERE CURRENT OF)
    cur_old CURSOR FOR
        SELECT log_id, menu_item_id, prep_date
        FROM   food_prep_log
        WHERE  prep_date < p_cutoff_date
        FOR UPDATE;
    rec       RECORD;
    v_deleted INTEGER := 0;
BEGIN
    -- validation + EXCEPTION
    IF p_cutoff_date > CURRENT_DATE THEN
        RAISE EXCEPTION 'Cutoff date % cannot be in the future', p_cutoff_date;
    END IF;

    OPEN cur_old;
    LOOP
        FETCH cur_old INTO rec;
        EXIT WHEN NOT FOUND;

        DELETE FROM food_prep_log WHERE CURRENT OF cur_old;   -- DML
        v_deleted := v_deleted + 1;
    END LOOP;
    CLOSE cur_old;

    RAISE NOTICE 'Archived (deleted) % preparation log(s) older than %',
                 v_deleted, p_cutoff_date;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error during archive: %', SQLERRM;
        RAISE;   -- propagate the error to the caller
END;
$$;
