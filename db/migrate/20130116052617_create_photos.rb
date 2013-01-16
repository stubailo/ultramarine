class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.integer :challenge_id
      t.text :caption
      t.integer :user_id
      t.integer :privacy_level_id

      t.timestamps
    end

    add_attachment :photos, :image
  end
end
