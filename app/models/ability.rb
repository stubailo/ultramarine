class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
    
    if not user
      can :read, Vote
      can :read, Challenge
      can :read, Location
      can :read, Photo, :privacy_level => 3
      can :read, Comment
    elsif user.admin?
      can :manage, :all
    else
      can :manage, Photo, :user_id => user.id
      can :manage, User, :id => user.id
      can :create, Photo
      can :read, Photo do |photo|
        photo.privacy_level == 3 or 
          (photo.privacy_level == 2 and user.facebook_friends?(photo.user_id, Koala::Facebook::API.new(user.token)))
      end
      can :read, Challenge
      can :create, Challenge
      can :manage, Challenge, :user_id => user.id

      can :read, Comment
      can :create, Comment
      can :manage, Comment, :user_id => user.id

      can :read, Location
      can :manage, Vote, :user_id => user.id
      cannot :destroy, Challenge

    end
  end
end
