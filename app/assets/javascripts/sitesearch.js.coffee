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
            if ui.item.link
              document.location = ui.item.link
            else
              $searchField.val(ui.item.value).closest("form").submit()
          open: ->
            $widget = $searchField.autocomplete("widget").addClass('site-search')
            recommendationHeader($widget)
            suggestionHeader($widget)
            fullSearchItem($widget, requestTerm)
        .data("ui-autocomplete")._renderItem = (ul, item) ->
          if item.link
            recommendationItem(ul, item, $searchField.attr("data-images-url"))
          else if item.suggestion
            suggestionItem(ul, item)

  remoteData = ($searchField, request, response) ->
    $.ajax
      url: $searchField.attr("data-autocomplete-url")
      data:
        q: request.term.toLowerCase()
      dataType: "jsonp"
      success: (data) ->
        if data.length
          response $.map data, (item) ->
            if item.name then $.extend item, { value: item.name }
            else $.extend item, { value: item.suggestion }
            item
        else
          $searchField.autocomplete("close")

  recommendationItem = (ul, item, imagesUrl) ->
    $img = $("<img>").attr("src", imagesUrl + item.image)
    $("<li class='recommendation'>")
      .append($("<a><p>#{item.name}</p></a>").prepend($img))
      .appendTo ul

  suggestionItem = (ul, item) ->
    $("<li class='suggestion'>")
      .append("<a><span class='hits'>#{item.nHits}</span>#{item.suggestionHighlighted}</a>")
      .appendTo ul

  fullSearchItem = ($widget, term) ->
    $("<li class='more-search-results ui-menu-item' role='presentation'><a class='ui-corner-all'>Visa alla sökresultat</a></li>")
      .data("ui-autocomplete-item", { value: term })
      .appendTo $widget

  recommendationHeader = ($widget) ->
    $("<li class='ui-autocomplete-category'>Gå direkt till:</li>")
      .insertBefore $widget.find(".recommendation:first")

  suggestionHeader = ($widget) ->
    $("<li class='ui-autocomplete-category'>Sök på:</li>")
      .insertBefore $widget.find(".suggestion:first")
