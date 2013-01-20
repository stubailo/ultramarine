class CreateTodoUsersChallengeJoinTable < ActiveRecord::Migration
  def change
    create_table :todo_users_todos, :id => false do |t|
      t.integer :todo_user_id
      t.integer :todo_id
    end
  end
end
