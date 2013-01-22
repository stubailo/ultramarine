class AddVoteValueToPhoto < ActiveRecord::Migration
  def change
    add_column :photos, :vote_value, :integer
  end
end
