class CreateGifts < ActiveRecord::Migration[5.0]
  def change
    create_table :gifts do |t|
      t.integer :money, default: 0
      t.integer :warriors, default: 0
      t.boolean :accepted, default: false
      t.integer :messenger_id
    end
  end
end
