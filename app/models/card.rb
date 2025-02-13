class Card < ApplicationRecord
  belongs_to :artist
  belongs_to :card_type
  belongs_to :edition
  belongs_to :rarity
  belongs_to :race
  belongs_to :deck_card
  has_many :deck, through: :deck_card

  class << self
    def define_relation_for(type, current_attr_list)
      # case type
      # when "Rarity"
      #   Rarity.find_or_create_by(
      #     attr
      #   )
      # when "Race"
      # when "Illustrator"
      # when "CardType"
      # when "Edition"
      # end

      class_eval(type).send("find_or_create_by", current_attr_list)
    end

    def card_to_builder_props(obj)
      {
        name: obj[:name],
        code: obj[:code],
        legend: obj[:flavour],
        cost: obj[:cost],
        force: obj[:damage],
        ability: obj[:ability],
        rarity: define_relation_for(
          name: obj[:rarity]
        ),
        race: define_relation_for(
          name: obj[:race]
        ),
        artist: define_relation_for(
          name: obj[:illustrator]
        ),
        card_type: define_relation_for(
          name: obj[:type]
        ),
        edition: define_relation_for(
          name: obj[:edition_slug],
          code: obj[:edition_id]
        )
      }
    end
  end

  def source_img_url
    if edition && edition&.code && code
      "https://api.myl.cl/static/cards/#{edition.code}/#{code}.png"
    end
  end

  def img_path
    if edition && edition&.code && code
      "#{edition.name}/#{edition.code}/#{code}.png"
    end
  end
end
