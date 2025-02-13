class Deck < ApplicationRecord
  belongs_to :user
  has_many :deck_card
  has_many :card, through: :deck_card
end
