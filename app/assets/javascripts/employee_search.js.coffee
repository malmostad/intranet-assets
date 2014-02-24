$ ->
  # Autocomplete on employee search
  queryEmployeeFields = ["#query-employee", "#masthead-q-employee"]
  items = 0
  for queryEmployeeField in queryEmployeeFields
    $queryEmployeeField = $(queryEmployeeField)
    if $queryEmployeeField.length
      $queryEmployeeField.autocomplete
        source: (request, response) ->
          $.ajax
            url: $queryEmployeeField.attr("data-autocomplete-url").replace("http:", location.protocol)
            data:
              term: request.term.toLowerCase()
            dataType: "jsonp"
            timeout: 5000
            success: (data) ->
              if data.length
                items = data.length
                response $.map data, (item) ->
                  item
        minLength: 2
        select: (event, ui) ->
          if ui.item.path is "full-search"
            $queryEmployeeField.closest("form").submit()
          else
            document.location = ui.item.path
      .data("ui-autocomplete")._renderItem = (ul, item) ->
        # Create item for full search we reached the last item
        $more = ""
        if items is ul.find("li").length + 1
          $more = $("<li class='more-search-results ui-menu-item' role='presentation'><a>Visa fler resultat</a></li>")
            .data("ui-autocomplete-item", { path: "full-search"})
        ul.addClass('search_users')
        $("<li>")
          .data("ui-autocomplete-item", item)
          .append("<a><img src='#{item.avatar_full_url}'/>
              <p>#{item.displayname}<br>
              #{item.company_short}<br>
              #{item.department}</p></a>
          ")
          .appendTo(ul).append($more)
