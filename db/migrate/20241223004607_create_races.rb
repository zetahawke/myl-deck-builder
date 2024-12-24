class CreateRaces < ActiveRecord::Migration[8.0]
  def change
    create_table :races do |t|
      t.string :name
      t.references :ediiton, null: false, foreign_key: true

      t.timestamps
    end
  end
end
