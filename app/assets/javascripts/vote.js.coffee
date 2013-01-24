$ ->
  $(".vote-btn-group a").click (e) ->
    e.preventDefault()
    $.post($(this).attr("href"), {}, (->), "json")
    was_active = $(this).hasClass("active")
    $(".vote-btn-group a").removeClass("active")
    unless was_active
      $(this).addClass("active")
    return false;
