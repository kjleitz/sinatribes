class CreateMessengers < ActiveRecord::Migration[5.0]
  def change
    create_table :messengers do |t|
      t.string :message
      t.boolean :rejected, default: false
      t.integer :tribe_id
      t.integer :destination_id
      t.timestamps
    end
  end
end
