class CreateBuildings < ActiveRecord::Migration[5.0]
  def change
    create_table :buildings do |t|
      t.string :name
      t.integer :price
      t.integer :resource_amount
      t.string :resource_name
    end
  end
end
