class RenamePhotoPrivacyLevelIdToPrivacyLevel < ActiveRecord::Migration
  def change
    remove_column :photos, :privacy_level_id
    add_column :photos, :privacy_level, :integer
  end
end
