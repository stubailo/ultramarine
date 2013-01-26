# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $(".response-area").hide()
  $("form.new_comment").submit comment_submit_handler 
  $("span.reply").click comment_reply
  
comment_submit_handler = (event) ->
  $(".response-area").hide()
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
      new_comment.find(".response-area").hide()
      new_comment.find("form.new_comment").submit comment_submit_handler
      form.after new_comment
      new_comment.slideDown()
      new_comment.find("span.reply").click comment_reply
  form.find("textarea").val ""
  return false

comment_reply = (event) ->
  $(this).parent().find("div.response-area").first().show()
  return false
