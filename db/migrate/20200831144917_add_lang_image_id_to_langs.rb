class AddLangImageIdToLangs < ActiveRecord::Migration[5.2]
  def change
    add_column :langs, :lang_image_id, :string
  end
end
