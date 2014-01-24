jQuery ($) ->
  # Inject the masthead from the stringified html code
  $(malmoMasthead).prependTo('body')

  $malmoMastheadNav = $("#malmo-masthead nav.masthead-main")

  isNarrow = ->
    $("#nav-search-trigger").is(":visible")

  hideNav = ->
    $("body").removeClass("nav-open");
    $malmoMastheadNav.removeClass("expanded")
    $(document).off 'click.nav'

  showNav = (event) ->
    hideSearch()
    $("body").addClass("nav-open");
    $malmoMastheadNav.addClass("expanded")
    # Close on click outside the list
    $(document).on 'click.nav', (event) ->
      if $(event.target).is("ul")
        hideNav()

  # We use the cookie values to change two nav items
  hijackNav = (navItem, items, plural) ->
    # Add a dropdown if the user has more than one items
    if items.length > 1
      $(navItem).addClass('dropdown')
        .find('a')
        .addClass('dropdown-toggle no-arrow')
        .attr('data-toggle', 'dropdown')
        .text(plural)
        .append('<span class="icon-caret-down">')
        .end()
        .append('<ul class="dropdown-menu"></ul>')

      $.each items, (index, value) ->
        $(navItem).find('ul').append('<li><a href="' + value.homepage_url + '">' + value.name + '</a></li>')

    # Change the href if the user has one item
    else if items.length is 1
      $(navItem).find('a').attr('href', items[0].homepage_url)

  # We share the profile cookie on multiple systems so we have a limited set of
  # environments for the profile
  # Set test or development as a class in the body tag if applicable
  development = $('body').hasClass('development')
  test = $('body').hasClass('test')

  # Users profile from the Dashboard is available in a cookie.
  $.cookie.json = true

  if development then myprofile = "myprofile-development"
  else if test then myprofile = "myprofile-test"
  else myprofile = "myprofile"

  profile = $.cookie(myprofile) || {}
  if profile.departments then hijackNav('#nav-my-department', profile.departments, 'Mina förvaltningar')
  if profile.workingfields then hijackNav('#nav-my-workingfield', profile.workingfields, 'Mina arbetsfält')

  $("#nav-menu-trigger a").click (event) ->
    event.preventDefault();
    if $("#malmo-masthead nav.masthead-main").is(":hidden") then showNav(event) else hideNav()

  # Browser sniffing hack for landscape text size on iPhone. Note: Prevents zooming on desktops so we limit it to iOS.
  if /iPhone|iPod/.test(navigator.platform) and navigator.userAgent.indexOf("AppleWebKit") > -1
    $("html").attr("style", "-webkit-text-size-adjust: none")

  # https://github.com/ftlabs/fastclick
  new FastClick $('#nav-menu-trigger')[0]

  # Turn off Bootstraps hover look-alikes on touch devices
  $(document).off('touchstart.dropdown')

# Search form
  $mastheadSearch = $("#masthead-search")
  hideSearch = ->
    $mastheadSearch.removeClass("expanded")
    $mastheadSearch.find("input").blur()
    $mastheadSearch.find("div").removeClass("input-append input-prepend")
    $(document).off 'click.searchForm'

  showSearch = ->
    hideNav() if isNarrow()

    $mastheadSearch.addClass("expanded")
    $mastheadSearch.find("div").addClass("input-append input-prepend")

    # Close on click outside the searchbox
    $(document).on 'click.searchForm', (event) ->
      hideSearch() unless $(event.target).closest("#masthead-search, #nav-search-trigger").length

  # Bind escape key to hide form
  $mastheadSearch.focusin ->
    $(document).on 'keyup.searchForm', (event) ->
      hideSearch() if event.which is 27

  # Un-bind escape key
  $mastheadSearch.focusout ->
    $(document).off('keyup.searchForm')

  $('#masthead-search-intranet input.text').focus ->
    showSearch()

  $('#masthead-search .icon-search').click ->
    $('#masthead-search-intranet input.text').focus()
    showSearch()

  $("#nav-search-trigger a").click (event) ->
    event.preventDefault()
    if $("#masthead-search-intranet input.text").is(":hidden") then showSearch() else hideSearch()

  # https://github.com/ftlabs/fastclick
  new FastClick $('#nav-search-trigger')[0]

  # Autocomplete
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
    .data("ui-autocomplete")._renderItem = (ul, item) ->
      ul.css("z-index", 1000).addClass("masthead-ac")
      return $("<li></li>")
        .data("ui-autocomplete-item", item)
        .append("<a><span class='hits'>" + item.hits + "</span>" + item.suggestionHighlighted + "</a>")
        .appendTo(ul)

  # Autocomplete on user search
  $queryEmployee = $("#masthead-q-employee")
  if $queryEmployee.length
    $queryEmployee
      .autocomplete
        source: $queryEmployee.attr("data-path")
        minLength: 2
        appendTo: $queryEmployee.closest(".box")
        select: (event, ui) ->
          document.location = ui.item.path
      .data("ui-autocomplete")
      ._renderItem = (ul, item) ->
        ul.addClass('search_users')
        if $queryEmployee.hasClass("full-search")
          ul.addClass('full-search')
        $("<li>")
          .data("ui-autocomplete-item", item)
          .append("<a><img src='#{item.avatar_full_url}'/>
              <p>#{item.first_name} #{item.last_name}<br>
              #{item.company_short}<br>
              #{item.department}</p></a>
          ")
          .appendTo(ul)

