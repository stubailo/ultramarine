class AddVoteTotalToVote < ActiveRecord::Migration
  def change
    add_column :votes, :vote_total, :integer
  end
end
