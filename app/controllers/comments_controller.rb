class CommentsController < ApplicationController
  load_and_authorize_resource

  def create
    comment = Comment.new(params[:comment])

    comment.user_id = current_user.id
    if comment.parent_id
      comment.level = Comment.find(comment.parent_id).level + 1
    else
      comment.level = 1
    end
    comment.vote_value = 0

    authorize! :create, comment
    comment.save
    
    respond_to do |format|
      format.html { redirect_to :back }
      format.js { render :partial => "comment", :locals => {:comment => comment}, :layout => false }
    end
  end

  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end
end
