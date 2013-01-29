class NewsfeedObserver < ActiveRecord::Observer
  
  observe :photo, :comment, :challenge
  
  def after_create(object)
    NewsfeedItem.create({user_id: object.user_id, related_object_id: object.id, related_object_type: object.class.to_s})
  end

  def after_destroy(object)
    NewsfeedItem.where({user_id: object.user_id, related_object_id: object.id, related_object_type: object.class.to_s}).first.destroy
  end
end
