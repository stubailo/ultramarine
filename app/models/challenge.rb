class Challenge < ActiveRecord::Base
  attr_accessible :description, :name, :location_id

  has_many :photos
  has_many :comments

  belongs_to :user
  belongs_to :location
end
