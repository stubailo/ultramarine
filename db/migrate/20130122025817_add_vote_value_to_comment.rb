class AddVoteValueToComment < ActiveRecord::Migration
  def change
    add_column :comments, :vote_value, :integer
  end
end
