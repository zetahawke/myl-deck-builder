class Deck < ApplicationRecord
  belongs_to :user
  belongs_to :deck_card
  has_many :card, through: :deck_card
end
