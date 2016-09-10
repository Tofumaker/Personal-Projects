require 'sqlite3'
require 'faker'

kitchen = SQLite3::Database.new("kitchen.db")
kitchen.results_as_hash = true

create_fridge_cmd = <<-SQL
  CREATE TABLE IF NOT EXISTS fridge(
    id INTEGER PRIMARY KEY,
    name VARCHAR (255),
    amount INT
  )
SQL
kitchen.execute(create_fridge_cmd)

create_recipebook_cmd = <<-SQL
  CREATE TABLE IF NOT EXISTS recipebook(
    id INTEGER PRIMARY KEY,
    name VARCHAR (255),
    ingredients VARCHAR (2000),
    amounts VARCHAR (255),
    instructions VARCHAR (8000)
  )
SQL
kitchen.execute(create_recipebook_cmd)


kitchen.execute("INSERT INTO fridge (name, amount) VALUES ('tomatoes', 5)")  
kitchen.execute("INSERT INTO fridge (name, amount) VALUES ('eggs', 12)")
kitchen.execute("INSERT INTO fridge (name, amount) VALUES ('bacon', 6)")
kitchen.execute("INSERT INTO recipebook (name, ingredients, amounts, instructions) VALUES ('Tomato Egg Stir-fry','tomatoes,eggs,scallion','2,2,1','this is the instructions!')")

def show_fridge(kitchen)
  fridge = kitchen.execute("SELECT * FROM fridge")
  fridge.each do |item|
    puts (item['name'].to_s + ": " + item['amount'].to_s)
  end 
end

def show_recipes(kitchen)
  recipe = kitchen.execute("SELECT * FROM recipebook")
  recipe.each do |item|
    puts "Recipe Name: #{item['name']}"
    puts "Ingredients: #{item['ingredients']}, #{item['amounts']}"
    puts "Instructions: #{item['instructions']}"
  end
end

show_fridge(kitchen)
show_recipes(kitchen)














