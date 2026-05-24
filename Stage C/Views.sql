/* =============================================================================
   Views.sql  --  STAGE C : Views on the integrated database
   Project : Restaurant Management System  (Menu x Kitchen)

   Two views, one per original module:
     - VIEW 1 : from the MENU-management point of view  (our module)
     - VIEW 2 : from the KITCHEN-operations point of view (received module)
   Both views combine 3 tables. VIEW 1 uses the integration bridge
   (food_prep_log.menu_item_id -> menu_item).
   ============================================================================= */


/* =============================================================================
   VIEW 1 (MENU perspective) : v_menu_kitchen_activity
   -----------------------------------------------------------------------------
   For every menu item, show how the kitchen actually uses it: how many times
   it was prepared, the average preparation time and the last preparation date,
   together with its category and price.
   LEFT JOIN on food_prep_log so dishes never prepared still appear (with 0).
   Tables combined: menu_item + menu_category + food_prep_log (bridge).
   ============================================================================= */
CREATE OR REPLACE VIEW v_menu_kitchen_activity AS
SELECT
    mi.menu_item_id,
    mi.item_name,
    mc.category_name,
    mi.price,
    mi.is_available,
    COUNT(fpl.log_id)                    AS times_prepared,
    ROUND(AVG(fpl.preparation_time), 1)  AS avg_prep_time,
    MAX(fpl.prep_date)                   AS last_prepared
FROM menu_item mi
JOIN menu_category mc       ON mi.category_id = mc.category_id
LEFT JOIN food_prep_log fpl ON fpl.menu_item_id = mi.menu_item_id
GROUP BY mi.menu_item_id, mi.item_name, mc.category_name, mi.price, mi.is_available;


-- Report sample: SELECT * (up to 10 rows)
SELECT * FROM v_menu_kitchen_activity LIMIT 10;

-- VIEW 1 - Query 1 : the 10 most-prepared dishes (kitchen demand per menu item)
SELECT item_name, category_name, times_prepared, avg_prep_time
FROM v_menu_kitchen_activity
ORDER BY times_prepared DESC
LIMIT 10;

-- VIEW 1 - Query 2 : available dishes that the kitchen NEVER prepared
--                    (candidates to remove / promote on the menu)
SELECT item_name, category_name, price
FROM v_menu_kitchen_activity
WHERE times_prepared = 0 AND is_available = TRUE
ORDER BY price DESC
LIMIT 10;


/* =============================================================================
   VIEW 2 (KITCHEN perspective) : v_chef_workload
   -----------------------------------------------------------------------------
   For every chef, show their workload: assigned station, shift status, number
   of preparations logged and their average preparation time.
   LEFT JOINs so chefs with no station / no logs still appear.
   Tables combined: chef + kitchen_station + food_prep_log.
   ============================================================================= */
CREATE OR REPLACE VIEW v_chef_workload AS
SELECT
    c.chef_id,
    c.first_name || ' ' || c.last_name   AS chef_name,
    c.specialization,
    ks.station_name,
    c.is_on_shift,
    COUNT(fpl.log_id)                    AS total_preparations,
    ROUND(AVG(fpl.preparation_time), 1)  AS avg_prep_time
FROM chef c
LEFT JOIN kitchen_station ks ON c.current_station_id = ks.station_id
LEFT JOIN food_prep_log fpl  ON fpl.chef_id = c.chef_id
GROUP BY c.chef_id, c.first_name, c.last_name, c.specialization,
         ks.station_name, c.is_on_shift;


-- Report sample: SELECT * (up to 10 rows)
SELECT * FROM v_chef_workload LIMIT 10;

-- VIEW 2 - Query 1 : the 10 busiest chefs (highest number of preparations)
SELECT chef_name, station_name, total_preparations, avg_prep_time
FROM v_chef_workload
ORDER BY total_preparations DESC
LIMIT 10;

-- VIEW 2 - Query 2 : total kitchen load per station
--                    (how many chefs and how many preparations per station)
SELECT station_name,
       COUNT(*)                  AS chefs_count,
       SUM(total_preparations)   AS station_total_preparations
FROM v_chef_workload
WHERE station_name IS NOT NULL
GROUP BY station_name
ORDER BY station_total_preparations DESC;
