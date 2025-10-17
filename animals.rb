require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/flash'
require 'slim'
require 'sqlite3'

post('/login') do
    pass = params[:pass]
    if pass == "AdminPassword1234"
        session[:admin] = true
        flash[:login] = "Info: Login successful"
    else
        flash[:login] = "Info: Login unsucessful"
    end
    redirect('/animals')
end

post('/logout') do
    session[:admin] = false
    flash[:login] = "Info: Logged out"
    redirect('/animals')
end

get('/animals') do
    db = SQLite3::Database.new("db/animals.db")
    db.case_sensitive_like = false
    db.results_as_hash = true
    
    if (@query = params[:q]) != nil
        @animals = db.execute("SELECT * FROM animals WHERE name LIKE ?","%#{@query.upcase}")
    else
        @animals = db.execute("SELECT * FROM animals")
    end

    slim(:"animals/index")
end

get('/animals/new') do
    slim(:"animals/new")
end

post('/animals/new') do
    db = SQLite3::Database.new("db/animals.db")
    animal = [params[:name], params[:legs].to_i, params[:notes]]

    if db.execute("INSERT INTO animals (name, legs, notes) VALUES (?,?,?)",animal)
        flash[:new] = "Info: #{animal[0]} successfully added"
    else
        flash[:new] = "Error: #{animal[0]} could not be added to database"
    end
    redirect('/animals')
end

post('/animals/:id/delete') do
    db = SQLite3::Database.new("db/animals.db")
    to_delete = params[:id].to_i

    if db.execute("DELETE FROM animals WHERE id=?",to_delete)
        flash[:delete] = "Info: Animal successfully deleted"
    else
        flash[:delete] = "Error: Animal could not be deleted"
    end
    redirect('/animals')
end

get('/animals/:id/edit') do
    db = SQLite3::Database.new("db/animals.db")
    db.results_as_hash = true
    id = params[:id].to_i
    
    @animal = db.execute("SELECT * FROM animals WHERE id=?",id).first

    slim(:"animals/edit")
end

post('/animals/:id/edit') do
    db = SQLite3::Database.new("db/animals.db")
    db.results_as_hash = true
    animal = [params[:name], params[:legs].to_i, params[:notes], params[:id].to_i]
    old = db.execute("SELECT * FROM animals WHERE id=?",animal[-1]).first

    if db.execute("UPDATE animals SET name=?, legs=?, notes=? WHERE id=?",animal)
        if animal[0] != old["name"]
            flash[:name] = "Info: Name successfully changed to #{animal[0]}"
        end
        if animal[1] != old["legs"].to_i
            flash[:amount] = "Info: Amount of legs successfully changed to #{animal[1]}"
        end
        if animal[2] != old["notes"]
            flash[:amount] = "Info: Notes successfully changed"
        end
    else
        flash[:edit] = "Error: Could not edit Animal"
    end
    redirect('/animals')
end