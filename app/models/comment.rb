class Comment < ActiveRecord::Base
  attr_accessible :user_id, :photo_id, :parent_id, :body, :challenge_id, :level, :vote_value

  belongs_to :user
  belongs_to :photo
  belongs_to :parent, :class_name => "Comment", :foreign_key => "parent_id"
  has_many :subcomments, :class_name => "Comment", :foreign_key => "parent_id"
  has_many :votes

end
