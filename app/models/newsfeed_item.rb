class NewsfeedItem < ActiveRecord::Base
  attr_accessible :related_object_id, :related_object_type, :user_id
end
