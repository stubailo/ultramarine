class AddUserIdToFacebookFriends < ActiveRecord::Migration
  def change
    add_column :facebook_friends, :user_id, :integer
  end
end
