class ChallengeCompletion < ActiveRecord::Base
  attr_accessible :challenge_id, :user_id

  belongs_to :challenge
  belongs_to :user
end
