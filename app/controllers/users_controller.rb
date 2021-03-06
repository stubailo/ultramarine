class UsersController < ApplicationController
  skip_authorization_check

  def show
    @user = User.find(params[:id])
    @graph = graph
    @fb_friend_ids = get_fb_friend_ids
    @is_me = @user == current_user
    @newsfeed = @user.newsfeed_items.order("created_at DESC").limit(100)
    
    @is_friends = current_user ? current_user.facebook_friends?(current_user, @user.id, graph) : nil
    
    if @is_friends or @is_me
      @photos = Photo.where(user_id: @user.id, privacy_level: [2,3]).order("vote_value DESC")
    else
      @photos = Photo.where(user_id: @user.id, privacy_level: 3).order("vote_value DESC")
    end

    @newsfeed.select! do |item|
      if item.related_object_type == "Photo"
        p = Photo.find(item.related_object_id)
        if p.privacy_level == 1
          next
        elsif p.privacy_level == 2
          unless @is_friends or @is_me
            next
          end
        end
      elsif item.related_object_type == "Comment"
        c = Comment.find(item.related_object_id)
        base_comment = c
        while base_comment.parent_id
          base_comment = c.parent
        end
        if base_comment.photo_id
          p = Photo.find(base_comment.photo_id)
          if p.privacy_level == 1
            next
          elsif p.privacy_level == 2
            unless @is_friends or @is_me
              next
            end
          end
        end
      end
      true
    end

    @newsfeed = @newsfeed[0...15]

    @completed_challenges = Challenge.joins(:challenge_completions).where(:challenge_completions => {:user_id => @user.id}).order("challenge_completions.created_at DESC")
  end

  def new
    @user = User.new
  end

  def friends
    if current_user && current_user.omniauth_associations.any?
      @user = current_user
      @friends = User.where(:id => @user.friend_ids(current_user, graph))
      @friends = @friends.map{|friend| {:picture => graph.get_picture(friend.fbid), :friend => friend}}
    else
      redirect_to root_path, flash[:notice] = "You must be connected through facebook to view friends"
    end
  end
  
  def edit
    @user = current_user
  end
  
  def edit_password
    @user = current_user
  end
  
  def update
    @user = current_user
    
    respond_to do |format|
      if params[:old_password]
        if @user.valid_password?(params[:old_password]) && @user.update_attributes(params[:user])
          format.html { redirect_to(user_path(@user), :notice => 'Credentials updated successfully.') }
          format.json { render :json => {}, :status => :ok }
        else
          flash[:fail] = "Old password entered incorrectly, please try again"
          format.html  { render :action => "edit_password" }
          format.json  { render :json => @user.errors, :status => :unprocessable_entity }
        end
      else
        if @user.update_attributes(params[:user])
          format.html { redirect_to(user_path(@user), :notice => 'Credentials updated successfully.') }
          format.json { render :json => {}, :status => :ok }
        else
          format.html  { render :action => "edit" }
          format.json  { render :json => @post.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

end
