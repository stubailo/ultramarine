class CommentsController < ApplicationController
  def create
    if params[:comment][:challenge_id] != nil
      @challenge = Challenge.find(params[:comment][:challenge_id])
    end
    if params[:comment][:parent_id] != nil
      @parent = Comment.find(params[:comment][:parent_id])
    end
    if params[:comment][:photo_id] != nil
      @photo = Photo.find(params[:comment][:photo_id])
    end
    if @parent
      @comment = @parent.subcomments.create(params[:comment])
      @comment.update_attributes(:user_id => current_user.id, :level => @parent.level + 1)
      redirect_to :back
    elsif @challenge
      @comment = @challenge.comments.create(params[:comment])
      @comment.update_attributes(:user_id => current_user.id, :level => 1)
      redirect_to challenge_path(@challenge) 
    elsif @photo
      @comment = @photo.comments.create(params[:comment])
      @comment.update_attributes(:user_id => current_user.id, :level => 1)
      redirect_to photo_path(@photo)
    end
  end
end
