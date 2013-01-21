# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $("#ajax_photo_form").fileupload({dataType: "json"})
    .bind("fileuploadadd", file_started)
    .bind("fileuploaddone", file_done)

file_started = (e, data) ->
file_done = (e, data) ->
  console.log(data.result)
  d = photo_drawer().find(".container>.row")
  photo_html = "<div class='thumbnail span3'>
      <img src='#{data.result.thumb}'/>
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
          <button type='button' class='btn btn-small'>Delete</button>
        </div>
      </form>
    </div>"
  new_photo_box = $(photo_html);
  new_photo_box.find("form").submit ->
    $.post $(this).attr("action"), $(this).serialize(), ->
      new_photo_box.remove()
    return false
  d.append(new_photo_box)
  

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
