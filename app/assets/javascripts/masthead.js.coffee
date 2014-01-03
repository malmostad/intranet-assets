jQuery ($) ->
  # Inject the masthead from the stringified html code
  $(malmoMasthead).prependTo('body')

  $malmoMastheadNav = $("#malmo-masthead nav.masthead-main")

  hideNav = ->
    $malmoMastheadNav.slideUp(100)

  showNav = ->
    hideSearch()
    $malmoMastheadNav.slideDown(100)
    # Close on click outside the nav. Expensive but rare binding.
    $('body > *').not('#malmo-masthead').one 'click', (event) ->
      event.preventDefault()
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
        .append(' <span class="icon-caret-down">')
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
    if $("#malmo-masthead nav.masthead-main").is(":hidden") then showNav() else hideNav()

  # Browser sniffing hack for landscape text size on iPhone. Note: Prevents zooming on desktops so we limit it to iOS.
  if /iPhone|iPod/.test(navigator.platform) and navigator.userAgent.indexOf("AppleWebKit") > -1
    $("html").attr("style", "-webkit-text-size-adjust: none")

  # https://github.com/ftlabs/fastclick
  new FastClick $('#nav-menu-trigger')[0]

  # Turn off Bootstraps hover look-alikes on touch devices
  $(document).off('touchstart.dropdown')
