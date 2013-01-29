class PhotosController < ApplicationController

  load_and_authorize_resource
  # GET /photos
  # GET /photos.json
  def index
    if current_user.nil?
      redirect_to :back, :notice => "You must be logged in to continue"
    elsif !current_user.admin?
      redirect_to :back, :notice => "You are not authorized to view this page"
    else
      @photos = Photo.all
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @photos }
      end
    end
  end

  # GET /photos/1
  # GET /photos/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @photo }
    end
  end

  # GET /photos/new
  # GET /photos/new.json
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @photo }
    end
  end

  # GET /photos/1/edit
  def edit
  end

  def edit_many
    @photos = Photo.find(params[:photo_ids])
  end

  # POST /photos
  # POST /photos.json
  def create
    @photo.user_id = current_user.id
    @photo.vote_value = 0
    @photo.facebook_bit = 0
    @photo.privacy_level = 2

    respond_to do |format|
      if @photo.save
        format.html { redirect_to @photo, notice: 'Photo was successfully created.' }
        format.json { render json: @photo, status: :created, location: @photo }
      else
        format.html { render action: "new" }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /photos/1
  # PUT /photos/1.json
  def update
    respond_to do |format|
      if params[:photo][:facebook_bit] == "1"
        Photo.facebook(@photo, current_user)
      end
      if @photo.update_attributes(:caption => params[:photo][:caption], :privacy_level => params[:photo][:privacy_level])
        format.html { redirect_to @photo, notice: 'Photo was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /photos/1/confirm
  # POST /photos/1/confirm.json
  def confirm
    respond_to do |format|
      if @photo.update_attributes(:caption => params[:photo][:caption], :privacy_level => params[:photo][:privacy_level])
        if params[:photo][:facebook_bit] == "1"
          Photo.facebook(@photo, current_user)
        end
        format.html { redirect_to @photo, notice: 'Photo was successfully updated.' }
        format.json { render json: @photo }
      else
        format.html { render action: "edit" }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /photos/1
  # DELETE /photos/1.json
  def destroy
    challenge = @photo.challenge
    @photo.destroy

    respond_to do |format|
      format.html { redirect_to challenge }
      format.json { head :no_content }
    end
  end
end
