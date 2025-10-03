require 'sinatra'
require 'sinatra/reloader'
require 'slim'
require 'sqlite3'

$fruitlist = ["apple", "pear", "guava", "papaya", "lemon", "lime", "pineapple"]
$berrylist = ["banana", "berry", "melon", "tomato"]
$veggielist = ["cucumber", "pepper", "carrot", "potato"]

$globalfruits = []

class Item
    attr_reader :name

    def initialize(name)
        @name = name
    end

    def fruit?
        $fruitlist.each do | object|
            if @name.include?(object) then return true end
        end
        return false
    end

    def berry?
        $berrylist.each do | object|
            if @name.include?(object) then return true end
        end
        return false
    end

    def veggie?
        $veggielist.each do | object|
            if @name.include?(object) then return true end
        end
        return false
    end

    def category
        if self.fruit? then return "fruit" end
        if self.berry? then return "berry" end
        if self.veggie? then return "vegetable" end
        return "other"
    end
end



get('/') do
    slim(:home)
end

get('/fruits') do
    db = SQLite3::Database.new("db/fruits.db")
    db.case_sensitive_like = false
    db.results_as_hash = true

    if (@query = params[:q]) != nil
        @fruits = db.execute("SELECT * FROM fruits WHERE name LIKE ?","%#{@query.upcase}")
        # @fruits = db.execute("SELECT * FROM fruits WHERE UPPER(name) LIKE ?","%#{@query.upcase}")
    else
        @fruits = db.execute("SELECT * FROM fruits")
    end

    slim(:"fruits/index")
end

get('/fruits/new') do
    slim(:"fruits/new")
end

post('/newfruit') do
    db = SQLite3::Database.new("db/fruits.db")
    name, amount = params[:name], params[:amount].to_i

    db.execute("INSERT INTO fruits (name, amount) VALUES (?,?)",[name,amount])
    redirect('/fruits')
end

get('/about') do
    slim(:about)
end

get('/banan') do
    slim(:banan)
end

get('/test/:name') do
    @name = params[:name]
    slim(:homename)
end

get('/fruits_old') do
    @fruits = ["banan", "melon", "kiwi", "citron"]
    slim(:fruits_old)
end

get('/fruits_old/:id') do
    fruits = ["banan", "melon", "kiwi", "citron"]
    id = params[:id].to_i
    @fruit = fruits[id]
    slim(:fruits2)
end

get('/fruitinfo') do
    @fruitlist = $globalfruits

    slim(:fruitinfo)
end

get ('/newfruit_old/:fruit') do
    choice = Item.new(params[:fruit].to_s)
    $globalfruits << @frukt = {
        "name" => choice.name,
        "weight" => choice.name.length + rand(-2..2) + rand(-1.0..1.0).round(2),
        "color" => "rainbow, somehow",
        "category" => choice.category
    }

    slim(:newfruit)
end

get ('/latestfruit') do
    @frukt = $globalfruits[-1]
    
    slim(:latestfruit)
end