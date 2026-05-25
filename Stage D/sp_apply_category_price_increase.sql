/* =============================================================================
   PROCEDURE 1 : sp_apply_category_price_increase(p_category_id, p_percent)
   -----------------------------------------------------------------------------
   Purpose : Apply a percentage price increase to every menu item of a given
             category. Validates the input and reports how many rows changed.
             (Each price UPDATE also fires trg_log_price_change, which records
             the change in menu_change_log automatically.)

   Programming elements used:
     - DML : UPDATE on menu_item (c)
     - branching IF / validation (d)
     - EXCEPTION : invalid percent or unknown category (f)
     - GET DIAGNOSTICS (row count) + RAISE NOTICE (proof of execution)
   ============================================================================= */
CREATE OR REPLACE PROCEDURE sp_apply_category_price_increase(
    p_category_id INTEGER,
    p_percent     NUMERIC
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_cat_name VARCHAR;
    v_count    INTEGER;
BEGIN
    -- validation + EXCEPTION
    IF p_percent <= 0 OR p_percent > 100 THEN
        RAISE EXCEPTION 'Invalid percent %, must be between 0 and 100', p_percent;
    END IF;

    SELECT category_name INTO v_cat_name
    FROM   menu_category
    WHERE  category_id = p_category_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Category % does not exist', p_category_id;
    END IF;

    -- DML : update the prices
    UPDATE menu_item
    SET    price = ROUND(price * (1 + p_percent / 100.0), 2)
    WHERE  category_id = p_category_id;

    GET DIAGNOSTICS v_count = ROW_COUNT;

    RAISE NOTICE 'Applied % percent increase to % item(s) in category "%"',
                 p_percent, v_count, v_cat_name;
END;
$$;
