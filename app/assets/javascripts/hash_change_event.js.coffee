$ ->
  window.addEventListener "hashchange", (e) ->
    $(window).trigger("hashchange", e)
