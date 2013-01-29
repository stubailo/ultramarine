class ChallengesController < ApplicationController

  load_and_authorize_resource
  skip_authorize_resource :only => [:add_todo, :add_completed, :remove_todo, :remove_completed]
  skip_authorization_check :only => [:add_todo, :add_completed, :remove_todo, :remove_completed]

  def add_todo
    unless @challenge.todo_users.include? current_user
      @challenge.todo_users << current_user
    end
    redirect_to :back
  end

  def add_completed
    unless @challenge.completed_by? current_user
      ChallengeCompletion.create(user_id: current_user.id, challenge_id: @challenge.id)
      @challenge.todo_users.delete(current_user)
    end
    redirect_to :back
  end

  def remove_todo
    @challenge.todo_users.delete(current_user)
    redirect_to :back
  end

  def remove_completed
    ChallengeCompletion.where(user_id: current_user.id, challenge_id: @challenge.id).first.destroy
    redirect_to :back
  end

  # GET /challenges
  # GET /challenges.json
  def index
    if current_user.nil?
      redirect_to :back, :notice => "You must be logged in to continue"
    elsif !current_user.admin?
      redirect_to :back, :notice => "You are not authorized to view this page"
    else
      @challenges = Challenge.all
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @challenges }
      end
    end
  end

  # GET /challenges/1
  # GET /challenges/1.json
  def show
    @count = 0
    @photos_to_photo_types = Hash.new

    photos = @challenge.photos(get_fb_friend_ids, current_user)
    @count = photos.size()
    @ordered_photos = photos.sort_by{|photo| photo[:vote_value]}.reverse
    if current_user
      friend_ids = current_user.friend_ids(current_user, graph)
      @ordered_photos.each do |photo|
        if photo.user_id == current_user.id
          c="private"
        elsif photo.privacy_level > 1 and friend_ids.include? photo.user_id
          c="friends"
        else
          c="public"
        end
        
        @photos_to_photo_types[photo.id] = c
      end
    else
      @ordered_photos.each do |photo|
        @photos_to_photo_types[photo.id] = "public"
      end
    end
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @challenge }
    end
  end

  # GET /challenges/new
  # GET /challenges/new.json
  def new
    @challenge.location_id = params[:location_id]
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @challenge }
    end
  end

  # GET /challenges/1/edit
  def edit
  end

  # POST /challenges
  # POST /challenges.json
  def create
    @challenge.user_id = current_user.id
    @challenge.vote_value = 0
    respond_to do |format|
      if @challenge.save
        format.html { redirect_to @challenge, notice: 'Challenge was successfully created.' }
        format.json { render json: @challenge, status: :created, location: @challenge }
      else
        format.html { render action: "new" }
        format.json { render json: @challenge.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /challenges/1
  # PUT /challenges/1.json
  def update
    respond_to do |format|
      if @challenge.update_attributes(params[:challenge])
        format.html { redirect_to @challenge, notice: 'Challenge was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @challenge.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /challenges/1
  # DELETE /challenges/1.json
  def destroy
    @challenge.destroy
    respond_to do |format|
      format.html { redirect_to challenges_url }
      format.json { head :no_content }
    end
  end
end
