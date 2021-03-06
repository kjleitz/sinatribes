class CreateTribes < ActiveRecord::Migration[5.0]
  def change
    create_table :tribes do |t|
      t.string :name
      t.integer :land, default: 1
      t.integer :money, default: 1000
      t.integer :technology, default: 1
      t.timestamp :last_tax_collection
      t.integer :user_id
      t.integer :religion_id
      t.text :war_messages
      t.timestamps
    end
  end
end
