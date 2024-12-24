# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


puts "Creando artistas..."

[
  'Mauricio Herrera'
  #...
].each do |artist|
  Artist.find_or_create_by(
    name: artist
  )
end

puts "Creando tipos de cartas..."

[
  'Tótem',
  'Talismán',
  'Oro Normal',
  'Oro',
  'Aliado',
  'Arma'
].each do |card_type|
  CardType.find_or_create_by(
    name: card_type
  )
end

puts "Creando ediciones..."

[
  {
    name: 'helénica',
    races: [
      'Titán',
      'Olímpico',
      'Héroe'
    ]
  },
  {
    name: 'espada sagrada',
    races: [
      'Caballero',
      'Dragón',
      'Faerie'
    ]
  },
  {
    name: 'Hijos de Daana',
    races: [
      'Sombra',
      'Desafiante',
      'Defensor'
    ]
  },
  {
    name: 'Dominios de Ra',
    races: [
      'Eterno',
      'Sacerdote',
      'Faraón'
    ]
  }
].each do |edition|
  new_edition = Edition.find_or_create_by(
    name: edition[:name]
  )

  puts "Creando razas..."
  edition[:races].each do |race|
    Race.find_or_create_by(
      name: race,
      edition: new_edition
    )
  end
end

puts "Creando rarezas de cartas..."

[
  'común',
  'Poco común',
  'Real',
  'Ultra real'
].each do |rarity|
  Rarity.find_or_create_by(
    name: rarity
  )
end