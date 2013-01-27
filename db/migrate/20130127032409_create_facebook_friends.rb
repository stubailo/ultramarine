class CreateFacebookFriends < ActiveRecord::Migration
  def change
    create_table :facebook_friends do |t|
      t.integer :fbid

      t.timestamps
    end
  end
end
