class Photo < ActiveRecord::Base
  attr_accessible :caption, :challenge_id, :privacy_level_id, :user_id, :image

  belongs_to :challenge
  belongs_to :user

  has_attached_file :image, :styles => { :thumb => "200x200>" }
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

  #TODO: need to put photo caption and approve photo checkbox in
  def self.facebook(photo, user)
    album = Album.where(:user_id => user.id, :location_id => photo.challenge.location.id).first 
    @graph = Koala::Facebook::GraphAPI.new(user.token) 
    if album.nil?
      album_info = @graph.put_object('me','albums', :name=>"Trip to #{photo.challenge.location.name}")
      album = Album.create_album(user.id, photo.challenge.location.id, album_info["id"])
    end
    @graph.put_picture(photo.image.path, photo.image.content_type, facebook_arguments = {:message => "sample caption"}, album.fbid)
  end
end
