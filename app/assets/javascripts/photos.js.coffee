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
  $("#ajax_photo_form").hide()
  $("#new_photo_form_container").append progress_area
  data.context = {}

file_all_progress = (e, data) ->
  $("#new_photo_form_container").find(".bar").width(data.loaded/data.total * 100 + "%")

file_done = (e, data) ->
  photo_ids.push data.result.id

file_all_done = (e, data) ->
  window.location = "/photos/edit_many?photo_ids[]=" + photo_ids.join("&photo_ids[]=")

$ ->
  if $("#edit_many_photos").length > 0 
    num_photos = $("#edit_many_photos").length
    $("#edit_many_photos .form-actions").remove()
    $("#edit_many_photos .control-group#privacy").hide()
    $("#edit_many_photos .facebook").each (i, box) =>
      box.checked=true
    $("#edit_many_photos form select").val("3")
    $("#edit_many_photos").append("<div class='form-actions'>
      <button type='submit' id='submit-button' class='btn btn-primary'>Save Changes</button>
      <div id='all-photo'>
        <label>Privacy for these photos..</label>
        <select id='all_photo_privacy' name='photo[privacy_level]'><option value='1'>Private</option>
        <option value='2'>Friends Only</option>
        <option selected='selected' value='3'>Public</option></select>
      </div>
    </div>")
   $("#edit_many_photos #submit-button").click ->
      facebook_progress_bar = $ "<div>
        <h6> Updating Information... </h6>
        <div class='progress progress-striped active'><div class='bar' style='width: 2%'></div>
      </div>"
      num_photos_uploaded = 0
      $("#edit_many_photos #submit-button").hide()
      $("#edit_many_photos #submit-button").after(facebook_progress_bar)
      count = $("#edit_many_photos form").length
      submit = (which) ->
        val = $("#edit_many_photos form")[which]
        val = $ val
        val.find("#photo_privacy_level").val($("#all_photo_privacy").val())
        next = ->
          num_photos_uploaded +=1
          facebook_progress_bar.find(".bar").width(num_photos_uploaded/count * 100 + "%")
          if which < count - 1
            submit(which + 1)
          else
            window.location.replace(document.referrer)
        $.post val.attr("action") + "/confirm.json", val.serialize(), next, "json"
        return false
      submit(0)
      return false
