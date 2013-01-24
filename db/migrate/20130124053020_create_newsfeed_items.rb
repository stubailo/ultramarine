class CreateNewsfeedItems < ActiveRecord::Migration
  def change
    create_table :newsfeed_items do |t|
      t.string :related_object_type
      t.integer :user_id
      t.integer :related_object_id

      t.timestamps
    end
  end
end
