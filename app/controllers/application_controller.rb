class ApplicationController < ActionController::Base
  protect_from_forgery
  check_authorization :unless => :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  def graph 
    if current_user
      @graph ||= Koala::Facebook::API.new(current_user.token)
    end
  end
end
