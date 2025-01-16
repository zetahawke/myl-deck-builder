class Card < ApplicationRecord
  belongs_to :artist
  belongs_to :card_type
  belongs_to :edition
  belongs_to :rarity
  belongs_to :race
  has_many :deck_card
  has_many :deck, through: :deck_card

  accepts_nested_attributes_for :artist
  accepts_nested_attributes_for :card_type
  accepts_nested_attributes_for :edition
  accepts_nested_attributes_for :rarity
  accepts_nested_attributes_for :race

  class << self
    def allowed_attributes
      super([
        artist_attributes: Artist.allowed_attributes,
        card_type_attributes: CardType.allowed_attributes,
        edition_attributes: Edition.allowed_attributes,
        rarity_attributes: Rarity.allowed_attributes,
        race_attributes: Race.allowed_attributes
      ])
    end

    def define_relation_for(type, current_attr_list)
      class_eval(type).send("find_or_create_by", current_attr_list)
    end

    def card_to_builder_props(obj)
      edition_id = define_relation_for(
        'Edition',
        name: obj['edition_slug'],
        code: obj['edition_id']
      )&.id
      {
        name: obj['name'],
        code: obj['code'],
        legend: obj['flavour'],
        cost: obj['cost'],
        force: obj['damage'],
        ability: obj['ability'],
        rarity_id: define_relation_for(
          'Rarity',
          name: obj['rarity']
        )&.id,
        race: define_relation_for(
          'Race',
          name: obj['race'],
          edition_id: edition_id
        ),
        artist_id: define_relation_for(
          'Artist',
          name: obj['illustrator']
        )&.id,
        card_type_id: define_relation_for(
          'CardType',
          name: obj['type']
        )&.id,
        edition_id: edition_id
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
