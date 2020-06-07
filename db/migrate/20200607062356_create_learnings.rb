class CreateLearnings < ActiveRecord::Migration[5.2]
  def change
    create_table :learnings do |t|
      t.integer :user_id, null: false
      t.integer :app_id, null: false
      t.integer :status, null: false, default: 0
      t.text :memo

      t.timestamps
    end
  end
end
