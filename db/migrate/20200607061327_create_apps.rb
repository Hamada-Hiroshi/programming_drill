class CreateApps < ActiveRecord::Migration[5.2]
  def change
    create_table :apps do |t|
      t.integer :user_id, null: false
      t.integer :language_id, null: false
      t.string :title, null: false
      t.text :overview, null: false
      t.text :app_url, null: false
      t.text :repo_url, null: false
      t.text :function, null: false
      t.text :target, null: false
      t.text :hint
      t.text :explanation
      t.boolean :status, null: false, default: true

      t.timestamps
    end
  end
end
