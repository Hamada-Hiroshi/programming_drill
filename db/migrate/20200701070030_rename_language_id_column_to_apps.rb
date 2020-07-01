class RenameLanguageIdColumnToApps < ActiveRecord::Migration[5.2]
  def change
    rename_column :apps, :language_id, :lang_id
  end
end
