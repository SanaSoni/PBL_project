-- HealthChef Database Schema
-- SQLite Database Structure
-- This file contains the database design for the HealthChef application

-- ========================================
-- TABLE: users
-- Stores user account information
-- ========================================
CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ========================================
-- TABLE: user_conditions
-- Stores health conditions for each user
-- ========================================
CREATE TABLE IF NOT EXISTS user_conditions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    condition_type TEXT NOT NULL,
    -- condition_type values: 'diabetes', 'hypertension', 'celiac', 'kidney'
    added_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ========================================
-- TABLE: user_ingredients
-- Stores ingredients in user's pantry
-- ========================================
CREATE TABLE IF NOT EXISTS user_ingredients (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    name TEXT NOT NULL,
    emoji TEXT DEFAULT '🥗',
    freshness INTEGER DEFAULT 100,  -- 0-100 scale
    expiry_days INTEGER DEFAULT 7,  -- Days until expiration
    added_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ========================================
-- TABLE: scanned_foods
-- Stores history of scanned foods
-- ========================================
CREATE TABLE IF NOT EXISTS scanned_foods (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    food_name TEXT NOT NULL,
    calories INTEGER,
    carbs TEXT,
    protein TEXT,
    fat TEXT,
    sugar TEXT,
    sodium TEXT,
    is_safe BOOLEAN DEFAULT 1,  -- 1 = safe, 0 = unsafe for user's conditions
    scanned_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ========================================
-- TABLE: user_recipes
-- Stores saved/favorite recipes
-- ========================================
CREATE TABLE IF NOT EXISTS user_recipes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    recipe_name TEXT NOT NULL,
    ingredients TEXT,  -- Stored as JSON string
    instructions TEXT,
    cooking_time INTEGER,  -- in minutes
    difficulty TEXT,  -- 'Easy', 'Medium', 'Hard'
    health_score INTEGER DEFAULT 0,  -- 0-100 scale
    is_safe BOOLEAN DEFAULT 1,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ========================================
-- INDEXES for better query performance
-- ========================================
CREATE INDEX IF NOT EXISTS idx_user_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_user_conditions_user_id ON user_conditions(user_id);
CREATE INDEX IF NOT EXISTS idx_user_ingredients_user_id ON user_ingredients(user_id);
CREATE INDEX IF NOT EXISTS idx_scanned_foods_user_id ON scanned_foods(user_id);
CREATE INDEX IF NOT EXISTS idx_user_recipes_user_id ON user_recipes(user_id);

-- ========================================
-- SAMPLE DATA (for testing)
-- ========================================

-- Sample User
INSERT INTO users (name, email, password) VALUES 
('John Doe', 'john@example.com', 'password123'),
('Jane Smith', 'jane@example.com', 'securepass456');

-- Sample Conditions for User 1
INSERT INTO user_conditions (user_id, condition_type) VALUES 
(1, 'diabetes'),
(1, 'hypertension');

-- Sample Conditions for User 2
INSERT INTO user_conditions (user_id, condition_type) VALUES 
(2, 'celiac');

-- Sample Ingredients for User 1
INSERT INTO user_ingredients (user_id, name, emoji, freshness, expiry_days) VALUES 
(1, 'Tomatoes', '🍅', 95, 5),
(1, 'Chicken Breast', '🍗', 85, 2),
(1, 'Brown Rice', '🌾', 100, 30),
(1, 'Spinach', '🥬', 70, 3);

-- Sample Ingredients for User 2
INSERT INTO user_ingredients (user_id, name, emoji, freshness, expiry_days) VALUES 
(2, 'Quinoa', '🌾', 100, 20),
(2, 'Salmon', '🐟', 90, 2),
(2, 'Broccoli', '🥦', 85, 4);

-- Sample Scanned Foods
INSERT INTO scanned_foods (user_id, food_name, calories, carbs, protein, fat, sugar, sodium, is_safe) VALUES 
(1, 'Chocolate Cake', 450, '58g', '6g', '22g', '42g', '320mg', 0),
(1, 'Grilled Chicken Salad', 320, '15g', '35g', '12g', '5g', '180mg', 1);

-- Sample Recipes
INSERT INTO user_recipes (user_id, recipe_name, ingredients, instructions, cooking_time, difficulty, health_score, is_safe) VALUES 
(1, 'Herb-Grilled Chicken & Greens', 
 '["Chicken Breast", "Spinach", "Tomatoes", "Olive Oil", "Herbs"]',
 'Heat grill. Season chicken. Cook 6-7 min per side. Steam spinach. Serve.',
 25, 'Easy', 95, 1),
(1, 'Power Bowl with Brown Rice',
 '["Brown Rice", "Chicken Breast", "Spinach", "Sesame Seeds"]',
 'Cook rice. Sear chicken. Wilt spinach. Assemble bowl. Top with seeds.',
 30, 'Easy', 92, 1);

-- ========================================
-- USEFUL QUERIES
-- ========================================

-- Get user with their conditions
-- SELECT u.*, GROUP_CONCAT(uc.condition_type) as conditions
-- FROM users u
-- LEFT JOIN user_conditions uc ON u.id = uc.user_id
-- WHERE u.email = 'john@example.com'
-- GROUP BY u.id;

-- Get user's pantry with expiring items first
-- SELECT * FROM user_ingredients
-- WHERE user_id = 1
-- ORDER BY expiry_days ASC, freshness ASC;

-- Get user's safe recipes
-- SELECT * FROM user_recipes
-- WHERE user_id = 1 AND is_safe = 1
-- ORDER BY health_score DESC;

-- Count users by condition
-- SELECT condition_type, COUNT(*) as user_count
-- FROM user_conditions
-- GROUP BY condition_type;

-- Find ingredients expiring within 3 days
-- SELECT ui.*, u.name as user_name
-- FROM user_ingredients ui
-- JOIN users u ON ui.user_id = u.id
-- WHERE ui.expiry_days <= 3
-- ORDER BY ui.expiry_days ASC;
