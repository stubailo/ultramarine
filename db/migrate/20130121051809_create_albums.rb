class CreateAlbums < ActiveRecord::Migration
  def change
    create_table :albums do |t|
      t.integer :user_id
      t.integer :location_id
      t.column :fbid, :bigint
      t.string :name

      t.timestamps
    end
    add_index :albums, :location_id
    add_index :albums, :user_id
  end
end
