class UsersController < ApplicationController
  skip_authorization_check

  def show
    @user = User.find(params[:id])
    @is_me = @user == current_user
    @newsfeed = @user.newsfeed_items.order("created_at DESC")
    
    @is_friends = current_user.facebook_friends? @user.id, graph
    
    if @is_friends or @is_me
      @photos = Photo.where(user_id: @user.id, privacy_level: [2,3])
    else
      @photos = Photo.where(user_id: @user.id, privacy_level: 3)
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

    @completed_challenges = Challenge.joins(:challenge_completions).where(:challenge_completions => {:user_id => @user.id}).order("challenge_completions.created_at DESC")
  end

  def new
    @user = User.new
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
