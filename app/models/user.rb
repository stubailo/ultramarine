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

end
