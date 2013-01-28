$ ->
  $("[href^='/votes/vote']").click (e) ->
    e.preventDefault()
    n = $(this).parents(".vote-container").find(".vote-count")
    if $(this).hasClass("btn-success")
      n.text(parseInt(n.text()) - 1)
      $(this).removeClass("btn-success")
    else
      n.text(parseInt(n.text()) + 1)
      $(this).addClass("btn-success")
    $.post $(this).attr("href")
    return false
