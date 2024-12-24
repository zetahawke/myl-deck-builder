json.extract! card, :id, :name, :legend, :artist_id, :card_type_id, :edition_id, :cost, :force, :ability, :rarity_id, :race_id, :created_at, :updated_at
json.url card_url(card, format: :json)
