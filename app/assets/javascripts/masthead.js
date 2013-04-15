jQuery(document).ready(function($) {

  // We share the profile cookie on multiple systems so we have a limited set of
  // environments for the profile
  // Set test or development as a class in the body tag if applicable
  var development = $('body').hasClass('development');
  var test = $('body').hasClass('test');
  if ( development || test ) preprodLinks();

  // Inject the masthead from the stringified html code
  $(malmoMasthead).prependTo('body');

  // Users profile from the Dashboard is available in a cookie.
  $.cookie.json = true;
  if (development) {
    myprofile = "myprofile-development"
  } else if (test) {
    myprofile = "myprofile-test"
  } else {
    myprofile = "myprofile"
  }
  var profile = $.cookie(myprofile) || {};

  if (profile.departments) {
    hijackNav('#nav-my-department', profile.departments, 'Mina förvaltningar');
  }

  if (profile.workingfields) {
    hijackNav('#nav-my-workingfield', profile.workingfields, 'Mina arbetsfält');
  }

  // We use the cookie values to change two nav items
  function hijackNav(navItem, items, plural) {
    // Add a dropdown if the user has more than one items
    if (items.length > 1) {
      $(navItem).addClass('dropdown')
          .find('a')
          .addClass('dropdown-toggle no-arrow')
          .attr('data-toggle', 'dropdown')
          .text(plural)
          .append(' <span class="icon-caret-down">')
          .end()
          .append('<ul class="dropdown-menu"></ul>');

      $.each(items, function(index, value) {
        $(navItem).find('ul').append('<li><a href="' + value.homepage_url + '">' + value.name + '</a></li>');
      });
    }
    // Change the href if the user has one item
    else if (items.length === 1) {
      $(navItem).find('a').attr('href', items[0].homepage_url);
    }
  }

  var $malmoMastheadNav = $("#malmo-masthead nav.masthead-main");
  var $mastheadSearch = $("#masthead-search");
  var $mastheadSearchPerson = $("#masthead-search-person");
  var $mastheadSearchIntranet = $("#masthead-search-intranet");

  // if #nav-menu-trigger is displayed, the masthead is collapsed
  function narrowMode() {
    return $("#nav-menu-trigger").css('display') != 'none';
  }

  // Animations are slow on some narrow devices
  $.fx.off = narrowMode();

  function showSearch() {
    hideNav();
    $mastheadSearch.css("top", $("#malmo-masthead").height() + "px");
    $mastheadSearch.slideDown(100);
    $mastheadSearchIntranet.find("input:first").focus();

    // Close on click outside the searchbox. Expensive but rare binding.
    $('body > *').not('#malmo-masthead').one('click', function(event) {
      event.preventDefault();
      hideSearch();
    });
  }

  function hideSearch() {
    $mastheadSearch.find("input").blur();
    $mastheadSearch.slideUp(100);
  }

  function showNav() {
    hideSearch();
    $malmoMastheadNav.slideDown(100);

    // Close on click outside the nav. Expensive but rare binding.
    $('body > *').not('#malmo-masthead').one('click', function(event) {
      event.preventDefault();
      hideNav();
    });
  }

  function hideNav() {
    // Hide nav if the masthead is in narrow mode
    if ( narrowMode() ) $malmoMastheadNav.slideUp(100);
  }

  $("#nav-menu-trigger").click( function(event) {
    event.preventDefault();
    $malmoMastheadNav.is(":hidden") ? showNav() : hideNav();
  });

  $("#nav-search-trigger").click(function(event) {
    event.preventDefault();
    $("#masthead-search").is(":hidden") ? showSearch() : hideSearch();
  });

  // Bind escape key to hide form
  $mastheadSearch.focusin( function() {
    $(document).on('keyup', function(event) {
      if (event.which == 27) {
        hideSearch();
      }
    });
  });
  // Un-bind escape key
  $mastheadSearch.focusout( function() {
    $(document).off('keyup');
  });

  // Phone catalog search
  $mastheadSearchPerson.submit( function(event) {
    event.preventDefault();
    query = escape($mastheadSearchPerson.find("input[name=q]").val() + '|');
    window.open( $mastheadSearchPerson.attr('action') + query, "phonebook");
  });

  // Komin search
  $mastheadSearchIntranet.submit( function(event) {
    event.preventDefault();
    query = $mastheadSearchIntranet.find("input[name=q]").val();
    document.location = $mastheadSearchIntranet.attr('action') + "?q=" + query;
  });

  // Browser sniffing hack for landscape text size on iPhone. Note: Prevents zooming on desktops so we limit it to iP*o*s.
  if( ( /iPhone|iPod/.test( navigator.platform ) && navigator.userAgent.indexOf( "AppleWebKit" ) > -1 ) ) {
    $("html").attr("style", "-webkit-text-size-adjust: none");
  }

  // Minor small device adjustments
  var viewportContent = $("meta[name=viewport]").attr("content");
  if ( $(window).width() <= 480 ) {
    // Temporarily disable zoom on text field focus
    $('input')
      .focus( function() {
        $("meta[name=viewport]").attr("content", viewportContent + ', maximum-scale=1');
      })
      .blur( function() {
        $("meta[name=viewport]").attr("content", viewportContent + ', maximum-scale=10');
      }
    );
  }

  // https://github.com/ftlabs/fastclick
  new FastClick( $('#nav-menu-trigger')[0] );
  new FastClick( $('#nav-search-trigger')[0] );

  // Turn off Boostraps hover look-alikes on touch devices
  $(document).off('touchstart.dropdown');

  // Hard coded link rewriting in pre-prod envs for convenience
  function preprodLinks() {
    if (test) {
      malmoMasthead = malmoMasthead.replace(/komin\.malmo\.se/g, 'komin.test.malmo.se');
      malmoMasthead = malmoMasthead.replace(/webapps06\.malmo\.se\/dashboard/g, 'webapps06.malmo.se/dashboard-test');
    }
    if (development) {
      malmoMasthead = malmoMasthead.replace(/https?:\/\/webapps06\.malmo\.se\/dashboard/g, '');
    }
  }
});
