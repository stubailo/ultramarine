class AddVoteValueToChallenge < ActiveRecord::Migration
  def change
    add_column :challenges, :vote_value, :integer
  end
end
