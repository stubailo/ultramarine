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
  d = photo_drawer()
  d.append("<img src=#{data.result.thumb} />")

photo_drawer = ->
  if $("#photo-upload-drawer").length > 0
    return $("#photo-upload-drawer")
  drawer = $("<div></div>")
  drawer.attr("id", "photo-upload-drawer")
  $("#main-navbar").after(drawer)
  return drawer
