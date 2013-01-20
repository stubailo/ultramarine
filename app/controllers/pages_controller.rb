class PagesController < ApplicationController
  def index
    if current_user
      @me = graph.get_connections("me", "friends")
    end
  end

  def about
  end
end
