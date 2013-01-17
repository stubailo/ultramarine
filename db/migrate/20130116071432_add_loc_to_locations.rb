class AddLocToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :lat, :string
    add_column :locations, :lon, :string
  end
end
