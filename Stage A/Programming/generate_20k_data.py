import random
from datetime import datetime, timedelta

# Configuration: Number of records to generate for each table
NUM_RECORDS = 20000

# Function to generate SQL for MENU_CHANGE_LOG table
def generate_menu_change_logs():
    descriptions = [
        "Updated price for seasonal adjustment",
        "Refined item description for marketing",
        "Updated availability status",
        "Adjusted nutritional information (calories)",
        "Changed display name on digital menu",
        "Modified recipe link in the system",
        "Standardized unit measurements",
        None # Some descriptions can be NULL (Optional)
    ]
    
    with open('insert_logs_20k.sql', 'w') as f:
        for _ in range(NUM_RECORDS):
            # References one of the 500 items generated via Mockaroo
            menu_item_id = random.randint(1, 500)
            
            # Select a random description or NULL
            desc = random.choice(descriptions)
            desc_val = f"'{desc}'" if desc else "NULL"
            
            # Generate random date/time within the last 3 years
            random_days = random.randint(0, 1095)
            random_seconds = random.randint(0, 86400)
            # Format: Day/Month/Year Hour:Minute:Second
            log_timestamp = (datetime.now() - timedelta(days=random_days, seconds=random_seconds)).strftime('%d/%m/%Y %H:%M:%S')
            
            # SERIAL change_id is handled automatically by Postgres
            # We use TO_TIMESTAMP to ensure the DD/MM/YYYY format is parsed correctly
            f.write(f"INSERT INTO MENU_CHANGE_LOG (change_description, change_date, menu_item_id) VALUES ({desc_val}, TO_TIMESTAMP('{log_timestamp}', 'DD/MM/YYYY HH24:MI:SS'), {menu_item_id});\n")

# Function to generate SQL for RECIPE_INGREDIENT table
def generate_recipe_ingredients():
    with open('insert_recipe_ingredients_20k.sql', 'w') as f:
        for _ in range(NUM_RECORDS):
            # References one of the 500 recipes and ingredients
            recipe_id = random.randint(1, 500)
            ingredient_id = random.randint(1, 500)
            
            # FIX: Using string formatting instead of round() to avoid type-checker errors
            # This ensures exactly 3 decimal places (e.g. 1.250) for your DECIMAL(10,3) field
            quantity = f"{random.uniform(0.001, 10.0):.3f}"
            
            # SERIAL recipe_ingredient_id is handled automatically by Postgres
            f.write(f"INSERT INTO RECIPE_INGREDIENT (quantity, recipe_id, ingredient_id) VALUES ({quantity}, {recipe_id}, {ingredient_id});\n")

if __name__ == "__main__":
    print("--- Starting Generation of 40,000 Records ---")
    
    generate_menu_change_logs()
    print("File 'insert_logs_20k.sql' created successfully with DD/MM/YYYY format.")
    
    generate_recipe_ingredients()
    print("File 'insert_recipe_ingredients_20k.sql' created successfully.")
    
    print("--- Process Completed ---")