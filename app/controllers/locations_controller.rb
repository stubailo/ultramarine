require 'net/http'

class LocationsController < ApplicationController

  helper_method :sort_column, :sort_direction, :hide_column
  load_and_authorize_resource
  # GET /locations
  # GET /locations.json
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @locations }
    end
  end

  # GET /locations/1
  # GET /locations/1.json
  def show
    @graph = graph
    if sort_column == "duration_value"
      sort_direction == "desc" ? 
        @challenges = @location.challenges.sort_by(&:duration_value).reverse() :
        @challenges = @location.challenges.sort_by(&:duration_value)
    else
      @challenges = @location.challenges.order(sort_column + ' ' + sort_direction)
    end

    if params[:hide] == 'completed'
      @challenges = @challenges - current_user.completed_challenges
    end

    if current_user
      @challenges_completed = Challenge.joins(:challenge_completions).where(:challenge_completions => {:user_id => current_user.id}).where(:location_id => @location.id).order("difficulty DESC")
    end
    #@client = GooglePlaces::Client.new(Ultramarine::Application::PLACES_API_KEY)
    #@venues = @client.spots(@location.lat, @location.lon)

    respond_to do |format|
      format.html show.html.haml
      format.json { render json: @location }
    end
  end

  # GET /locations/new
  # GET /locations/new.json
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @location }
    end
  end

  # GET /locations/1/edit
  def edit
  end

  # POST /locations
  # POST /locations.json
  def create
    respond_to do |format|
      if @location.save
        format.html { redirect_to @location, notice: 'Location was successfully created.' }
        format.json { render json: @location, status: :created, location: @location }
      else
        format.html { render action: "new" }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /locations/1
  # PUT /locations/1.json
  def update
    respond_to do |format|
      if @location.update_attributes(params[:location])
        format.html { redirect_to @location, notice: 'Location was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/1
  # DELETE /locations/1.json
  def destroy
    @location.destroy

    respond_to do |format|
      format.html { redirect_to locations_url }
      format.json { head :no_content }
    end
  end

  private
  def sort_column
    %w[vote_value duration_value difficulty].include?(params[:sort]) ? params[:sort] : "vote_value"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end

  def hide_column
    %w[completed].include?(params[:hide]) ? params[:hide] : nil
  end
end
