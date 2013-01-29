class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :authentication_keys => [:login]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :token, :fbid, :password_confirmation, :remember_me, :username, :login
  # attr_accessible :title, :body

  has_many :omniauth_associations, :dependent => :destroy
  has_many :facebook_friends, :dependent => :destroy
  has_many :photos, :dependent => :destroy
  has_many :challenges
  has_many :albums, :dependent => :destroy
  has_many :newsfeed_items

  has_and_belongs_to_many :todos, :class_name => "Challenge", :join_table => "todo_users_todos", :foreign_key => "todo_user_id", :association_foreign_key => "todo_id"

  has_many :challenge_completions, :dependent => :destroy
  has_many :completed_challenges, :class_name => "Challenge", :source => :challenge, :through => :challenge_completions
  attr_accessor :login

  def self.find_or_create_by_omniauth(auth)
    oa = OmniauthAssociation.where( {provider: auth.provider, uid: auth.uid} ).first

    if oa
      u = oa.user
    else
      u = User.create(email:auth.info.email, username:auth.info.name, token:auth.credentials.token, fbid:auth.uid.to_s, password:Devise.friendly_token[0,20])
      u.omniauth_associations = [OmniauthAssociation.new( {provider: auth.provider, uid: auth.uid} )]
      u.save
    end

    u
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", {:value => login.downcase}]).first
    else
      where(conditions).first
    end
  end

  def get_fb_friend_ids(user, graph)
    if user.omniauth_associations.any?
      if user.last_loaded.nil? || (Time.now-user.last_loaded).to_i > 600
        user.facebook_friends.destroy_all
        friends = graph.get_connections("me", "friends")
        friend_ids = friends.map{|friend| friend["id"].to_i}
        User.transaction do
          user.facebook_friends.create friend_ids.map { |fbid| {fbid: fbid.to_s, user_id: user.id} }
        end
        user.update_attribute(:last_loaded, Time.now())
        user.save
        return friend_ids
      else
        return user.facebook_friends.map{|friend| friend.fbid}
      end
    else
      return []
    end
  end

  def facebook_friends? (user, friend_id, graph)
    friend_fbids = get_fb_friend_ids(user, graph)
    return friend_fbids.include?(User.find(friend_id).fbid)
  end

  def friend_ids(user, graph)
    friend_fbids = get_fb_friend_ids(user, graph)
    friend_ids = User.where(:fbid => friend_fbids)
    friend_ids = friend_ids.map{|friend| friend.id}
    return friend_ids
  end

  def admin?
    if Rails.env.production?
      return is_admin
    else 
      return is_admin || email == "brodrick.childs@gmail.com"
    end
  end

  def points
    completed_challenges.sum {|c| c.vote_value} * 10
  end

  def voted_for? (object)
    query = Vote.where(:user_id => id, (object.class.to_s.downcase + "_id").to_sym => object.id)
    if query.any?
      return query.first.value
    else
      return 0
    end
  end

end
