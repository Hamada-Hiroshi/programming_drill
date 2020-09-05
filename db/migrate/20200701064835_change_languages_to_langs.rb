class ChangeLanguagesToLangs < ActiveRecord::Migration[5.2]
  def change
    rename_table :languages, :langs
  end
end
