class AddColumnsToCard < ActiveRecord::Migration[8.0]
  def change
    add_column :cards, :code, :string
    add_column :editions, :code, :string
  end
end
