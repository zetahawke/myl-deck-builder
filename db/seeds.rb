# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


# puts "Creando artistas..."

# [
#   'Mauricio Herrera'
#   # ...
# ].each do |artist|
#   Artist.find_or_create_by(
#     name: artist
#   )
# end

# puts "Creando tipos de cartas..."

# [
#   'Tótem',
#   'Talismán',
#   'Oro Normal',
#   'Oro',
#   'Aliado',
#   'Arma'
# ].each do |card_type|
#   CardType.find_or_create_by(
#     name: card_type
#   )
# end

# puts "Creando ediciones..."

# [
#   {
#     name: 'helénica',
#     races: [
#       'Titán',
#       'Olímpico',
#       'Héroe'
#     ]
#   },
#   {
#     name: 'espada sagrada',
#     races: [
#       'Caballero',
#       'Dragón',
#       'Faerie'
#     ]
#   },
#   {
#     name: 'Hijos de Daana',
#     races: [
#       'Sombra',
#       'Desafiante',
#       'Defensor'
#     ]
#   },
#   {
#     name: 'Dominios de Ra',
#     races: [
#       'Eterno',
#       'Sacerdote',
#       'Faraón'
#     ]
#   }
# ].each do |edition|
#   new_edition = Edition.find_or_create_by(
#     name: edition[:name]
#   )

#   puts "Creando razas..."
#   edition[:races].each do |race|
#     Race.find_or_create_by(
#       name: race,
#       edition: new_edition
#     )
#   end
# end

# puts "Creando rarezas de cartas..."

# [
#   'común',
#   'Poco común',
#   'Real',
#   'Ultra real'
# ].each do |rarity|
#   Rarity.find_or_create_by(
#     name: rarity
#   )
# end


#### Read dump json file
# ./dump.json

###########################
# {
#   "code"=>"001",
#   "slug"=>"gaia",
#   "name"=>"Gaia",
#   "rarity"=>"real",
#   "race"=>"olimpico",
#   "type"=>"aliado",
#   "cost"=>"4",
#   "damage"=>"2",
#   "ability"=>
#   "En tu Fase de Vigilia, sólo una vez por turno, puedes buscar un Aliado en tu Mazo Castillo y ponerlo en tu mano. ",
#   "edition_id"=>"20",
#   "edition_slug"=>"helenica",
#   "edition"=>"20",
#   "flavour"=>"Madre de la Creación, no olvides cantar mis penas.",
#   "illustrator"=>"Waldo Retamales",
#   "source_image"=>"https://api.myl.cl/static/cards/20/001.png",
#   "image_path"=>"helenica/20/001.png"
# }
###########################

require 'json'

dump_data = JSON.parse(open('db/dump.json').read)

# Iterating editions
dump_data.each do |edition_cards|
  edition_name = edition_cards.first['edition_slug']
  puts(edition_name)
  # Iterating cards
  edition_cards.each do |card|
    puts("building #{card.name}")
    builder_properties = card_to_builder_props(card)

    
  end
end
