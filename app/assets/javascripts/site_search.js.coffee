$ ->
  # Autocomplete site search
  $searchField = $('#masthead-search-intranet input.text')
  if $searchField.length
    $searchField.autocomplete
      source: (request, response) ->
        $.ajax
          url: $searchField.attr("data-autocomplete-url").replace("http:", location.protocol)
          data:
            q: request.term.toLowerCase()
            ilang: 'sv'
          dataType: "jsonp"
          timeout: 5000
          jsonpCallback: "results"
          success: (data) ->
            if data.length
              response $.map data, (item) ->
                if item.name
                  return {
                    hits: 1
                    suggestionHighlighted: item.name
                    value: item.terms[0]
                  }
                else
                  return {
                    hits: item.nHits
                    suggestionHighlighted: item.suggestionHighlighted
                    value: item.suggestion
                  }
            else
              $searchField.autocomplete("close")
      minLength: 2
      select: (event, ui) ->
        $searchField.val(ui.item.value)
        $("#masthead-search-intranet").submit()
    .data("ui-autocomplete")._renderItem = (ul, item) ->
      ul.addClass("masthead-ac")
      return $("<li></li>")
        .data("ui-autocomplete-item", item)
        .append("<a><span class='hits'>" + item.hits + "</span>" + item.suggestionHighlighted + "</a>")
        .appendTo(ul)
