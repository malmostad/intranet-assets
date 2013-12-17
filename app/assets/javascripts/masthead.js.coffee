jQuery ($) ->
  # Inject the masthead from the stringified html code
  $(malmoMasthead).prependTo('body')

  $malmoMastheadNav = $("#masthead-main")
  $mastheadSearch = $("#masthead-search")
  $form = $("#masthead-search").find("form")

  hideNav = ->
    $malmoMastheadNav.slideUp(100)

  showNav = ->
    hideSearch()
    $malmoMastheadNav.slideDown(100)

    # Close on click outside the nav. Expensive but rare binding.
    $('body > *').not('#malmo-masthead').one 'click', (event) ->
      event.preventDefault()
      hideNav()

  hideSearch = ->
    $mastheadSearch.find("input").blur()
    if $mastheadSearch.css("position") is 'static'
      $mastheadSearch.slideUp 100, ->
        $(@).css("top", "")

  showSearch = ->
    hideNav()
    if $("#full-search #q").length
      $("#q").focus()
    else
      $mastheadSearch.css("top", $("#malmo-masthead").height() + "px")
      $mastheadSearch.show()
      $mastheadSearch.find("input:first").focus()

      # Close on click outside the searchbox. Expensive but rare binding.
      $('body > *').not('#malmo-masthead').one 'click', (event) ->
        event.preventDefault()
        hideSearch()

  $("#nav-menu-trigger a").click (event) ->
    event.preventDefault();
    if $("#masthead-main").is(":hidden") then showNav() else hideNav()

  $("#nav-search-trigger a").click (event) ->
    event.preventDefault()
    if $mastheadSearch.is(":hidden") then showSearch() else hideSearch()

  # Bind escape key to hide form
  $mastheadSearch.focusin ->
    $(document).on 'keyup', (event) ->
      if event.which is 27 and $mastheadSearch.css("position") is 'static'
        hideSearch()

  # Un-bind escape key
  $mastheadSearch.focusout ->
    $(document).off('keyup')

  $form.submit (event) ->
    event.preventDefault()
    query = $(@).find("input[name=q]").val()
    document.location = $(@).attr('action') + "?q=" + query;

  # Browser sniffing hack for landscape text size on iPhone. Note: Prevents zooming on desktops so we limit it to iOS.
  if /iPhone|iPod/.test(navigator.platform) and navigator.userAgent.indexOf("AppleWebKit") > -1
    $("html").attr("style", "-webkit-text-size-adjust: none")

  # https://github.com/ftlabs/fastclick
  new FastClick $('#nav-menu-trigger')[0]
  new FastClick $('#nav-search-trigger')[0]

  # Turn off Bootstraps hover look-alikes on touch devices
  $(document).off('touchstart.dropdown')

  # Autocomplete
  $searchField = $mastheadSearch.find('.q')
  if $searchField.length
    $searchField.autocomplete
      source: (request, response) ->
        $.ajax
          url: $searchField.attr("data-autocomplete-url").replace("http:", location.protocol)
          data:
            q: request.term.toLowerCase()
            ilang: 'sv'
          dataType: "jsonp"
          jsonpCallback: "results"
          success: (data) ->
            if data.length
              response $.map data, (item) ->
                return {
                  hits: item.nHits
                  suggestionHighlighted: item.suggestionHighlighted
                  value: item.suggestion
                }
      minLength: 2
      select: (event, ui) ->
        document.location = $form.attr('action') + '?q=' + unescape(ui.item.value)
    .data( "ui-autocomplete" )._renderItem = (ul, item) ->
      ul.css("z-index", 1000)
      return $("<li></li>")
        .data("ui-autocomplete-item", item)
        .append("<a><span class='hits'>" + item.hits + "</span>" + item.suggestionHighlighted + "</a>")
        .appendTo(ul)
