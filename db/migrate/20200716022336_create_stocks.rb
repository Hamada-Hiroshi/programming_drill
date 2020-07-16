class CreateStocks < ActiveRecord::Migration[5.2]
  def change
    create_table :stocks do |t|
      t.string :user_id, null: false
      t.string :app_id, null: false

      t.timestamps
      t.index [:user_id, :app_id], unique: true
    end
  end
end
