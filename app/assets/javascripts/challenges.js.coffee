# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# make tabs

$ ->
  if $("#challenge-location-image").length > 0
    image = $("#challenge-location-image")
    lat = image.attr("data-lat")
    lon = image.attr("data-lon")
    map_div = $("<div id='challenge-location-map'></div>")
    image.replaceWith map_div

    map_options =
      center: new google.maps.LatLng lat, lon
      zoom: 13
      mapTypeId: google.maps.MapTypeId.ROADMAP

    map = new google.maps.Map(map_div.get(0), map_options)

    marker = new google.maps.Marker
      position: new google.maps.LatLng lat, lon
      map: map
      title: "Location"
  
  if $("body.challenges #location-controls").length > 0
    $("#location-controls input").hide()
    $("#location-controls").append("<div id='map-canvas'></div>")
    map_div = $("#map-canvas")
    lat_input = $("#challenge_lat")
    lon_input = $("#challenge_lon")

    start_position = new google.maps.LatLng 0, 0
    if lat_input.val() and lon_input.val()
      start_position = new google.maps.LatLng lat_input.val(), lon_input.val()
    else
      start_position = new google.maps.LatLng lat_input.attr("data-location-lat"), lon_input.attr("data-location-lon")
    map_options =
      center: start_position
      zoom: 12
      mapTypeId: google.maps.MapTypeId.ROADMAP
    
    map = new google.maps.Map(map_div.get(0), map_options)

    marker = null
    if lat_input.val() and lon_input.val()
      marker = new google.maps.Marker
        position: new google.maps.LatLng lat_input.val(), lon_input.val()
        map: map
        title: "Selected Location"

    google.maps.event.addListener map, 'click', (e) ->
      latLng = e.latLng
      lat = e.latLng.Ya
      lon = e.latLng.Za
      
      lat_input.val(lat)
      lon_input.val(lon)

      if marker
        marker.setMap null

      marker = new google.maps.Marker
        position: latLng
        map: map
        title: "Selected Location"

