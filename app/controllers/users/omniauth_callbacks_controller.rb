class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_authorization_check
  def facebook
    u = User.find_or_create_by_omniauth(request.env["omniauth.auth"])
    u.update_attributes(:token => request.env["omniauth.auth"].credentials.token)
    session["devise.facebook_data"] = request.env["omniauth.auth"]
    
    sign_in_and_redirect u, :event => :authentication
    set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
  end
end
