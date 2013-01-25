class AddColumnsToChallenge < ActiveRecord::Migration
  def change
    add_column :challenges, :lat, :string
    add_column :challenges, :lon, :string
    add_column :challenges, :difficulty, :integer
    add_column :challenges, :duration, :integer
  end
end
