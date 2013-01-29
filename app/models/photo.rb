class Photo < ActiveRecord::Base
  attr_accessible :caption, :challenge_id, :privacy_level, :user_id, :image, :vote_value, :facebook_bit

  belongs_to :challenge
  belongs_to :user

  has_attached_file :image, :styles => { :tiny => "64x64#", :thumb => "200x200#", :small => "300x300>", :big => "1170x882>"}
  has_many :comments

  validates_attachment_content_type :image, :content_type=>['image/jpeg', 'image/png']
  
  def thumb
    image.url(:thumb)
  end

  def as_json(options)
    super(:methods => [:thumb])
  end
  
  has_many :votes

  def self.facebook(photo, user)
    @graph = Koala::Facebook::API.new(user.token)
    album = Album.where(:user_id => user.id, :location_id => photo.challenge.location.id).first 
    if album.nil?
      album_info = @graph.put_object('me','albums', :name=>"Trip to #{photo.challenge.location.name}")
      album = Album.create_album(user.id, photo.challenge.location.id, album_info["id"])
    end
    if @graph.put_picture(photo.image.url(:big), photo.image.content_type, facebook_arguments = {:message => photo.caption}, album.fbid)
      photo.update_attributes(:facebook_bit => 1)
    end
  end
end
