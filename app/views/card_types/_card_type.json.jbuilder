json.extract! card_type, :id, :name, :description, :created_at, :updated_at
json.url card_type_url(card_type, format: :json)
