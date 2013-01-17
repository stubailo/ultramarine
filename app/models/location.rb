class Location < ActiveRecord::Base
  attr_accessible :name, :parent_id, :lat, :lon
end
