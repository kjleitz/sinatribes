class CreateTribeBuildings < ActiveRecord::Migration[5.0]
  def change
    create_table :tribe_buildings do |t|
      t.integer :tribe_id
      t.integer :building_id
    end
  end
end
