class CreateTribes < ActiveRecord::Migration[5.0]
  def change
    create_table :tribes do |t|
      t.string :name
      t.integer :land
      t.integer :money
      t.integer :technology
      t.integer :user_id
      t.integer :religion_id
    end
  end
end
