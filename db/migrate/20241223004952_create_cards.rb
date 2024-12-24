class CreateCards < ActiveRecord::Migration[8.0]
  def change
    create_table :cards do |t|
      t.string :name
      t.string :legend
      t.references :artist, null: false, foreign_key: true
      t.references :card_type, null: false, foreign_key: true
      t.references :edition, null: false, foreign_key: true
      t.integer :cost
      t.integer :force
      t.string :ability
      t.references :rarity, null: false, foreign_key: true
      t.references :race, null: false, foreign_key: true

      t.timestamps
    end
  end
end
