jQuery ($) ->
  items = 0
  requestTerm = ""
  searchFields = ["#full-search #q", "#masthead-search .q"]
  for searchField in searchFields
    do ->
      $searchField = $(searchField)
      if $searchField.length
        $searchField.autocomplete
          source: (request, response) ->
            requestTerm = request.term
            $.ajax
              url: $searchField.attr("data-autocomplete-url")
              data:
                q: request.term.toLowerCase()
                ilang: 'sv'
              dataType: "jsonp"
              jsonpCallback: "results"
              success: (data) ->
                if data.length
                  items = data.length
                  response $.map data, (item) ->
                    return {
                      hits: item.nHits
                      suggestionHighlighted: item.suggestionHighlighted
                      value: item.suggestion
                    }
                else
                  $searchField.autocomplete("close")
          minLength: 2
          select: (event, ui) ->
            if ui.item.path is "full-search"
              $searchField.closest("form").submit()
            else
              document.location = ui.item.path
        .data( "ui-autocomplete" )._renderItem = (ul, item) ->
          # Create item for full search we reached the last item
          $more = ""
          if items is ul.find("li").length + 1
            $more = $("<li class='more-search-results ui-menu-item' role='presentation'><a class='ui-corner-all'>Visa alla sökresultat</a></li>")
              .data("ui-autocomplete-item", { path: "full-search", value: requestTerm})
          ul.addClass('site-search')
          $("<li>")
            .data("ui-autocomplete-item", item)
            .append("<a><span class='hits'>" + item.hits + "</span>" + item.suggestionHighlighted + "</a>")
            .appendTo(ul).after($more)
