class Vote < ActiveRecord::Base
  attr_accessible :challenge_id, :comment_id, :photo_id, :user_id, :value

  belongs_to :challenge
  belongs_to :comment
  belongs_to :photo
  belongs_to :user
end
