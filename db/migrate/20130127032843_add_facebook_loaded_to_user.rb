class AddFacebookLoadedToUser < ActiveRecord::Migration
  def change
    add_column :users, :last_loaded, :datetime
  end
end
