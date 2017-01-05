class CreateResources < ActiveRecord::Migration[5.0]
  def change
    create_table :resources do |t|
      t.string :name
      t.integer :tribe_id
      t.integer :gift_id
    end
  end
end
