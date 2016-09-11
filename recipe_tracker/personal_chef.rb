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


def show_fridge(kitchen)
  fridge = kitchen.execute("SELECT * FROM fridge")
  fridge.each do |item|
    puts (item['name'].to_s + ": " + item['amount'].to_s)
  end 
end

def show_recipes(kitchen)
  puts "************Recipes************"
  recipe = kitchen.execute("SELECT * FROM recipebook")
  recipe.each do |item|
    ingredients_array = item['ingredients'].split(',')
    amounts_array = item['amounts'].split(',')
    puts "RECIPE NAME: #{item['name']}"
    puts "**INGREDIENTS:**"
    i = 0
    while i < ingredients_array.length
      puts (ingredients_array[i] + " x " + amounts_array[i])
      i += 1
    end  
    puts "INSTRUCTIONS: #{item['instructions']}"
    puts " "
  end
end

def search_fridge(kitchen, ingredient, amount)
  fridge = kitchen.execute("SELECT * FROM fridge")
  item_found = false
  fridge.each do |item|
    if ingredient == item['name'] && amount.to_i <= item['amount'].to_i
      item_found = true
    else
    end
  end
  return item_found      
end

def find_available_recipes(kitchen)
  fridge = kitchen.execute("SELECT * FROM fridge")
  recipe = kitchen.execute("SELECT * FROM recipebook")
  recipe.each do |item|
    all_ingredients_found = true
    ingredients_array = item['ingredients'].split(',')
    amounts_array = item['amounts'].split(',')
    i = 0
    puts ("...checking #{item['name']}...")
    while i < ingredients_array.length
      ingredient_found = search_fridge(kitchen, ingredients_array[i] , amounts_array[i])
      if  ingredient_found == false
        puts("#{ingredients_array[i]} not found")
        all_ingredients_found = false
      else
      end
      i += 1
    end
    if all_ingredients_found == true
      puts ("#{item['name']} is available")
    else
      puts ("#{item['name']} is not available")
    end  
  end
end

# kitchen.execute("INSERT INTO fridge (name, amount) VALUES ('tomatoes', 5)")  
# kitchen.execute("INSERT INTO fridge (name, amount) VALUES ('eggs', 12)")
# kitchen.execute("INSERT INTO fridge (name, amount) VALUES ('bacon', 6)")
# kitchen.execute("INSERT INTO fridge (name, amount) VALUES ('scallion', 6)")



# kitchen.execute("INSERT INTO recipebook (name, ingredients, amounts, instructions) VALUES ('Tomato Egg Stir-fry','tomatoes,eggs,scallion','2,2,1','this is the instructions!')")
#kitchen.execute("INSERT INTO recipebook (name, ingredients, amounts, instructions) VALUES ('Southwest Omelet','tomatoes,eggs,cheese,onion,pepper','1,3,1,1,1','this is the instructions!')")




show_fridge(kitchen)
show_recipes(kitchen)


search_fridge(kitchen, 'eggs',12)
search_fridge(kitchen, 'beef', 1)

find_available_recipes(kitchen)













