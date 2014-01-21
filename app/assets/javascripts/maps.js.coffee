# Integrations for SBK's map service
jQuery ($) ->
  if $("body.test, body.development").length then mapEnv = "test" else mapEnv = "prod"

  # Used for iframe with single POI
  urlForInlineMap = (streetAddress) ->
    encodeURI "//xyz.malmo.se/mkarta/init/map-1.00.htm?mapmode=basic&poi=#{streetAddress}&zoomlevel=3&maptype=Karta&env=#{mapEnv}"

  # Used for full map with single POI
  urlForFullMap = (streetAddress) ->
    encodeURI "//www.malmo.se/karta?poi=#{streetAddress}&zoomlevel=4&maptype=karta"

  # Rewrite href attr on load to enable right click open in full map
  $("[data-poi]").attr "href", ->
    urlForFullMap($(@).attr("data-poi"))

  # Replace `data-map-selector` contents with the iframe and set the src from `data-poi`
  $("body").on "click", "[data-poi]", (event) ->
    event.preventDefault()

    $iframe = $('<iframe scrolling="no" frameborder="0" src=""></iframe>')
    $selector = $($(@).attr("data-map-selector"))
    if $selector.length
      # Set selector position to relative so we can place the close link on it
      $selector.css("position", "relative") if $selector.css("position") is "static"

      # Inject the iframe
      $selector.show().html($iframe.attr("src", urlForInlineMap($(@).attr("data-poi"))))

      # Place a close link on the map
      $selector.prepend("<a href='#map' class='close-map'><span class='icon-remove'></span>Stäng</a>")
        .find("a").click (event)->
          event.preventDefault()
          $selector.hide()

      # After injection, scroll to the top of `data-scroll-to` or the $selector
      $scrollTo = if $(@).is("[data-scroll-to]") then $($(@).attr("data-scroll-to")) else $selector
      window.scrollTo(0, $scrollTo.offset().top - 51)
