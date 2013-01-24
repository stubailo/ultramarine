class PagesController < ApplicationController
  skip_authorization_check
  def index
    @locations = Location
  end

  def about
  end
end
