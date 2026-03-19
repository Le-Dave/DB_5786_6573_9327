📘 Restaurant Management System - Stage A
Department: Menu Management
👨‍💻 Authors
[Ton Nom & Prénom] - ID: [Ton ID]
[Nom du Partenaire] - ID: [ID Partenaire]
🏢 Project Scope
System: Restaurant Management System
Unit: Menu Management Department
📌 Table of Contents
Overview
System Interface
ERD and DSD Diagrams
Data Structure Description
Data Insertion Methods
Backup and Recovery
📃 Overview
The Menu Management Department is the backbone of the restaurant's operational flow. This system is designed to manage the entire lifecycle of a dish, from its broad categorization to the technical granular details of its recipe and ingredients.
Key functionalities:
Organizing menu items into logical categories.
Defining precise technical recipes for kitchen staff.
Linking recipes to ingredient inventory for future stock tracking.
Maintaining a full audit trail of any changes (price, availability) made to the menu.
🖥️ System Interface
Generated using Google AI Studio
Below are the conceptual screens representing the "Top-Down" design of the application:
[INSÈRE ICI TA CAPTURE D'ÉCRAN AI STUDIO]
Caption: Dashboard for menu administration and item management.
📂 ERD and DSD Diagrams
ERD (Entity Relationship Diagram)
The ERD illustrates the conceptual logical entities and their relationships.
![alt text](./Stage%20A/ERD_Menu_Management.png)
DSD (Data Schema Diagram)
The DSD (Relational Schema) shows the physical table structures, including Primary and Foreign Keys.
![alt text](./Stage%20A/DSD_Menu_Management.png)
🗃️ Data Structure Description
The database consists of 6 tables designed to handle everything from high-level menu organization to granular ingredient measurements.
1. MENU_CATEGORY
This table serves as the primary organizational structure for the menu.
category_id (PK): A unique auto-incremented integer (Serial) identifying each category.
category_name: A unique descriptive name (e.g., 'Main Courses', 'Beverages').
Constraint: Must be unique and contain at least 2 characters.
description (Optional): A brief text describing what the category includes.
2. INGREDIENT
Represents the raw materials available in the restaurant's pantry.
ingredient_id (PK): Unique identifier for each raw ingredient.
ingredient_name: The name of the ingredient (e.g., 'Sea Salt', 'Organic Flour').
Constraint: Must be unique to prevent stock duplication.
unit: The standard unit of measurement for this ingredient (e.g., 'kg', 'grams', 'liters', 'pcs').
3. MENU_ITEM
The central entity of the system, representing the dishes sold to customers.
menu_item_id (PK): Unique identifier for each dish.
item_name: The commercial name of the dish.
Constraint: Must be unique.
price: The sale price of the item.
Constraint: Must be greater than 0.
description (Optional): Commercial description to be displayed on the menu.
is_available: A boolean flag indicating if the dish is currently orderable.
added_date: The date the item was first introduced to the menu.
Constraint: Cannot be a future date (<= Current Date).
calories (Optional): Total caloric value for nutritional information.
Constraint: Must be greater than or equal to 0.
category_id (FK): Links the item to its parent category.
4. RECIPE
An extension of the Menu Item that provides technical cooking data.
recipe_id (PK): Unique identifier for the recipe.
instructions: Detailed step-by-step text on how to prepare the dish.
Constraint: Must contain at least 10 characters to ensure sufficient detail.
menu_item_id (FK/Unique): Links the recipe to exactly one menu item, maintaining a 1:1 relationship.
5. RECIPE_INGREDIENT
An associative table that defines the specific composition of each recipe. This table allows the many-to-many relationship between Recipes and Ingredients.
recipe_ingredient_id (PK): Unique identifier for each line in the composition.
quantity: The exact amount of the ingredient needed for the recipe.
Constraint: Must be greater than 0.
recipe_id (FK): Reference to the recipe being composed.
ingredient_id (FK): Reference to the raw ingredient being used.
6. MENU_CHANGE_LOG
An audit table used to track all administrative changes made to the menu over time.
change_id (PK): Unique identifier for the log entry.
change_description (Optional): Explanation of what was modified (e.g., 'Price increase', 'Name correction').
change_date: Timestamp of when the modification occurred.
menu_item_id (FK): Reference to the specific menu item that was modified.
🧠 Design Decisions
3NF Normalization: The schema is fully normalized to the 3rd Normal Form to eliminate data redundancy and ensure integrity.
Identifying Relationships: We used identifying relationships for Recipe and Log as they cannot exist without a parent Menu_Item.
Data Integrity: Implemented CHECK constraints on price (>0), calories (>=0), and quantity (>0) to prevent logical data entry errors.
Temporal Tracking: Included added_date and change_date to satisfy the requirement for significant date attributes.
📥 Data Insertion Methods
The database was populated with over 41,000 records using three distinct methods:
✅ Method A: Mockaroo (SQL Scripts)
Used to generate 500 realistic records for Categories, Menu Items, and Recipes.
[INSÈRE ICI TA CAPTURE D'ÉCRAN DE MOCKAROO]
✅ Method B: Data Import (CSV)
The Ingredient table was populated by importing an external ingredients.csv file using pgAdmin's Import tool.
[INSÈRE ICI TA CAPTURE D'ÉCRAN DE LA FENÊTRE IMPORT DE PGADMIN]
✅ Method C: Python Scripting
A custom Python script was developed to generate high-volume data (20,000 rows each) for the associative and log tables.
[INSÈRE ICI TA CAPTURE D'ÉCRAN DU TERMINAL/CODE PYTHON]
💾 Backup and Recovery
To ensure project safety and portability, a full database backup was performed and tested.
Backup Process: Created a compressed .tar archive.
[INSÈRE LA CAPTURE DU MESSAGE "BACKUP COMPLETED"]
Restoration Test: The backup was successfully restored into a fresh database named DB_Test_Restore.
[INSÈRE LA CAPTURE DU SELECT COUNT(*) DANS LA NOUVELLE BASE]
