class Photo < ActiveRecord::Base
  attr_accessible :caption, :challenge_id, :privacy_level_id, :user_id, :image

  belongs_to :challenge
  belongs_to :user

  has_attached_file :image, :styles => { :thumb => "240x160#" }
  has_many :comments
  
  def thumb
    image.url(:thumb)
  end

  def as_json(options)
    super(:methods => [:thumb])
  end
  
  has_many :votes
  def vote_value
    votes.reduce(0) { |sum, x| sum + x.value }
  end

  def facebook(photo, user)
    album = Album.where(:user_id => user.id, :location_id => @photo.challenge.location.id) 
    if album
      #fb
    else
      #fb create album get id
      Album.create_album(user.id, photo.challenge.location.id, fbid)
    end
  end
end
