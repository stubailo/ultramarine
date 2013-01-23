# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# make tabs

$ ->
  if $("body.challenges.show").length > 0
    $("#photos-hash").before( "<ul class='nav nav-tabs nav-hash'>
      <li id='photos-tab'><a href='#photos'><i class='icon-picture' /> Photos</a></li>
      <li id='comments-tab'><a href='#comments'><i class='icon-comment' /> Comments</a></li>
      </ul>")

    if window.location.hash == ""
      window.location.hash = "#photos"

    hash_changed()
