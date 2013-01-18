class Challenge < ActiveRecord::Base
  attr_accessible :description, :name

  has_many :photos
  has_many :comments
end
