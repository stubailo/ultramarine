$ ->
  $(window).bind "hashchange", hash_changed
  
  window.hash_changed()

window.hash_changed = ->
  unless window.location.hash and $(".nav-hash li" + window.location.hash + "-tab").length > 0
    window.location.hash = $(".nav-hash li").map( (index, el) -> $(el).attr("id").split("-")[0])[0]
  $(".nav-hash li").removeClass("active")
  $(".content-hash").hide()
  $(window.location.hash + "-tab").addClass("active")
  $(window.location.hash + "-hash").show()
