class PagesController < ApplicationController
  skip_authorization_check
  def index
    @locations = Location.all.sort_by{|l| l.challenges.count}.reverse
    if current_user
      redirect_to :action => :user_index
    end
  end

  def user_index
    if current_user
      @fb_friend_ids = get_fb_friend_ids
      @challenges_todo = current_user.todos
      @friend_completions = ChallengeCompletion.where(:user_id => @friend_ids)
      @friend_challenges = []
      @friend_completions.each do |completion|
        challenge = Challenge.find(completion.challenge_id)
        if !@challenges_todo.include?(challenge)
          @friend_challenges.append({:challenge => challenge, :friend => User.find(completion.user_id)})
        end
      end
      @popular_challenges = Challenge.order("vote_value DESC")
      @popular_challenges = @popular_challenges - @friend_completions - @challenges_todo - current_user.completed_challenges
      

      @newsfeed = NewsfeedItem.joins(:user).where("newsfeed_items.user_id" => @friend_ids).order("newsfeed_items.created_at DESC").limit(100)
      
      @newsfeed.select! do |item|
        if item.related_object_type == "Photo"
          p = Photo.find(item.related_object_id)
          if p.privacy_level == 1
            next
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
            end
          end
        end
        true
      end

      @newsfeed = @newsfeed[0...15]

    else
      redirect_to root_path
    end
  end

  def about
  end
end
