class CreateTribeResources < ActiveRecord::Migration[5.0]
  def change
    create_table :tribe_resources do |t|
      t.integer :tribe_id
      t.integer :resource_id
    end
  end
end
