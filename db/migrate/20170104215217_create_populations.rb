class CreatePopulations < ActiveRecord::Migration[5.0]
  def change
    create_table :populations do |t|
      t.integer :warriors, default: 0
      t.integer :farmers, default: 10
      t.integer :priests, default: 1
      t.integer :tribe_id
    end
  end
end
