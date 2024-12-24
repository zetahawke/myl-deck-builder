class CreateEditions < ActiveRecord::Migration[8.0]
  def change
    create_table :editions do |t|
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
