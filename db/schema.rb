# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130127032843) do

  create_table "albums", :force => true do |t|
    t.integer  "user_id"
    t.integer  "location_id"
    t.integer  "fbid"
    t.string   "name"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "albums", ["location_id"], :name => "index_albums_on_location_id"
  add_index "albums", ["user_id"], :name => "index_albums_on_user_id"

  create_table "challenge_completions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "challenge_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "challenges", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "location_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "user_id"
    t.integer  "vote_value"
    t.string   "lat"
    t.string   "lon"
    t.integer  "difficulty"
    t.integer  "duration"
    t.string   "duration_unit"
  end

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "parent_id"
    t.text     "body"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "challenge_id"
    t.integer  "level"
    t.integer  "photo_id"
    t.integer  "vote_value"
  end

  add_index "comments", ["challenge_id"], :name => "index_comments_on_challenge_id"
  add_index "comments", ["parent_id"], :name => "index_comments_on_parent_id"
  add_index "comments", ["photo_id"], :name => "index_comments_on_photo_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "completed_users_completeds", :id => false, :force => true do |t|
    t.integer "completed_user_id"
    t.integer "completed_id"
  end

  create_table "facebook_friends", :force => true do |t|
    t.integer  "fbid"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id"
  end

  create_table "locations", :force => true do |t|
    t.integer  "parent_id"
    t.string   "name"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "lat"
    t.string   "lon"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "description"
  end

  create_table "newsfeed_items", :force => true do |t|
    t.string   "related_object_type"
    t.integer  "user_id"
    t.integer  "related_object_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "omniauth_associations", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "photos", :force => true do |t|
    t.integer  "challenge_id"
    t.text     "caption"
    t.integer  "user_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "privacy_level"
    t.integer  "vote_value"
    t.integer  "facebook_bit"
  end

  create_table "todo_users_todos", :id => false, :force => true do |t|
    t.integer "todo_user_id"
    t.integer "todo_id"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.boolean  "is_admin"
    t.string   "username"
    t.string   "token"
    t.integer  "fbid"
    t.datetime "last_loaded"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["fbid"], :name => "index_users_on_fbid"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "votes", :force => true do |t|
    t.integer  "comment_id"
    t.integer  "photo_id"
    t.integer  "challenge_id"
    t.integer  "value"
    t.integer  "user_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

end
