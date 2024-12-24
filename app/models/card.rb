class Card < ApplicationRecord
  belongs_to :artist
  belongs_to :card_type
  belongs_to :edition
  belongs_to :rarity
  belongs_to :race
  belongs_to :deck_card
  belongs_to :deck, through: :deck_card
end
