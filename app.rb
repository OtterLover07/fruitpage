require 'sinatra'
require 'sinatra/reloader'
require 'slim'

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

get('/fruits') do
    @fruits = ["banan", "melon", "kiwi", "citron"]
    slim(:fruits)
end

get('/fruits/:id') do
    fruits = ["banan", "melon", "kiwi", "citron"]
    id = params[:id].to_i
    @fruit = fruits[id]
    slim(:fruits2)
end

get('/fruitinfo') do
    @fruitlist = $globalfruits

    slim(:fruitinfo)
end

get ('/newfruit/:fruit') do
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