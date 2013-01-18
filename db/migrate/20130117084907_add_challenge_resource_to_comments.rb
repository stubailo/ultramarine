class AddChallengeResourceToComments < ActiveRecord::Migration
  def change
    add_column :comments, :challenge_id, :integer
    add_index :comments, :challenge_id
  end
end
