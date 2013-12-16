jQuery ($) ->
  if $("body.test, body.development").length then mapEnv = "test" else mapEnv = "prod"

  # Used for iframe with single POI
  urlForInlineMap = (streetAddress) ->
    encodeURI "http://xyz.malmo.se/mkarta/init/map-1.00.htm?mapmode=basic&poi=#{streetAddress}&zoomlevel=3&maptype=Karta&env=#{mapEnv}"

  # Used for full map with single POI
  urlForFullMap = (streetAddress) ->
    encodeURI "http://www.malmo.se/karta?poi=#{streetAddress}&zoomlevel=4&maptype=karta"

  # Rewrite href attr on load to enable right click open in full map
  $("[data-poi]").attr "href", ->
    urlForFullMap($(@).attr("data-poi"))

  # Replace `data-map-selector` contents with the iframe and set the src from `data-poi`
  $("body").on "click", "[data-poi]", (event) ->
    event.preventDefault()
    $iframe = $('<iframe scrolling="no" frameborder="0" src=""></iframe>')
    $selector = $ $(@).attr("data-map-selector")
    if $selector.length
      $selector.show().html $iframe.attr("src", urlForInlineMap($(@).attr("data-poi")))
