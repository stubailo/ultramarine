class Challenge < ActiveRecord::Base
  attr_accessible :description, :name, :location_id

  has_many :photos
  has_many :comments

  has_and_belongs_to_many :completed_users, :class_name => "User", :join_table => "completed_users_completeds", :foreign_key => "completed_id", :association_foreign_key => "completed_user_id"
  has_and_belongs_to_many :todo_users, :class_name => "User", :join_table => "todo_users_todos", :foreign_key => "todo_id", :association_foreign_key => "todo_user_id"

  belongs_to :user
  belongs_to :location
end
