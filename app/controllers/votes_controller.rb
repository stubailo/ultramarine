class VotesController < ApplicationController
  def vote
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
    if not [-1,1].include? val
      redirect_to :back
      return
    end
    user_id = current_user.id

    v = Vote.where(attr => params[attr], :user_id => user_id)
    if v.any?
      v = v.first
      if v.value == val
        v.destroy
      else
        v.value = val
        v.update_attributes(:value => val)
      end
    else
      v.create(:value => val, attr => params[attr], :user_id => user_id, :vote_total => 0)
    end

    redirect_to :back

  end
end
