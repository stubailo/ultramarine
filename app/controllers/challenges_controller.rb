class ChallengesController < ApplicationController

  load_and_authorize_resource

  def add_todo
    @challenge.todo_users << current_user
    redirect_to :back
  end

  def add_completed
    @challenge.completed_users << current_user
    redirect_to :back
  end

  def remove_todo
    @challenge.todo_users.delete(current_user)
    redirect_to :back
  end

  def remove_completed
    @challenge.completed_users.delete(current_user)
    redirect_to :back
  end

  # GET /challenges
  # GET /challenges.json
  def index
    @challenges = Challenge.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @challenges }
    end
  end

  # GET /challenges/1
  # GET /challenges/1.json
  def show
    @count = 0

    private_photos = Photo.where(:user_id => current_user.id).where(:challenge_id => @challenge.id)
    @count += private_photos.length
    private_group = { "group" => "Personal Photos", "photos" => private_photos }

    friends = graph.get_connections("me", "friends")
    friend_fbids = []
    friends.each do |friend|
      friend_fbids += [friend["id"].to_i]
    end
    friend_ids = User.where(:fbid => friend_fbids)
    friend_ids = friend_ids.map{|friend| friend.id}
    friend_photos = Photo.where(:user_id => friend_ids).where(:challenge_id => @challenge.id).where(:privacy_level => [2,3])
    @count += friend_photos.length
    friend_group = { "group" => "Friends' Photos", "photos" => friend_photos }

    public_photos = Photo.where(:challenge_id => @challenge.id).where(:privacy_level => 3)
    @count += public_photos.length
    public_group = { "group" => "Public Photos", "photos" => public_photos }


    @photo_groups = [private_group, friend_group, public_group]
    
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
    respond_to do |format|
      if @challenge.save
        @challenge.update_attributes(:vote_value => 0)
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
