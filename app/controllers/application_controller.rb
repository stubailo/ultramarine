class ApplicationController < ActionController::Base
  protect_from_forgery
  check_authorization :unless => :devise_controller?
  after_filter :store_location

  def after_sign_in_path_for(resource)
    session[:return_to] || root_path
  end

  def after_sign_out_path_for(resource)
    root_path
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  def graph 
    if current_user
      @graph ||= Koala::Facebook::API.new(current_user.token)
    end
  end

  def store_location
    session[:return_to] = request.fullpath unless request.fullpath =~ /\/users/
  end

end
