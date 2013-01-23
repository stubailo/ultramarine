class Challenge < ActiveRecord::Base
  attr_accessible :description, :name, :location_id, :vote_value 

  validates :location_id, :presence => true
  validates :description, :presence => true
  validates :name, :presence => true

  has_many :photos
  has_many :comments

  has_and_belongs_to_many :completed_users, :class_name => "User", :join_table => "completed_users_completeds", :foreign_key => "completed_id", :association_foreign_key => "completed_user_id"
  has_and_belongs_to_many :todo_users, :class_name => "User", :join_table => "todo_users_todos", :foreign_key => "todo_id", :association_foreign_key => "todo_user_id"

  belongs_to :user
  belongs_to :location

  has_many :votes

  #Need to call with graph, user, and challenge objects
  def photos
    return nil
  end

  def photos(graph, user, challenge)
    public_photos = Photo.where(:challenge_id => challenge.id).where(:privacy_level => 3)
    photos = public_photos
    if user
      friends = graph.get_connections("me", "friends")
      friend_fbids = []
      friends.each do |friend| 
        friend_fbids += [friend["id"].to_i]
      end
      friend_ids = User.where(:fbid => friend_fbids)
      friend_ids = friend_ids.map{|friend| friend.id}

      private_photos = Photo.where(:user_id => user.id).where(:challenge_id => challenge.id).where(:privacy_level => [1, 2])
      friend_photos = Photo.where(:user_id => friend_ids).where(:challenge_id => challenge.id).where(:privacy_level => 2)
      photos = private_photos + friend_photos + public_photos
    end
    return photos
  end

end
