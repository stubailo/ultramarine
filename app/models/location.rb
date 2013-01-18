class Location < ActiveRecord::Base
  attr_accessible :name, :parent_id, :lat, :lon, :image

  has_attached_file :image
end
