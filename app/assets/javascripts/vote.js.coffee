$ ->
  $("[href^='/votes/vote']").click (e) ->
    e.preventDefault()
    n = $(this).parents(".vote-container").find(".vote-count")
    if $(this).hasClass("btn-info")
      n.text(parseInt(n.text()) - 1)
      $(this).removeClass("btn-info")
    else
      n.text(parseInt(n.text()) + 1)
      $(this).addClass("btn-info")
    $.post $(this).attr("href")
    return false
