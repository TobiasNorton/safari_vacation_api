# This will allow us to write a sinatra app that has API routes
require 'sinatra'
# This allows us to respond with JSON data
require 'sinatra/json'
# This allows us to have Sinatra automatically reload our code
require 'sinatra/reloader' if development?
# Requires the ActiveRecord code to work with the database
require 'active_record'

ActiveRecord::Base.establish_connection(
adapter: "postgresql",
database: "safari_vacation"
)

class SeenAnimal < ActiveRecord::Base
end

get '/' do
  return "Welcome to Safari Vacation"
end

# Show all animals
get '/animals' do
  seen_animals = SeenAnimal.all.reorder("id")
  json({ seen_animals: seen_animals})
  # The most simple way is >>>> json SeenAnimal.all
end

# Show animals of a given species

# get '/Search/:species' do
# specices = params["species]"}
# end

# get '/Search/:species' do
#   json SeenAnimal.where(species: params["species"])
# end

#OR if you want /Search?species=lion
get '/Search' do
  json SeenAnimal.where('species LIKE ?', "%#{params["species"]}%")
end
 


# Add an animal to the database
post '/animals' do
  data = JSON.parse(request.body.read)
  seen_animals_params = data["seen_animals"]
  new_seen_animal = SeenAnimal.create(seen_animals_params)
  json({ seen_animals: new_seen_animal })
end 

# Show animals of a given location
get '/animals/:location' do
  json SeenAnimal.where(location_of_last_seen: params["location"])
end

put '/animals/:species' do
  found_animal = SeenAnimal.find_by(species: params["species"])
  new_count = found_animal.count_of_times_seen + 1
  found_animal.update(count_of_times_seen: new_count)
  json found_animal
end

delete '/animals/:id' do
  deleted_animal = SeenAnimal.find(params["id"])
  deleted_animal.destroy
  json deleted_animal
end