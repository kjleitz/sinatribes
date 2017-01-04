class CreatePopulations < ActiveRecord::Migration[5.0]
  def change
    create_table :populations do |t|
      t.integer :warriors
      t.integer :farmers
      t.integer :priests
      t.integer :tribe_id
    end
  end
end
