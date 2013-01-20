class VotesController < ApplicationController
  def vote
    if [params[:challenge_id], params[:comment_id], params[:photo_id]].count{|p| p} != 1
      redirect_to :back
    else
      
      if params[:value] > 0
        params[:value] = 1
      elsif params[:value] < 0
        params[:value] = -1
      end

      params[:user_id] = current_user.id

      if params[:challenge_id]
        v = Vote.where(:challenge_id => params[:challenge_id], :user_id => current_user.id)
        if v.any?
          v.first.destroy
        else
          Vote.create(params)
        end
      elsif params[:comment_id]
        v = Vote.where(:comment_id => params[:comment_id], :user_id => current_user.id)
        if v.any?
          v.first.destroy
        else
          Vote.create(params)
        end
      elsif params[:photo_id]
        v = Vote.where(:photo_id => params[:photo_id], :user_id => current_user.id)
        if v.any?
          v.first.destroy
        else
          Vote.create(params)
        end
      else
        # what the fuck this isn't possible
      end
      
      redirect_to :back
    end
  end
end
