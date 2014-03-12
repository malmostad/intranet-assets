# Autocomplete for site search
jQuery ($) ->
  # Covers both masthead search and the search page form
  searchFields = ["#full-search #q", "#masthead-search .q"]
  for searchField in searchFields
    do ->
      $searchField = $(searchField)
      if $searchField.length
        requestTerm = ""
        $searchField.autocomplete
          minLength: 2
          source: (request, response) ->
            requestTerm = request.term
            remoteData($searchField, request, response)
          select: (event, ui) ->
            if ui.item.path is "full-search"
              $searchField.closest("form").submit()
            else
              document.location = ui.item.path
          open: ->
            $widget = $searchField.autocomplete("widget").addClass('site-search')
            recommendationHeader($widget)
            suggestionHeader($widget)
            fullSearchItem($widget, requestTerm)
        .data("ui-autocomplete")._renderItem = (ul, item) ->
          if item.link
            recommendationItem(ul, item)
          else if item.suggestion
            suggestionItem(ul, item)

  remoteData = ($searchField, request, response) ->
    $.ajax
      url: $searchField.attr("data-autocomplete-url")
      data:
        q: request.term.toLowerCase()
      dataType: "jsonp"
      success: (data) ->
        items = data.recommendations.length + data.sitesearch.length
        if items
          response $.map data, (item) ->
            item
        else
          $searchField.autocomplete("close")

  recommendationItem = (ul, item) ->
    $("<li class='recommendation'>")
      .data("ui-autocomplete-item", item)
      .append("<a><span class='hits'>" + item.hits + "</span>" + item.suggestionHighlighted + "</a>")
      .appendTo ul

  suggestionItem = (ul, item) ->
    $("<li class='suggestion'>")
      .data("ui-autocomplete-item", item)
      .append("<a><span class='hits'>" + item.hits + "</span>" + item.suggestionHighlighted + "</a>")
      .appendTo ul

  fullSearchItem = ($widget, term) ->
    $("<li class='more-search-results ui-menu-item' role='presentation'><a class='ui-corner-all'>Visa alla sökresultat</a></li>")
      .data("ui-autocomplete-item", { path: "full-search", value: term})
      .appendTo $widget

  recommendationHeader = ($widget) ->
    $("<li class='ui-autocomplete-category'>Gå direkt till:</li>")
      .insertBefore $widget.find(".recommendation:first")

  suggestionHeader = ($widget) ->
    $("<li class='ui-autocomplete-category'>Sök på:</li>")
      .insertBefore $widget.find(".suggestion:first")
