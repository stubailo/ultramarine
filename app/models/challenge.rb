class Challenge < ActiveRecord::Base
  attr_accessible :description, :name, :location_id

  validates :location_id, :presence => true
  validates :description, :presence => true
  validates :name, :presence => true

  has_many :photos
  has_many :comments

  has_and_belongs_to_many :completed_users, :class_name => "User", :join_table => "completed_users_completeds", :foreign_key => "completed_id", :association_foreign_key => "completed_user_id"
  has_and_belongs_to_many :todo_users, :class_name => "User", :join_table => "todo_users_todos", :foreign_key => "todo_id", :association_foreign_key => "todo_user_id"

  belongs_to :user
  belongs_to :location

  has_many :votes
  def vote_value
    votes.reduce(0) { |sum, x| sum + x.value }
  end
end
