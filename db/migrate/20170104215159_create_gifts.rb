class CreateGifts < ActiveRecord::Migration[5.0]
  def change
    create_table :gifts do |t|
      t.integer :money, default: 0
      t.integer :warriors, default: 0
      t.integer :resource_amount, default: 0
      t.boolean :accepted, default: false
      t.integer :resource_id
      t.integer :messenger_id
    end
  end
end
