require 'rest-client'
require 'json'
require 'byebug'
# This file should contain all the record creation needed to seed the database with its default values.

# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Game.destroy_all
# User.destroy_all
# User_Game.destroy_all


def get_games
    game_hash = []
    (1...10).each do |i|
        all_games = RestClient.get("https://api.rawg.io/api/games?page=#{i}&page_size=40")
        game_hash = game_hash + JSON.parse(all_games)["results"]
    end
    game_hash
end 

def get_game_detail
    
    get_games.map do |game| 
        database_id = game["id"]    
        name = game["name"]
        released = game["released"]
        background_image = game["background_image"]
        rating = game["rating"]
        metacritic = game["metacritic"]
        playtime = game["playtime"]
        clip = (game["clip"] === nil ? nil : game["clip"]["clip"]) 
        suggestedData = RestClient.get("https://api.rawg.io/api/games/#{database_id}/suggested")
        suggested = JSON.parse(suggestedData)["results"]
        # suggested.map do |suggestedGame|
            # suggestedGame["name"]
            # suggestedGame["background_image"]
            # suggestedGame["short_description"]
        # end
        suggested_description = suggested.first["short_description"]
        suggested_background_image = suggested.first["background_image"]
        suggested_name = suggested.first["name"]

    Game.find_or_create_by(database_id: database_id, name: name, released: released, background_image: background_image, rating: rating, metacritic: metacritic, playtime:playtime, clip:clip, suggested_description: suggested_description, suggested_background_image: suggested_background_image, suggested_name: suggested_name)
    end

end 

get_game_detail