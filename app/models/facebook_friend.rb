class FacebookFriend < ActiveRecord::Base
  attr_accessible :fbid, :user_id
  belongs_to :users
end
