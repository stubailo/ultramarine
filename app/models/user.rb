class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body

  has_many :omniauth_associations

  has_many :photos

  has_many :challenges

  has_and_belongs_to_many :todos, :class_name => "Challenge", :join_table => "todo_users_todos", :foreign_key => "todo_user_id", :association_foreign_key => "todo_id"

  has_and_belongs_to_many :completeds, :class_name => "Challenge", :join_table => "completed_users_completeds", :foreign_key => "completed_user_id", :association_foreign_key => "completed_id"

  def self.find_or_create_by_omniauth(auth)
    oa = OmniauthAssociation.where( {provider: auth.provider, uid: auth.uid} ).first

    if oa
      u = oa.user
    else
      u = User.create(email:auth.info.email, password:Devise.friendly_token[0,20])
      u.omniauth_associations = [OmniauthAssociation.new( {provider: auth.provider, uid: auth.uid} )]
      u.save
    end

    u
  end

  def admin?
    return is_admin
  end

end
