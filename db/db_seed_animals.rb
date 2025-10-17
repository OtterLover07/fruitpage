require 'sqlite3'

db = SQLite3::Database.new("animals.db")

db.execute <<-SQL
  CREATE TABLE IF NOT EXISTS animals (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    legs INTEGER NOT NULL,
    notes TEXT NOT NULL
  );
SQL

db.execute("DELETE FROM animals")  # Rensa tabellen först

animals = [
  ['Tiger',4,'Predator, Mammal'], 
  ['Bunny',4,'Mammal, Common pet'], 
  ['Dodo',2,'Bird (flightless), Extinct'], 
  ['Unicorn',4,'Mythical, Mammal(?)']
]

animals.each do |animal|
  db.execute("INSERT INTO animals (name,legs,notes) VALUES (?,?,?)", animal)
end

puts "Seed data inlagd."