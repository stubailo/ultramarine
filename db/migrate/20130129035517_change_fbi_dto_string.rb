class ChangeFbiDtoString < ActiveRecord::Migration
  def up
    remove_column :albums, :fbid
    remove_column :facebook_friends, :fbid
    remove_index :users, :fbid
    remove_column :users, :fbid
    add_column :albums, :fbid, :string
    add_column :facebook_friends, :fbid, :string
    add_column :users, :fbid, :string
    add_index :users, :fbid
  end

  def down
    remove_column :albums, :fbid
    remove_column :facebook_friends, :fbid
    remove_index :users, :fbid
    remove_column :users, :fbid
    add_column :albums, :fbid, :integer
    add_column :facebook_friends, :fbid, :integer
    add_column :users, :fbid, :integer
    add_index :users, :fbid
  end
end
