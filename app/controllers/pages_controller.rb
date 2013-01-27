class PagesController < ApplicationController
  skip_authorization_check
  def index
    @updated = (Time.now-current_user.last_loaded).to_i
    @locations = Location
  end

  def about
  end
end
