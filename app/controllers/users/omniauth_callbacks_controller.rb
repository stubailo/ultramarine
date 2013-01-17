class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    u = User.find_or_create_by_omniauth(request.env["omniauth.auth"])
    
    sign_in_and_redirect u, :event => :authentication
    set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
  end
end