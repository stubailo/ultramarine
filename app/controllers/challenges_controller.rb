class ChallengesController < ApplicationController

  load_and_authorize_resource
  skip_authorize_resource :only => [:add_todo, :add_completed, :remove_todo, :remove_completed]
  skip_authorization_check :only => [:add_todo, :add_completed, :remove_todo, :remove_completed]

  def add_todo
    @challenge.todo_users << current_user
    redirect_to :back
  end

  def add_completed
    ChallengeCompletion.create(user_id: current_user.id, challenge_id: @challenge.id)
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
    @ordered_photos = []

    public_photos = Photo.where(:challenge_id => @challenge.id).where(:privacy_level => 3)
    @count += public_photos.length
    unless current_user
      @ordered_photos += public_photos
      public_photos.each do |photo|
        @photos_to_photo_types[photo.id] = "public"
      end
    end

    if current_user
      private_photos = Photo.where(:user_id => current_user.id).where(:challenge_id => @challenge.id)
      @count += private_photos.length
      @ordered_photos += private_photos
      private_photos.each do |photo|
        @photos_to_photo_types[photo.id] = "private"
      end

      friends = graph.get_connections("me", "friends")
      friend_fbids = []
      friends.each do |friend|
        friend_fbids += [friend["id"].to_i]
      end
      friend_ids = User.where(:fbid => friend_fbids)
      friend_ids = friend_ids.map{|friend| friend.id}
      friend_photos = Photo.where(:user_id => friend_ids).where(:challenge_id => @challenge.id).where(:privacy_level => [2,3])
      @count += friend_photos.length
      @ordered_photos += friend_photos
      friend_photos.each do |photo|
        @photos_to_photo_types[photo.id] = "friend"
      end

      public_photos = public_photos - friend_photos - private_photos
      @ordered_photos += public_photos
      public_photos.each do |photo|
        @photos_to_photo_types[photo.id] = "public"
      end
    end
    @ordered_photos = @ordered_photos.sort_by{|photo| photo[:vote_value]}.reverse
    
    puts @photos_to_photo_types
    
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
