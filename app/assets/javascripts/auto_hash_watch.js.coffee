$ ->
  $(window).bind "hashchange", hash_changed
  window.hash_changed()

window.hash_changed = ->
  $(".nav-hash li").removeClass("active")
  $(".content-hash").hide()
  $(window.location.hash + "-tab").addClass("active")
  $(window.location.hash + "-hash").show()
