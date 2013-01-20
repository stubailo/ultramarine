class Challenge < ActiveRecord::Base
  attr_accessible :description, :name, :location_id

  validates :location_id, :presence => true
  validates :description, :presence => true
  validates :name, :presence => true

  has_many :photos
  has_many :comments

  belongs_to :user
  belongs_to :location
end
