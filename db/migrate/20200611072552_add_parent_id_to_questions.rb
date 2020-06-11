class AddParentIdToQuestions < ActiveRecord::Migration[5.2]
  def change
    add_reference :questions, :parent, foreign_key: { to_table: :questions }
  end
end
