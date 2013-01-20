class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :comment_id
      t.integer :photo_id
      t.integer :challenge_id
      t.integer :value
      t.integer :user_id

      t.timestamps
    end
  end
end
