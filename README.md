# 📘 Restaurant Management System

**Department:** Menu Management

---

## 👨‍💻 Authors
*   **David Nahum** - ID: 341106573
*   **Neriya Horenczyk** - ID: 208729327

## 🏢 Project Scope
*   **System:** Restaurant Management System
*   **Unit:** Menu Management Department

---

## 📌 Table of Contents

### Stage A: Database Design & Foundation
1.  [Overview](#-overview)
2.  [System Interface](#-system-interface)
3.  [ERD and DSD Diagrams](#-erd-and-dsd-diagrams)
4.  [Data Structure Description](#-data-structure-description)
5.  [Design Decisions](#-design-decisions)
6.  [Data Insertion Methods](#-data-insertion-methods)
7.  [Backup and Recovery](#-backup-and-recovery)

### Stage B: Advanced Queries & Data Integrity
8. [Comparative SELECT Queries](#-comparative-select-queries)
9. [Additional SELECT Queries](#-additional-select-queries)
10. [DELETE Queries](#-delete-queries)
11. [UPDATE Queries](#-update-queries)
12. [Database Constraints & Alterations](#-database-constraints--alterations)
13. [Transaction Control](#-transaction-control-rollback--commit)
14. [Backup and Recovery - Stage B](#-backup-and-recovery)

---

# 🏁 STAGE A: DATABASE DESIGN & FOUNDATION

## 📃 Overview
The **Menu Management Department** is the backbone of the restaurant's operational flow. This system is designed to manage the entire lifecycle of a dish, from its broad categorization to the technical granular details of its recipe and ingredients.

**Key functionalities:**
*   Organizing menu items into logical categories.
*   Defining precise technical recipes for kitchen staff.
*   Linking recipes to ingredient inventory for future stock tracking.
*   Maintaining a full audit trail of any changes (price, availability) made to the menu.

---

## 🖥️ System Interface
*Generated using Google AI Studio*

Below are the conceptual screens representing the "Top-Down" design of the application:

**Dashboard**

![App Screen 1](./Stage%20A/Screenshots/App1.png)

**Menu Management**

![App Screen 2](./Stage%20A/Screenshots/App2.png)

**Live Menu View**

![App Screen 3](./Stage%20A/Screenshots/App3.png)

**Menu Analytics**

![App Screen 4](./Stage%20A/Screenshots/App4.png)

### 🔗 Interactive Prototype
You can access the interactive application design generated in Google AI Studio via the following link:
[**View Interactive Menu Management Prototype**](https://aistudio.google.com/apps/fea1348c-0085-43f5-a3fc-40957a48e11b?showPreview=true&showAssistant=true)

---

## 📂 ERD and DSD Diagrams

### ERD (Entity Relationship Diagram)
The ERD illustrates the conceptual logical entities and their relationships.

![ERD Diagram](./Stage%20A/ERD%20Menu%20Managment%20Department%205786.png)

### DSD (Data Schema Diagram)
The DSD (Relational Schema) shows the physical table structures, including Primary and Foreign Keys.

![DSD Diagram](./Stage%20A/DSD%20Menu%20Managment%20Department%205786-Relational%20Schema.png)

---

## 🗃️ Data Structure Description
The database consists of **6 tables** designed to handle everything from high-level menu organization to granular ingredient measurements.

### 1. MENU_CATEGORY
This table serves as the primary organizational structure for the menu.
*   **category_id (PK):** A unique auto-incremented integer (Serial) identifying each category.
*   **category_name:** A unique descriptive name (e.g., 'Main Courses', 'Beverages').
    *   *Constraint:* Must be unique and contain at least 2 characters.
*   **description (Optional):** A brief text describing what the category includes.

### 2. INGREDIENT
Represents the raw materials available in the restaurant's pantry.
*   **ingredient_id (PK):** Unique identifier for each raw ingredient.
*   **ingredient_name:** The name of the ingredient (e.g., 'Sea Salt', 'Organic Flour').
    *   *Constraint:* Must be unique to prevent stock duplication.
*   **unit:** The standard unit of measurement for this ingredient (e.g., 'kg', 'grams', 'liters', 'pcs').

### 3. MENU_ITEM
The central entity of the system, representing the dishes sold to customers.
*   **menu_item_id (PK):** Unique identifier for each dish.
*   **item_name:** The commercial name of the dish.
    *   *Constraint:* Must be unique.
*   **price:** The sale price of the item.
    *   *Constraint:* Must be greater than 0.
*   **description (Optional):** Commercial description to be displayed on the menu.
*   **is_available:** A boolean flag indicating if the dish is currently orderable.
*   **added_date:** The date the item was first introduced to the menu.
    *   *Constraint:* Cannot be a future date (<= Current Date).
*   **calories (Optional):** Total caloric value for nutritional information.
    *   *Constraint:* Must be greater than or equal to 0.
*   **category_id (FK):** Links the item to its parent category.

### 4. RECIPE
An extension of the Menu Item that provides technical cooking data.
*   **recipe_id (PK):** Unique identifier for the recipe.
*   **instructions:** Detailed step-by-step text on how to prepare the dish.
    *   *Constraint:* Must contain at least 10 characters to ensure sufficient detail.
*   **menu_item_id (FK/Unique):** Links the recipe to exactly one menu item, maintaining a **1:1 relationship**.

### 5. RECIPE_INGREDIENT
An associative table that defines the specific composition of each recipe. This table allows the many-to-many relationship between Recipes and Ingredients.
*   **recipe_ingredient_id (PK):** Unique identifier for each line in the composition.
*   **quantity:** The exact amount of the ingredient needed for the recipe.
    *   *Constraint:* Must be greater than 0.
*   **recipe_id (FK):** Reference to the recipe being composed.
*   **ingredient_id (FK):** Reference to the raw ingredient being used.

### 6. MENU_CHANGE_LOG
An audit table used to track all administrative changes made to the menu over time.
*   **change_id (PK):** Unique identifier for the log entry.
*   **change_description (Optional):** Explanation of what was modified (e.g., 'Price increase', 'Name correction').
*   **change_date:** Timestamp of when the modification occurred.
*   **menu_item_id (FK):** Reference to the specific menu item that was modified.

---

## 🧠 Design Decisions
*   **3NF Normalization:** The schema is fully normalized to the 3rd Normal Form to eliminate data redundancy and ensure integrity.
*   **Identifying Relationships:** We used identifying relationships for `Recipe` and `Log` as they cannot exist without a parent `Menu_Item`.
*   **Data Integrity:** Implemented `CHECK` constraints on price (>0), calories (>=0), and quantity (>0) to prevent logical data entry errors.
*   **Temporal Tracking:** Included `added_date` and `change_date` to satisfy the requirement for significant date attributes.

---

## 📥 Data Insertion Methods
The database was populated with over **41,000 records** using three distinct methods:

### ✅ Method A: Mockaroo (SQL Scripts)
Used to generate 500 realistic records for Categories, Menu Items, and Recipes.

![Mockaroo Screenshot](./Stage%20A/Screenshots/Mockaroo.png)

![Mockaroo Screenshot](./Stage%20A/Screenshots/Mockaroo_pgAdmin.png)

### ✅ Method B: Data Import (CSV)
The `Ingredient` table was populated by importing an external `ingredients.csv` file using pgAdmin's Import tool.

![pgAdmin Import](./Stage%20A/Screenshots/Ingredient_csv.png)

![pgAdmin Import](./Stage%20A/Screenshots/Ingredient_csv_IMPORT.png)

### ✅ Method C: Python Scripting
A custom Python script was developed to generate high-volume data (**20,000 rows each**) for the associative and log tables.

![Python Execution](./Stage%20A/Screenshots/PythonScript.png)

![Python Execution](./Stage%20A/Screenshots/PythonScript_pgAdmin.png)

---

## 💾 Backup and Recovery
To ensure project safety and portability, a full database backup was performed and tested.

1.  **Backup Process:** Created a compressed `.tar` archive.

![Backup Success](./Stage%20A/Screenshots/Backup.png)

2.  **Restoration Test:** The backup was successfully restored into a fresh database named `DB_Test_Restore`.

![Restore Verification](./Stage%20A/Screenshots/Restore.png)

---

# 🚀 STAGE B: ADVANCED QUERIES & DATA INTEGRITY

## 🔍 Comparative SELECT Queries
*Execution of queries in two versions to analyze performance.*

### Query 1: Items added in 2024 with Category Names
**What it does:** This query identifies all dishes introduced during the 2024 calendar year. It extracts the year from the `added_date` and performs a join to display the category name instead of a numeric ID.

**Version A (JOIN):**
```sql
SELECT mi.item_name, mi.price, mc.category_name, EXTRACT(YEAR FROM mi.added_date) AS year_added
FROM MENU_ITEM mi
JOIN MENU_CATEGORY mc ON mi.category_id = mc.category_id
WHERE EXTRACT(YEAR FROM mi.added_date) = 2024;
```

![Q1 Result](./Stage%20B/Screenshots/Select_1_VersA.png)

**Version B (Scalar Subquery):**
```sql
SSELECT item_name, price, 
       (SELECT category_name FROM MENU_CATEGORY mc WHERE mc.category_id = mi.category_id) AS category_name,
       EXTRACT(YEAR FROM added_date) AS year_added
FROM MENU_ITEM mi
WHERE EXTRACT(YEAR FROM added_date) = 2024;
```

![Q1 Result](./Stage%20B/Screenshots/Select_1_VersB.png)

**Efficiency Comparison:** **Version A (JOIN)** is more efficient. In PostgreSQL, a JOIN allows the optimizer to use "Hash Join" algorithms to process the tables in a single pass. Version B uses a "Scalar Subquery," which forces the engine to perform a separate lookup for every single row in the Menu Item table, causing poor performance as data volume increases.

### Query 2: Ingredients used in more than 20 recipes
**What it does:** This query scans the 20,000-row RECIPE_INGREDIENT table to find "high-use" ingredients that are versatile enough to be used in over 20 different dishes.

**Version A (GROUP BY / HAVING):**
```sql
SELECT i.ingredient_name, i.unit, COUNT(ri.recipe_id) AS total_recipes
FROM INGREDIENT i
JOIN RECIPE_INGREDIENT ri ON i.ingredient_id = ri.ingredient_id
GROUP BY i.ingredient_name, i.unit
HAVING COUNT(ri.recipe_id) > 20;
```

![Q2 Result](./Stage%20B/Screenshots/Select_2_VersA.png)

**Version B (Scalar Subquery):**
```sql
SELECT i.ingredient_name, i.unit, 
       (SELECT COUNT(*) FROM RECIPE_INGREDIENT ri WHERE ri.ingredient_id = i.ingredient_id) AS total_recipes
FROM INGREDIENT i
WHERE (SELECT COUNT(*) FROM RECIPE_INGREDIENT ri WHERE ri.ingredient_id = i.ingredient_id) > 20;
```

![Q2 Result](./Stage%20B/Screenshots/Select_2_VersB.png)

**Efficiency Comparison:** **Version A (GROUP BY / HAVING)** is superior because it uses "Hash Aggregation," scanning the associative table only once to count all occurrences. Version B executes the count calculation twice for every row (once for the SELECT and once for the WHERE), leading to massive redundancy.

### Query 3: Items priced above their Category Average
**What it does:** A business intelligence tool to find expensive items relative to their peers. It calculates the average price of each category and filters for dishes that exceed that value.

**Version A (Derived Table JOIN):**
```sql
SELECT mi.item_name, mi.price, ROUND(sub.avg_cat_price, 2) AS category_average
FROM MENU_ITEM mi
JOIN (SELECT category_id, AVG(price) AS avg_cat_price FROM MENU_ITEM GROUP BY category_id) sub
  ON mi.category_id = sub.category_id
WHERE mi.price > sub.avg_cat_price;
```

![Q3 Result](./Stage%20B/Screenshots/Select_3_VersA.png)

**Version B (Scalar Subquery):**
```sql
SELECT mi.item_name, mi.price, 
       (SELECT ROUND(AVG(price), 2) FROM MENU_ITEM mi2 WHERE mi2.category_id = mi.category_id) AS category_average
FROM MENU_ITEM mi
WHERE mi.price > (SELECT AVG(price) FROM MENU_ITEM mi3 WHERE mi3.category_id = mi.category_id);
```

![Q3 Result](./Stage%20B/Screenshots/Select_3_VersB.png)

**Efficiency Comparison:** **Version A (Derived Table JOIN)** is highly efficient as it computes the average for each of the 500 categories exactly once. Version B is O(N^2) complex, as it triggers a full scan and average calculation for every single dish being compared, which is extremely inefficient.

### Query 4: Static Items in 2026 (No modifications)
**What it does:** This query identifies dishes that were stable and did not undergo any price or availability changes during the year 2026 by checking for a lack of log entries.

**Version A (NOT EXISTS):**
```sql
SELECT mi.item_name, mi.added_date, mi.price
FROM MENU_ITEM mi
WHERE NOT EXISTS (
    SELECT 1 
    FROM MENU_CHANGE_LOG mcl 
    WHERE mcl.menu_item_id = mi.menu_item_id 
    AND EXTRACT(YEAR FROM mcl.change_date) = 2026
);
```

![Q4 Result](./Stage%20B/Screenshots/Select_4_VersA.png)

**Version B (LEFT JOIN / IS NULL):**
```sql
SELECT mi.item_name, mi.added_date, mi.price
FROM MENU_ITEM mi
LEFT JOIN MENU_CHANGE_LOG mcl ON mi.menu_item_id = mcl.menu_item_id 
    AND EXTRACT(YEAR FROM mcl.change_date) = 2026
WHERE mcl.change_id IS NULL;
```

![Q4 Result](./Stage%20B/Screenshots/Select_4_VersB.png)

**Efficiency Comparison:** **Version A (NOT EXISTS)** is faster in PostgreSQL because it uses "Anti-Join" logic. The engine stops searching for a specific item the moment it finds the first matching log for 2026. Version B must join all items with all logs first before filtering, using more memory and CPU.

---

## 📊 Additional SELECT Queries

### Query 5: Monthly Update Statistics
**What it does:** Counts the total number of menu modifications made per month for the year 2024 to help management understand workload distribution.

```sql
SELECT EXTRACT(MONTH FROM change_date) AS month_num, 
       TO_CHAR(change_date, 'Month') AS month_name, 
       COUNT(*) AS updates_count
FROM MENU_CHANGE_LOG
WHERE EXTRACT(YEAR FROM change_date) = 2024
GROUP BY month_num, month_name
ORDER BY month_num;
```

![Q5 Result](./Stage%20B/Screenshots/Select_5.png)

### Query 6: Chef's Technical Sheet
**What it does:** Joins four tables to produce a detailed cooking guide including the item name, instructions, specific ingredients, and quantities for all active low-cost dishes.

```sql
SELECT mi.item_name, r.instructions, i.ingredient_name, ri.quantity, i.unit
FROM MENU_ITEM mi
JOIN RECIPE r ON mi.menu_item_id = r.menu_item_id
JOIN RECIPE_INGREDIENT ri ON r.recipe_id = ri.recipe_id
JOIN INGREDIENT i ON ri.ingredient_id = i.ingredient_id
WHERE mi.is_available = TRUE AND mi.price < 30
ORDER BY mi.item_name;
```

![Q6 Result](./Stage%20B/Screenshots/Select_6.png)

### Query 7: High-Calorie Category Report
**What it does:** Ranks menu categories based on the average caloric content of their dishes, providing data for designing healthier menu options.

```sql
SELECT mc.category_name, 
       ROUND(AVG(mi.calories), 0) AS avg_calories, 
       COUNT(mi.menu_item_id) AS total_items
FROM MENU_CATEGORY mc
JOIN MENU_ITEM mi ON mc.category_id = mi.category_id
WHERE mi.calories IS NOT NULL
GROUP BY mc.category_name
HAVING COUNT(mi.menu_item_id) >= 1
ORDER BY avg_calories DESC
LIMIT 5;
```

![Q7 Result](./Stage%20B/Screenshots/Select_7.png)

### Query 8: Weekend Change Audit
**What it does:** Lists all changes made during Fridays and Saturdays to monitor weekend administrative activity and ensure security compliance.

```sql
SELECT mi.item_name, mcl.change_description, 
       TO_CHAR(mcl.change_date, 'Day') AS day_name, 
       mcl.change_date
FROM MENU_CHANGE_LOG mcl
JOIN MENU_ITEM mi ON mcl.menu_item_id = mi.menu_item_id
WHERE EXTRACT(DOW FROM mcl.change_date) IN (5, 6) -- 5=Friday, 6=Saturday
ORDER BY mcl.change_date DESC;
```

![Q8 Result](./Stage%20B/Screenshots/Select_8.png)

---

## 🗑️ DELETE Queries

### Delete 1: Administrative Log Archiving
**What it does:** Removes historical change logs older than 2 years to keep the database performance optimal and clear storage space.

```sql
DELETE FROM MENU_CHANGE_LOG 
WHERE change_date < CURRENT_DATE - INTERVAL '2 years';
```

**Before:** 

![D1 Before](./Stage%20B/Screenshots/Delete_1_Bef.png)

**After:** 

![D1 After](./Stage%20B/Screenshots/Delete_1_Aft.png)

### Delete 2: Empty Category Cleanup
**What it does:** Deletes any menu categories that do not contain any dishes, ensuring a tidy and logical menu structure.

```sql
DELETE FROM MENU_CATEGORY
WHERE category_id NOT IN (SELECT DISTINCT category_id FROM MENU_ITEM);
```

**Before:** 

![D2 Before](./Stage%20B/Screenshots/Delete_2_Bef.png)

**After:** 

![D2 After](./Stage%20B/Screenshots/Delete_2_Aft.png)

### Delete 3: Recipe Ingredient Simplification
**What it does:** Removes ingredient lines from recipes where the required quantity is less than 0.005, simplifying technical sheets for the kitchen staff.

```sql
DELETE FROM RECIPE_INGREDIENT
WHERE quantity < 0.005;
```

**Before:** 

![D3 Before](./Stage%20B/Screenshots/Delete_3_Bef.png)

**After:** 

![D3 After](./Stage%20B/Screenshots/Delete_3_Aft.png)

## ✏️ UPDATE Queries

### Update 1: Beef Price Inflation Adjustment
**What it does:** Increases the price by 12% for all dishes that contain "Beef" as an ingredient in their recipe, responding to market cost fluctuations.

```sql
UPDATE MENU_ITEM 
SET price = price * 1.12
WHERE menu_item_id IN (
    SELECT r.menu_item_id 
    FROM RECIPE r
    JOIN RECIPE_INGREDIENT ri ON r.recipe_id = ri.recipe_id
    JOIN INGREDIENT i ON ri.ingredient_id = i.ingredient_id
    WHERE i.ingredient_name LIKE '%Beef%'
);
```

**Before:** 

![U1 Before](./Stage%20B/Screenshots/Update_1_Bef.png)

**After:** 

![U1 After](./Stage%20B/Screenshots/Update_1_Aft.png)

### Update 2: Seasonal BBQ Availability Cleanup
**What it does:** Sets is_available to False for all items in the BBQ category that have not been updated for over 2 years.

```sql
UPDATE MENU_ITEM
SET is_available = FALSE
WHERE category_id IN (SELECT category_id FROM MENU_CATEGORY WHERE category_name LIKE '%BBQ%')
AND added_date < CURRENT_DATE - INTERVAL '2 years';
```

**Before:** 

![U2 Before](./Stage%20B/Screenshots/Update_2_Bef.png)

**After:** 

![U2 After](./Stage%20B/Screenshots/Update_2_Aft.png)

### Update 3: Morning Log Description Normalization
**What it does:** Automatically fills empty log descriptions with a standard "Morning system check" note for all updates performed before 10:00 AM.

```sql
UPDATE MENU_CHANGE_LOG
SET change_description = 'Routine morning system check'
WHERE change_description IS NULL 
AND EXTRACT(HOUR FROM change_date) < 10;
```

**Before:** 

![U3 Before](./Stage%20B/Screenshots/Update_3_Bef.png)

**After:** 

![U3 After](./Stage%20B/Screenshots/Update_3_Aft.png)

---

## 🛡️ Database Constraints & Alterations

### Constraint 1: Standardized Measurement Units
**What it does:** Uses ALTER TABLE to restrict the unit column in the Ingredient table to a pre-defined list of culinary units (kg, g, ml, etc.), preventing data entry typos.

```sql
ALTER TABLE INGREDIENT ADD CONSTRAINT check_unit_standard CHECK (unit IN ('kg', 'grams', 'ml', 'liters', 'pieces', 'oz'));
```

**Violation Test:** 

```sql
INSERT INTO INGREDIENT (ingredient_name, unit) 
VALUES ('Test Ingredient', 'box');
```

![C1 Error](./Stage%20B/Screenshots/New_Constraint_1.png)

### Constraint 2: Price Safety Cap ($500)
**What it does:** Implements a price ceiling of $500 for any menu item to prevent catastrophic typing errors (e.g., $1000 instead of $10.00).

```sql
ALTER TABLE MENU_ITEM ADD CONSTRAINT check_max_price CHECK (price < 500);
```

**Violation Test:** 

```sql
INSERT INTO MENU_ITEM (item_name, price, is_available, added_date, category_id) 
VALUES ('Gold Burger', 650.00, TRUE, CURRENT_DATE, 1);
```

![C2 Error](./Stage%20B/Screenshots/New_Constraint_2.png)

### Constraint 3: Minimum Item Name Length
**What it does:** Ensures that every dish name in the `MENU_ITEM` table consists of at least 3 characters. This prevents the entry of non-descriptive placeholders (like "A" or "TBD") and maintains a professional-looking customer menu.

```sql
ALTER TABLE MENU_ITEM ADD CONSTRAINT check_item_name_length CHECK (LENGTH(item_name) >= 3);
```

**Violation Test:** 

```sql
INSERT INTO MENU_ITEM (item_name, price, is_available, added_date, category_id) 
VALUES ('A', 15.00, TRUE, CURRENT_DATE, 1);
```

![C3 Error](./Stage%20B/Screenshots/New_Constraint_3.png)

### Constraint 4: Historical Log Date Validation
**What it does:** Validates that no entry in the `MENU_CHANGE_LOG` is dated prior to January 1st, 2020 (the system's launch year). This maintains historical integrity by preventing logs from being accidentally backdated to impossible years.

```sql
ALTER TABLE MENU_CHANGE_LOG ADD CONSTRAINT check_valid_log_date CHECK (change_date >= '2020-01-01');
```

**Violation Test:** 

```sql
INSERT INTO MENU_CHANGE_LOG (change_description, change_date, menu_item_id) 
VALUES ('Legacy change', '1995-01-01', 1);
```

![C4 Error](./Stage%20B/Screenshots/New_Constraint_4.png)

---

## 🔄 Transaction Control (Rollback & Commit)

### 🔙 Rollback Transaction
**What it does:** Demonstrates the use of the ROLLBACK command to undo changes made during a transaction. This ensures data integrity by allowing users to discard erroneous or unwanted modifications before they are permanently saved to the database. Our example : Simulates an administrator error - accidental $50 increase menu-wide.

```sql
-- Step 1: Baseline check - View the original prices of the first 5 items
SELECT menu_item_id, item_name, price 
FROM MENU_ITEM 
ORDER BY menu_item_id 
LIMIT 5;

-- Step 2: Start the transaction
BEGIN;

-- Step 3: Simulate the error (Unintended price increase)
UPDATE MENU_ITEM 
SET price = price + 50;

-- Step 4: Verification of the "Modified" state
-- The prices are now inflated.
SELECT menu_item_id, item_name, price 
FROM MENU_ITEM 
ORDER BY menu_item_id 
LIMIT 5;

-- Step 5: Cancel the transaction and undo the changes
ROLLBACK;

-- Step 6: Final verification - Check that prices returned to their original values
SELECT menu_item_id, item_name, price 
FROM MENU_ITEM 
ORDER BY menu_item_id 
LIMIT 5;
```

**Original State:** - *Prices are normal.*

![Rollback Proof](./Stage%20B/Screenshots/Rollback_1.png)

**State after UPDATE (before ROLLBACK):** - *Prices are inflated.*

![Rollback Proof](./Stage%20B/Screenshots/Rollback_2.png)

**After ROLLBACK:** - *Prices are back to normal.*

![Rollback Proof](./Stage%20B/Screenshots/Rollback_3.png)

### ✅ Commit Transaction
**What it does:** Demonstrates the use of the COMMIT command to save changes made during a transaction to the database. This ensures data integrity by allowing users to save erroneous or unwanted modifications before they are permanently saved to the database. Our example : Management applies a permanent +100 calorie adjustment for nutritional updates.

```sql
-- Step 1: Baseline check - View current calorie counts for the first 5 items
SELECT menu_item_id, item_name, calories 
FROM MENU_ITEM 
WHERE calories IS NOT NULL
ORDER BY menu_item_id 
LIMIT 5;

-- Step 2: Start the transaction
BEGIN;

-- Step 3: Apply the update (Nutritional adjustment)
-- We increase calories by 100 for all items that have a calorie value recorded
UPDATE MENU_ITEM 
SET calories = calories + 100
WHERE calories IS NOT NULL;

-- Step 4: Verification of the "Modified" state within the transaction
-- Calorie counts should now be 100 units higher than in Step 1
SELECT menu_item_id, item_name, calories 
FROM MENU_ITEM 
WHERE calories IS NOT NULL
ORDER BY menu_item_id 
LIMIT 5;

-- Step 5: Save the changes permanently to the database
COMMIT;

-- Step 6: Final verification - Confirm that the +100 calorie adjustment persists
SELECT menu_item_id, item_name, calories 
FROM MENU_ITEM 
WHERE calories IS NOT NULL
ORDER BY menu_item_id 
LIMIT 5;    
```

**Original State:** - *Calorie counts are normal.*

![Commit Proof](./Stage%20B/Screenshots/Commit_1.png)

**State after UPDATE (before COMMIT):** - *Calorie counts are inflated.*

![Commit Proof](./Stage%20B/Screenshots/Commit_2.png)

**After COMMIT:** - *The changes are saved permanently to the database.*

![Commit Proof](./Stage%20B/Screenshots/Commit_3.png)

---

## 💾 Backup and Recovery - Stage B
Final stage backup in `.tar` format.

![Backup 2](./Stage%20B/Screenshots/Backup2.png)