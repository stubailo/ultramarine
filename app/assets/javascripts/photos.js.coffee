# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $("#ajax_photo_form").fileupload({dataType: "json"})
    .bind("fileuploadstart", file_all_started)
    .bind("fileuploadprogressall", file_all_progress)
    .bind("fileuploadstop", file_all_done)
    .bind("fileuploaddone", file_done)

photo_ids = []

file_all_started = (e, data) ->
  progress_area = $ "<div>
      <h6>Uploading files...</h6>
      <div class='progress progress-striped active'><div class='bar' style='width: 0'></div>
    </div>"
  $("#ajax_photo_form").hide();
  $("#new_photo_form_container").append progress_area
  data.context = {}

file_all_progress = (e, data) ->
  $("#new_photo_form_container").find(".bar").width(data.loaded/data.total * 100 + "%")

file_done = (e, data) ->
  photo_ids.push data.result.id

file_all_done = (e, data) ->
  window.location = "/photos/edit_many?photo_ids[]=" + photo_ids.join("&photo_ids[]=")

