class Challenge < ActiveRecord::Base
  attr_accessible :description, :name, :location_id, :vote_value, :difficulty, :duration, :duration_unit, :lat, :lon, :duration_value

  validates :location_id, :presence => true
  validates :description, :presence => true
  validates :name, :presence => true

  has_many :photos
  has_many :comments

  has_many :challenge_completions
  has_many :completed_users, :class_name => "User", :through => :challenge_completions, :source => :user
  has_and_belongs_to_many :todo_users, :class_name => "User", :join_table => "todo_users_todos", :foreign_key => "todo_id", :association_foreign_key => "todo_user_id"

  belongs_to :user
  belongs_to :location

  has_many :votes

  DifficultyStringMap = {
    1 => "Trivial",
    2 => "Easy",
    3 => "Medium",
    4 => "Hard",
    5 => "Impossible"}

  def difficulty_string
    DifficultyStringMap[difficulty]
  end

  def completed_by? (user)
    ChallengeCompletion.where(user_id: user.id, challenge_id: id).first
  end

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

  def duration_value(duration, duration_unit)
    case duration_unit
    when "seconds"
      return duration
    when "minutes"
      return duration*60
    when "hours"
      return duration*3600
    when "days"
      return duration*3600*24
    else
      return duration
    end
  end

end
