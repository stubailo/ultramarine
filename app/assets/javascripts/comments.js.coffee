# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $("form.new_comment").submit comment_submit_handler 
  
comment_submit_handler = (event) ->
  form = $(this)
  $.ajax
    url: form.attr("action")
    data: form.serialize()
    dataType: "script"
    type: "POST"
    complete: (data) ->
      new_comment = $("<div></div>")
      new_comment.append(data.responseText)
      new_comment.hide()
      new_comment.find("form.new_comment").submit comment_submit_handler
      form.after new_comment
      new_comment.slideDown()
  form.find("textarea").val ""
  return false
