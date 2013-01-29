class PagesController < ApplicationController
  skip_authorization_check
  def index
    if current_user
      redirect_to :action => :user_index
    end
  end

  def user_index
    @friend_ids = current_user.friend_ids(current_user, graph)
    @challenges_todo = current_user.todos
    @friend_completions = ChallengeCompletion.where(:user_id => @friend_ids)
    @friend_challenges = []
    @popular_challenges = Challenge.order("vote_value DESC")
    @popular_challenges = @popular_challenges - @challenges_todo - current_user.completed_challenges
    @friend_completions.each do |completion|
      challenge = Challenge.find(completion.challenge_id)
      if !@challenges_todo.include?(challenge) && !@popular_challenges.include?(challenge)
        @friend_challenges.append({:challenge => challenge, :friend => User.find(completion.user_id)})
      end
    end
  end

  def about
  end
end
