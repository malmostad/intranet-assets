jQuery ($) ->
  $mastheadSearch = $("#masthead-search")

  hideSearch = ->
    $mastheadSearch.find("input").blur()
    $mastheadSearch.find("input.text").val("")
    # $mastheadSearch.slideUp(100)
    $mastheadSearch.removeClass "expanded"
    $mastheadSearch.css("top", "")
    $(document).off 'click.searchForm'

  showSearch = ->
    $mastheadSearch.addClass "expanded"
    $mastheadSearch.css("top", $("#malmo-masthead").height() + "px")
    $mastheadSearch.show()
    # $("#masthead-search-intranet").find("input.q:first").focus()

    # Close on click outside the searchbox
    $(document).on 'click.searchForm', (event) ->
      hideSearch() unless $(event.target).closest("#masthead-search").length

  # Bind escape key to hide form
  $mastheadSearch.focusin ->
    $(document).on 'keyup.searchForm', (event) ->
      hideSearch() if event.which is 27

  # Un-bind escape key
  $mastheadSearch.focusout ->
    $(document).off('keyup.searchForm')

  $('#masthead-search-intranet .q').focus ->
    showSearch()

  $("#nav-search-trigger a").click (event) ->
    event.preventDefault()
    if $("#masthead-search").is(":hidden") then showSearch() else hideSearch()


  # https://github.com/ftlabs/fastclick
  new FastClick $('#nav-search-trigger')[0]

  # Autocomplete
  $searchField = $('#masthead-search-intranet .q')
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
        $("#masthead-search-intranet").submit()
    .data( "ui-autocomplete" )._renderItem = (ul, item) ->
      ul.css("z-index", 1000)
      return $("<li></li>")
        .data("ui-autocomplete-item", item)
        .append("<a><span class='hits'>" + item.hits + "</span>" + item.suggestionHighlighted + "</a>")
        .appendTo(ul)
