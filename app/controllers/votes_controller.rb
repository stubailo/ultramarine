class VotesController < ApplicationController
  skip_authorization_check
  def vote
    if current_user
      attr = :none
      if params[:comment_id]
        attr = :comment_id
      elsif params[:challenge_id]
        attr = :challenge_id
      elsif params[:photo_id]
        attr = :photo_id
      else
        redirect_to :back
        return
      end
      val = params[:value].to_i
      update_val = 0
      if not [-1,1].include? val
        redirect_to :back
        return
      end
      user_id = current_user.id

      v = Vote.where(attr => params[attr], :user_id => user_id)
      if v.any?
        if v.first.user_id != current_user.id
          redirect_to :back
        end
        v = v.first
        if v.value == val
          update_val = 0-val
          v.destroy
        else
          update_val = 2*val
          v.value = val
          v.update_attributes(:value => val)
        end
      else
        v = v.create(:value => val, attr => params[attr], :user_id => user_id)
        update_val = val
      end
      if params[:comment_id]
        v.comment.update_attributes(:vote_value => v.comment.vote_value+update_val)
      elsif params[:challenge_id]
        v.challenge.update_attributes(:vote_value => v.challenge.vote_value+update_val)
      elsif params[:photo_id]
        v.photo.update_attributes(:vote_value => v.photo.vote_value+update_val)
      end

      redirect_to :back
    else
      redirect_to :back
    end

  end
end
