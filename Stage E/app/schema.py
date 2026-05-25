"""
schema.py - Metadata describing the 12 tables of the integrated database.

For every table we store:
  - display_name : human title shown in the UI
  - table        : real table name
  - pk           : primary-key column (kept internally, never shown to the user)
  - label_query  : "SELECT <pk> AS id, <expr> AS label ..." used to (a) build
                   foreign-key dropdowns and (b) replace FK ids by readable names
  - columns      : ordered list of column definitions

Column keys:
  name, label, type, required(bool), readonly(bool),
  fk(table-key if foreign key), choices(list for enums)

Types: 'serial' (auto PK), 'text', 'int', 'numeric', 'date', 'timestamp',
       'bool', 'fk'
"""

UNIT_CHOICES = ["kg", "grams", "ml", "liters", "pieces", "oz"]
ORDER_STATUS = ["Pending", "In-Prep", "Ready", "Served", "Cancelled"]
HYGIENE_STATUS = ["Perfect condition", "All clean", "Passed inspection",
                  "Needs improvement", "Fridge slightly warm", "Good"]

TABLES = {
    "menu_category": {
        "display_name": "Menu Categories",
        "table": "menu_category",
        "pk": "category_id",
        "label_query": "SELECT category_id AS id, category_name AS label "
                       "FROM menu_category ORDER BY label",
        "columns": [
            {"name": "category_id", "label": "ID", "type": "serial"},
            {"name": "category_name", "label": "Category Name", "type": "text", "required": True},
            {"name": "description", "label": "Description", "type": "text"},
        ],
    },
    "ingredient": {
        "display_name": "Ingredients",
        "table": "ingredient",
        "pk": "ingredient_id",
        "label_query": "SELECT ingredient_id AS id, ingredient_name AS label "
                       "FROM ingredient ORDER BY label",
        "columns": [
            {"name": "ingredient_id", "label": "ID", "type": "serial"},
            {"name": "ingredient_name", "label": "Ingredient Name", "type": "text", "required": True},
            {"name": "unit", "label": "Unit", "type": "text", "required": True, "choices": UNIT_CHOICES},
        ],
    },
    "menu_item": {
        "display_name": "Menu Items",
        "table": "menu_item",
        "pk": "menu_item_id",
        "label_query": "SELECT menu_item_id AS id, item_name AS label "
                       "FROM menu_item ORDER BY label",
        "columns": [
            {"name": "menu_item_id", "label": "ID", "type": "serial"},
            {"name": "item_name", "label": "Item Name", "type": "text", "required": True},
            {"name": "price", "label": "Price", "type": "numeric", "required": True},
            {"name": "description", "label": "Description", "type": "text"},
            {"name": "is_available", "label": "Available", "type": "bool"},
            {"name": "added_date", "label": "Added Date", "type": "date"},
            {"name": "calories", "label": "Calories", "type": "int"},
            {"name": "category_id", "label": "Category", "type": "fk", "fk": "menu_category", "required": True},
            {"name": "times_prepared", "label": "Times Prepared", "type": "int", "readonly": True},
        ],
    },
    "recipe": {
        "display_name": "Recipes",
        "table": "recipe",
        "pk": "recipe_id",
        "label_query": "SELECT r.recipe_id AS id, m.item_name AS label "
                       "FROM recipe r JOIN menu_item m ON m.menu_item_id = r.menu_item_id "
                       "ORDER BY label",
        "columns": [
            {"name": "recipe_id", "label": "ID", "type": "serial"},
            {"name": "menu_item_id", "label": "Menu Item", "type": "fk", "fk": "menu_item", "required": True},
            {"name": "instructions", "label": "Instructions", "type": "text", "required": True},
        ],
    },
    "menu_change_log": {
        "display_name": "Menu Change Log",
        "table": "menu_change_log",
        "pk": "change_id",
        "label_query": "SELECT change_id AS id, ('Change #' || change_id) AS label "
                       "FROM menu_change_log ORDER BY change_id",
        "columns": [
            {"name": "change_id", "label": "ID", "type": "serial"},
            {"name": "menu_item_id", "label": "Menu Item", "type": "fk", "fk": "menu_item", "required": True},
            {"name": "change_description", "label": "Description", "type": "text"},
            {"name": "change_date", "label": "Change Date", "type": "timestamp"},
        ],
    },
    "recipe_ingredient": {
        "display_name": "Recipe Ingredients",
        "table": "recipe_ingredient",
        "pk": "recipe_ingredient_id",
        "label_query": "SELECT recipe_ingredient_id AS id, "
                       "('RI #' || recipe_ingredient_id) AS label "
                       "FROM recipe_ingredient ORDER BY recipe_ingredient_id",
        "columns": [
            {"name": "recipe_ingredient_id", "label": "ID", "type": "serial"},
            {"name": "recipe_id", "label": "Recipe", "type": "fk", "fk": "recipe", "required": True},
            {"name": "ingredient_id", "label": "Ingredient", "type": "fk", "fk": "ingredient", "required": True},
            {"name": "quantity", "label": "Quantity", "type": "numeric", "required": True},
        ],
    },
    "kitchen_station": {
        "display_name": "Kitchen Stations",
        "table": "kitchen_station",
        "pk": "station_id",
        "label_query": "SELECT station_id AS id, station_name AS label "
                       "FROM kitchen_station ORDER BY label",
        "columns": [
            {"name": "station_id", "label": "ID", "type": "serial"},
            {"name": "station_name", "label": "Station Name", "type": "text", "required": True},
            {"name": "description", "label": "Description", "type": "text"},
            {"name": "is_active", "label": "Active", "type": "bool"},
        ],
    },
    "chef": {
        "display_name": "Chefs",
        "table": "chef",
        "pk": "chef_id",
        "label_query": "SELECT chef_id AS id, (first_name || ' ' || last_name) AS label "
                       "FROM chef ORDER BY label",
        "columns": [
            {"name": "chef_id", "label": "ID", "type": "serial"},
            {"name": "first_name", "label": "First Name", "type": "text", "required": True},
            {"name": "last_name", "label": "Last Name", "type": "text", "required": True},
            {"name": "specialization", "label": "Specialization", "type": "text"},
            {"name": "hire_date", "label": "Hire Date", "type": "date", "required": True},
            {"name": "current_station_id", "label": "Current Station", "type": "fk", "fk": "kitchen_station"},
            {"name": "is_on_shift", "label": "On Shift", "type": "bool"},
        ],
    },
    "kitchen_order": {
        "display_name": "Kitchen Orders",
        "table": "kitchen_order",
        "pk": "kitchen_order_id",
        "label_query": "SELECT kitchen_order_id AS id, ('Order #' || order_id) AS label "
                       "FROM kitchen_order ORDER BY kitchen_order_id",
        "columns": [
            {"name": "kitchen_order_id", "label": "ID", "type": "serial"},
            {"name": "order_id", "label": "Order Number", "type": "int", "required": True},
            {"name": "status", "label": "Status", "type": "text", "required": True, "choices": ORDER_STATUS},
            {"name": "start_time", "label": "Start Time", "type": "timestamp"},
            {"name": "finish_time", "label": "Finish Time", "type": "timestamp"},
            {"name": "station_id", "label": "Station", "type": "fk", "fk": "kitchen_station"},
        ],
    },
    "food_prep_log": {
        "display_name": "Food Prep Log",
        "table": "food_prep_log",
        "pk": "log_id",
        "label_query": "SELECT log_id AS id, ('Log #' || log_id) AS label "
                       "FROM food_prep_log ORDER BY log_id",
        "columns": [
            {"name": "log_id", "label": "ID", "type": "serial"},
            {"name": "chef_id", "label": "Chef", "type": "fk", "fk": "chef", "required": True},
            {"name": "menu_item_id", "label": "Menu Item", "type": "fk", "fk": "menu_item", "required": True},
            {"name": "preparation_time", "label": "Prep Time (min)", "type": "int", "required": True},
            {"name": "prep_date", "label": "Prep Date", "type": "date"},
            {"name": "notes", "label": "Notes", "type": "text"},
        ],
    },
    "hygiene_inspection": {
        "display_name": "Hygiene Inspections",
        "table": "hygiene_inspection",
        "pk": "inspection_id",
        "label_query": "SELECT inspection_id AS id, ('Inspection #' || inspection_id) AS label "
                       "FROM hygiene_inspection ORDER BY inspection_id",
        "columns": [
            {"name": "inspection_id", "label": "ID", "type": "serial"},
            {"name": "station_id", "label": "Station", "type": "fk", "fk": "kitchen_station", "required": True},
            {"name": "inspector_id", "label": "Inspector (Chef)", "type": "fk", "fk": "chef", "required": True},
            {"name": "inspection_date", "label": "Inspection Date", "type": "date"},
            {"name": "next_inspection_date", "label": "Next Inspection", "type": "date"},
            {"name": "cleanliness_score", "label": "Cleanliness (1-10)", "type": "numeric"},
            {"name": "temperature_check", "label": "Temperature", "type": "numeric"},
            {"name": "status", "label": "Status", "type": "text", "required": True, "choices": HYGIENE_STATUS},
            {"name": "comments", "label": "Comments", "type": "text"},
        ],
    },
    "preparation_task": {
        "display_name": "Preparation Tasks",
        "table": "preparation_task",
        "pk": "task_id",
        "label_query": "SELECT task_id AS id, ('Task #' || task_id) AS label "
                       "FROM preparation_task ORDER BY task_id",
        "columns": [
            {"name": "task_id", "label": "ID", "type": "serial"},
            {"name": "kitchen_order_id", "label": "Kitchen Order", "type": "fk", "fk": "kitchen_order"},
            {"name": "chef_id", "label": "Chef", "type": "fk", "fk": "chef"},
            {"name": "task_description", "label": "Task Description", "type": "text", "required": True},
            {"name": "status", "label": "Status", "type": "text"},
            {"name": "priority_level", "label": "Priority (1-5)", "type": "int"},
        ],
    },
}

# Order in which tables appear in the dashboard
TABLE_ORDER = [
    "menu_category", "ingredient", "menu_item", "recipe",
    "recipe_ingredient", "menu_change_log",
    "kitchen_station", "chef", "kitchen_order",
    "food_prep_log", "hygiene_inspection", "preparation_task",
]
