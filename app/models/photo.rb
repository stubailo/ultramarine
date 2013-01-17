class Photo < ActiveRecord::Base
  attr_accessible :caption, :challenge_id, :privacy_level_id, :user_id, :image

  belongs_to :challenge
  belongs_to :user

  has_attached_file :image, :styles => { :thumb => "200x200>" }
  has_many :comments
end
