class AddFbidToUser < ActiveRecord::Migration
  def change
    add_column :users, :fbid, :int
    add_index :users, :fbid
  end
end
