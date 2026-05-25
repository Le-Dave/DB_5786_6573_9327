/* =============================================================================
   FUNCTION 1 : fn_menu_item_kitchen_stats(p_menu_item_id)
   -----------------------------------------------------------------------------
   Purpose : For a given menu item, return a full "fact sheet" combining MENU
             data (name, category, price) with KITCHEN data (how many times it
             was prepared, average preparation time) plus a computed popularity
             label. Demonstrates the menu x kitchen integration (the bridge).

   Programming elements used:
     - RECORD variable (g)
     - implicit cursor via SELECT ... INTO
     - branching IF/ELSIF/ELSE (d)
     - EXCEPTION : raises an error if the menu item does not exist (f)
     - returns a structured row (RETURNS TABLE)
   ============================================================================= */
CREATE OR REPLACE FUNCTION fn_menu_item_kitchen_stats(p_menu_item_id INTEGER)
RETURNS TABLE (
    item_name        VARCHAR,
    category_name    VARCHAR,
    price            NUMERIC,
    times_prepared   INTEGER,
    avg_prep_time    NUMERIC,
    popularity_label TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    rec     RECORD;        -- record variable
    v_label TEXT;
BEGIN
    -- implicit cursor (SELECT INTO) joining menu + kitchen
    SELECT mi.item_name        AS item_name,
           mc.category_name     AS category_name,
           mi.price             AS price,
           mi.times_prepared    AS times_prepared,
           ROUND(AVG(f.preparation_time), 1) AS avg_pt
    INTO rec
    FROM   menu_item mi
    JOIN   menu_category mc ON mi.category_id = mc.category_id
    LEFT JOIN food_prep_log f ON f.menu_item_id = mi.menu_item_id
    WHERE  mi.menu_item_id = p_menu_item_id
    GROUP BY mi.item_name, mc.category_name, mi.price, mi.times_prepared;

    -- EXCEPTION : the menu item does not exist
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Menu item % does not exist', p_menu_item_id;
    END IF;

    -- branching : popularity classification based on the kitchen counter
    IF rec.times_prepared = 0 THEN
        v_label := 'Never prepared';
    ELSIF rec.times_prepared < 100 THEN
        v_label := 'Low';
    ELSIF rec.times_prepared < 200 THEN
        v_label := 'Medium';
    ELSE
        v_label := 'High';
    END IF;

    RETURN QUERY
        SELECT rec.item_name, rec.category_name, rec.price,
               rec.times_prepared, rec.avg_pt, v_label;
END;
$$;
