class CommentsController < ApplicationController

  def create
    if params[:comment][:challenge_id]
      @challenge = Challenge.find(params[:comment][:challenge_id])
      @comment = @challenge.comments.create(params[:comment])
      @comment.update_attributes(:user_id => current_user.id, :level => 1, :vote_value => 0) 
    elsif params[:comment][:parent_id]
      @parent = Comment.find(params[:comment][:parent_id])
      @comment = @parent.subcomments.create(params[:comment])
      @comment.update_attributes(:user_id => current_user.id, :level => @parent.level + 1, :vote_value => 0)
    elsif params[:comment][:photo_id]
      @photo = Photo.find(params[:comment][:photo_id])
      @comment = @photo.comments.create(params[:comment])
      @comment.update_attributes(:user_id => current_user.id, :level => 1, :vote_value => 0)
    end

    respond_to do |format|
      format.html { redirect_to :back }
      format.js { render :partial => "comment", :locals => {:comment => @comment}, :layout => false }
    end
  end
end
