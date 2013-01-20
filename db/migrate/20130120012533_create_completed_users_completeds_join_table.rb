class CreateCompletedUsersCompletedsJoinTable < ActiveRecord::Migration
  def change
    create_table :completed_users_completeds, :id => false do |t|
      t.integer :completed_user_id
      t.integer :completed_id
    end
  end
end
