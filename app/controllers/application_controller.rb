class ApplicationController < ActionController::Base
  protect_from_forgery

  def graph 
    @graph ||= Koala::Facebook::API.new(current_user.token)
  end
end
