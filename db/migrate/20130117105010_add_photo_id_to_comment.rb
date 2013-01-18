class AddPhotoIdToComment < ActiveRecord::Migration
  def up
    remove_index :comments, :picture_id
    remove_column :comments, :picture_id
    add_column :comments, :photo_id, :integer
    add_index :comments, :photo_id
  end

  def down
    remove_index :comments, :photo_id
    remove_column :comments, :photo_id
    add_column :comments, :picture_id, :integer
    add_index :comments, :picture_id
  end
end
