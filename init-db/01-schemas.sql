-- 1. Independent tables
CREATE TABLE MENU_CATEGORY (
  category_id SERIAL PRIMARY KEY,
  category_name VARCHAR(100) NOT NULL UNIQUE,
  description TEXT,
  -- CONSTRAINT: Ensure the category name is not just empty spaces
  CONSTRAINT check_category_name CHECK (char_length(trim(category_name)) >= 2)
);

CREATE TABLE INGREDIENT (
  ingredient_id SERIAL PRIMARY KEY,
  ingredient_name VARCHAR(100) NOT NULL UNIQUE,
  unit VARCHAR(20) NOT NULL,
  -- CONSTRAINT: Name must be valid
  CONSTRAINT check_ingredient_name CHECK (char_length(trim(ingredient_name)) >= 2)
);

-- 2. Dependent tables
CREATE TABLE MENU_ITEM (
  menu_item_id SERIAL PRIMARY KEY,
  item_name VARCHAR(150) NOT NULL UNIQUE,
  price DECIMAL(10, 2) NOT NULL,
  description TEXT,
  is_available BOOLEAN NOT NULL DEFAULT TRUE,
  category_id INT NOT NULL,
  -- CONSTRAINT: Price must be positive (a dish cannot be free or negative)
  CONSTRAINT check_price_positive CHECK (price > 0),
  CONSTRAINT fk_category 
    FOREIGN KEY (category_id) 
    REFERENCES MENU_CATEGORY(category_id) 
    ON DELETE CASCADE
);

-- 3. Weak Entities
CREATE TABLE RECIPE (
  recipe_id SERIAL PRIMARY KEY,
  instructions TEXT NOT NULL,
  menu_item_id INT NOT NULL UNIQUE,
  -- CONSTRAINT: Instructions must actually contain text
  CONSTRAINT check_instructions_length CHECK (char_length(instructions) > 10),
  CONSTRAINT fk_menu_item 
    FOREIGN KEY (menu_item_id) 
    REFERENCES MENU_ITEM(menu_item_id) 
    ON DELETE CASCADE
);

CREATE TABLE MENU_CHANGE_LOG (
  change_id SERIAL PRIMARY KEY,
  change_description TEXT,
  change_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  menu_item_id INT NOT NULL,
  CONSTRAINT fk_menu_item_log 
    FOREIGN KEY (menu_item_id) 
    REFERENCES MENU_ITEM(menu_item_id) 
    ON DELETE CASCADE
);

-- 4. Associative Table
CREATE TABLE RECIPE_INGREDIENT (
  recipe_ingredient_id SERIAL PRIMARY KEY,
  quantity DECIMAL(10, 3) NOT NULL,
  recipe_id INT NOT NULL,
  ingredient_id INT NOT NULL,
  -- CONSTRAINT: Quantity used must be greater than zero
  CONSTRAINT check_quantity_positive CHECK (quantity > 0),
  CONSTRAINT fk_recipe 
    FOREIGN KEY (recipe_id) 
    REFERENCES RECIPE(recipe_id) 
    ON DELETE CASCADE,
  CONSTRAINT fk_ingredient 
    FOREIGN KEY (ingredient_id) 
    REFERENCES INGREDIENT(ingredient_id) 
    ON DELETE RESTRICT
);