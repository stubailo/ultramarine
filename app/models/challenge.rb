class Challenge < ActiveRecord::Base
  attr_accessible :description, :name, :location_id, :vote_value, :difficulty, :duration, :duration_unit, :lat, :lon, :duration_value

  validates :location_id, :presence => true
  validates :description, :presence => true
  validates :name, :presence => true

  has_many :photos, :dependent => :destroy
  has_many :comments, :dependent => :destroy

  has_many :challenge_completions, :dependent => :destroy
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

  def duration_string
    if duration == 1
      return "#{duration} #{duration_unit.singularize}"
    else
      return "#{duration} #{duration_unit}"
    end
  end

  def completed_by? (user)
    ChallengeCompletion.where(user_id: user.id, challenge_id: id).first
  end

  #Need to call with graph, user, and challenge objects
  def photos
    return nil
  end

  def photos(friend_ids = nil, user=nil)
    if friend_ids and user
      @all_photos = Photo.where("(challenge_id = ? and privacy_level = ?) or (user_id = ? and challenge_id = ?) or (user_id in (?) and challenge_id = ? and privacy_level in (?))", self[:id], 3, user.id, self[:id], friend_ids, self[:id], [2,3])
    else
      @all_photos = Photo.where(:challenge_id => id).where(:privacy_level => 3)
    end
    return @all_photos.order("vote_value DESC")
  end

  def duration_value
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
