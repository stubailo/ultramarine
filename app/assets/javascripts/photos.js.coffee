# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $("#ajax_photo_form").fileupload({dataType: "json"})
    .bind("fileuploadadd", file_started)
    .bind("fileuploaddone", file_done)
    .bind("fileuploadprogress", file_progress)

file_started = (e, data) ->
  data.context = $("<div class='span3'><div class='thumbnail'>
      <div class='upload_progress'>
        <div class='progress progress-striped active'>
          <div class='bar' style='width: 0;'></div>
        </div>
      </div>
    </div></div>");
  d = photo_drawer().find(".container>.row")
  d.append(data.context)

file_progress = (e, data) ->
  progress_percent = data.loaded / data.total * 100
  data.context.find(".bar").width(progress_percent + "%");

file_done = (e, data) ->
  data.context.find(".thumbnail").html("<img src='#{data.result.thumb}'/>
    <hr />
    <form action='/photos/#{data.result.id}/confirm'>
      <input type='text' placeholder='Caption' name='photo[caption]' />
      <div class='input-append'>
        <select name='photo[privacy_level]' class='span2'>
          <option value=3>Public</option>
          <option value=2>Friends only</option>
          <option value=1>Private</option>
        </select>
        <button class='btn' type='button'>?</button>
      </div>
      <label class='checkbox'>
        <input type='checkbox' name='post_to_facebook' />
        Publish to Facebook
      </label> 
      <div class='btn-group'>
        <input type='submit' class='btn btn-primary btn-small' value='Save' />
        <a class='btn btn-small delete-button' href='/photos/#{data.result.id}'>Delete</a>
      </div>
    </form>")
  data.context.find("form").submit ->
    $.post $(this).attr("action"), $(this).serialize(), ->
      data.context.remove()
      if photo_drawer().find(".thumbnail").length == 0
        photo_drawer().remove()
    return false
  data.context.find(".delete-button").click (e) ->
    e.preventDefault()
    $.ajax
      url: $(this).attr("href")
      type: "delete"
    data.context.remove()
    if photo_drawer().find(".thumbnail").length == 0
      photo_drawer().remove()
    return false
 
photo_drawer = ->
  if $("#photo-upload-drawer").length > 0
    return $("#photo-upload-drawer")
  photo_drawer_html = "<div id='photo-upload-drawer'>
      <div class='container'>
      <h6>Enter some more information to finish adding photos:</h6>
      <div class='row'></div></div> 
    </div>"
  drawer = $(photo_drawer_html)
  $("#main-navbar").after(drawer)
  return drawer
