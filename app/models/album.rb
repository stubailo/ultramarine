class Album < ActiveRecord::Base
  attr_accessible :fbid, :location_id, :name, :user_id

  belongs_to :user
  belongs_to :location

  def self.create_album(user_id, location_id, fbid)
    album = Album.new(:location_id => location_id, :user_id => user_id, :fbid => fbid)
    album.save
    album
  end
end
