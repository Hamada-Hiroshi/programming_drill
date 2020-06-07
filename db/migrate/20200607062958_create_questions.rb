class CreateQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :questions do |t|
      t.integer :user_id, null: false
      t.integer :app_id, null: false
      t.text :content, null: false

      t.timestamps
    end
  end
end
