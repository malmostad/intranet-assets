jQuery ($) ->
  # if #nav-menu-trigger is displayed, the masthead is collapsed
  narrowMode = ->
    $("#nav-menu-trigger").css('display') is 'none'

  hideNav = ->
    # Hide nav if the masthead is in narrow mode
    if narrowMode() then $malmoMastheadNav.slideUp(100)

  showNav = ->
    hideSearch()
    $malmoMastheadNav.slideDown(100)
    # Close on click outside the nav. Expensive but rare binding.
    $('body > *').not('#malmo-masthead').one 'click', (event) ->
      event.preventDefault()
      hideNav()

  hideSearch = ->
    $mastheadSearch.find("input").blur()
    $mastheadSearch.slideUp(100)

  showSearch = ->
    $mastheadSearch.css("top", $("#malmo-masthead").height() + "px")
    $mastheadSearch.slideDown(100)
    $("#masthead-search-intranet").find("input:first").focus()

    # Close on click outside the searchbox. Expensive but rare binding.
    $('body > *').not('#malmo-masthead').one 'click', (event) ->
      event.preventDefault()
      hideSearch()

  # We use the cookie values to change two nav items
  hijackNav = (navItem, items, plural) ->
    # Add a dropdown if the user has more than one items
    if items.length > 1
      $(navItem).addClass('dropdown')
        .find('a')
        .addClass('dropdown-toggle no-arrow')
        .attr('data-toggle', 'dropdown')
        .text(plural)
        .append(' <span class="icon-caret-down">')
        .end()
        .append('<ul class="dropdown-menu"></ul>')

      $.each items, (index, value) ->
        $(navItem).find('ul').append('<li><a href="' + value.homepage_url + '">' + value.name + '</a></li>')

    # Change the href if the user has one item
    else if items.length is 1
      $(navItem).find('a').attr('href', items[0].homepage_url)


  # Animations are slow on some narrow devices
  $.fx.off = narrowMode()

  # We share the profile cookie on multiple systems so we have a limited set of
  # environments for the profile
  # Set test or development as a class in the body tag if applicable
  development = $('body').hasClass('development')
  test = $('body').hasClass('test')

  # Inject the masthead from the stringified html code
  masthead = malmoMasthead
  # Hard coded link rewriting in pre-prod envs for convenience
  if test
    masthead = masthead.replace(/komin\.malmo\.se/g, 'komin.test.malmo.se')
    masthead = masthead.replace(/webapps06\.malmo\.se\/dashboard/g, 'webapps06.malmo.se/dashboard-test')
  else if development
    masthead = masthead.replace(/https?:\/\/webapps06\.malmo\.se\/dashboard/g, '')
  $(masthead).prependTo('body')

  $malmoMastheadNav = $("#malmo-masthead nav.masthead-main")
  $mastheadSearch = $("#masthead-search")

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
    if $malmoMastheadNav.is(":hidden") then showNav() else hideNav()

  $("#nav-search-trigger a").click (event) ->
    event.preventDefault()
    if $("#masthead-search").is(":hidden") then showSearch() else hideSearch()

  # Bind escape key to hide form
  $mastheadSearch.focusin ->
    $(document).on 'keyup', (event) ->
      if event.which is 27
        hideSearch()

  # Un-bind escape key
  $mastheadSearch.focusout ->
    $(document).off('keyup')

  # Komin search
  $("#masthead-search-intranet").submit (event) ->
    event.preventDefault()
    query = $(this).find("input[name=q]").val()
    document.location = $(this).attr('action') + "?q=" + query;

  # Browser sniffing hack for landscape text size on iPhone. Note: Prevents zooming on desktops so we limit it to iOS.
  if /iPhone|iPod/.test(navigator.platform) and navigator.userAgent.indexOf("AppleWebKit") > -1
    $("html").attr("style", "-webkit-text-size-adjust: none")

  # Minor small device adjustments
  viewportContent = $("meta[name=viewport]").attr("content")
  if $(window).width() <= 480
    # Temporarily disable zoom on text field focus
    $('input')
      .focus ->
        $("meta[name=viewport]").attr("content", viewportContent + ', maximum-scale=1')
      .blur ->
        $("meta[name=viewport]").attr("content", viewportContent + ', maximum-scale=10')

  # https://github.com/ftlabs/fastclick
  new FastClick $('#nav-menu-trigger')[0]
  new FastClick $('#nav-search-trigger')[0]

  # Turn off Boostraps hover look-alikes on touch devices
  $(document).off('touchstart.dropdown')
