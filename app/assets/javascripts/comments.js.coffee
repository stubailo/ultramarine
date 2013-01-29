# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $("form.new_comment").hide()
  $("form.new_comment").submit comment_submit_handler 
  $(".comment_reply_link").click comment_reply
  $(".comment_collapse_link").click comment_collapse
  
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
      new_comment.find(".comment_reply_link").click comment_reply
      new_comment.find(".comment_collapse_link").click comment_collapse
  form.find("textarea").val ""
  return false

comment_reply = (event) ->
  $(this).parent().find("form.new_comment").first().slideToggle()
  return false

comment_collapse = (event) ->
  collapse_icon = $(this)
  subcomment_section = $(this).parents(".comment-header").parent().find(".comment-body")
  if subcomment_section.is(":visible")
    subcomment_section.slideUp()
    collapse_icon.text("[+]")
  else
    subcomment_section.slideDown()
    collapse_icon.text("[-]")
  return false
