var UAAccount = 'UA-1659147-1';
// Use GA test account for dev and test instances
if ( $("body.test, body.development").length ) {
  UAAccount = 'UA-19475064-1';
}

var _gaq = _gaq || [];
_gaq.push(['_setAccount', UAAccount]);
_gaq.push(['_setDomainName', '.malmo.se']);

(function() {
  var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
  ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
  var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
})();

function gaDelayEvent($a, event) {
  if(!event.isDefaultPrevented() && !$a.attr('target')  && !$a.attr('onclick')) {
    event.preventDefault();
    setTimeout('document.location = "' + $a.attr('href') + '"', 100);
  }
}

jQuery(document).ready(function($) {

  // Check if a custom URI is defined on the Sitevision page
  if (typeof currentURI == "string") {
    _gaq.push(['_trackPageview', currentURI + document.location.search]);
  } else {
    _gaq.push(['_trackPageview']);
  }

  // Track department/working field from cookie as Event logging
  $.cookie.json = true;
  var profile = $.cookie('myprofile') || {};
  _gaq.push(['_trackEvent', 'Department', profile.department || 'none']);
  _gaq.push(['_trackEvent', 'WorkingField', profile.workingfield || 'none']);

  // Track outgoing links as regular page views
  $("a[href^='http://'], a[href^='https://']").click(function(event) {
      $a = $(this);
      // Don't hijack href's in search results and URL's to malmo.se apps
      if ($a.parents('div.search').length === 0 && !$a.attr('href').match(/.malmo\.se\//) ) {
          _gaq.push(['_trackPageview', 'ExternalLink ' + $a.attr("href")]);
          gaDelayEvent($a, event);
      }
  });

  // Track file downloads
  var fileTypes = ['doc', 'docx', 'xls','xlsx', 'ppt', 'pptx', 'pdf', 'zip'];
  $('a').each(function() {
    var $a = $(this);
    var href = $a.attr('href');
    if (typeof href == "string") {
      href = href.split('.').pop();
      var extension  = href.split('#').shift(); // pdf files has an # in the search results

      if ($.inArray(extension, fileTypes) != -1) {
        $a.click(function(event) {
          var link = $(this).attr("href");
          _gaq.push(['_trackPageview', 'FileDownload ' + link]);
          gaDelayEvent($a, event);
        });
      }
    }
  });

  // Tracking of categories and author for "Nyheter" and "Blogg". `newsTracking` and `blogTracking` is defined on those sites
  if (typeof newsTracking !== 'undefined' ) {
    $.each(newsTracking['categories'], function(index, category) {
      _gaq.push(['_trackEvent', 'newsCategory',   "newsCategory-" + category]);
    });
    _gaq.push(['_trackEvent', 'newsAuthor', "newsAuthor-" + newsTracking['author']]);
  }

  if (typeof blogTracking !== 'undefined' ) {
    $.each(blogTracking['categories'], function(index, category) {
      _gaq.push(['_trackEvent', 'blogCategory', "blogCategory-" + category]);
    });
    _gaq.push(['_trackEvent', 'blogAuthor', "blogAuthor-" + blogTracking['author']]);
  }

  // GA event tracking of top menu selection
  $("#malmo-masthead .nav-logo a, #malmo-masthead nav li[class!='dropdown'] a, #malmo-masthead nav li.dropdown ul a").click( function(event) {
    $a = $(this);

    // Special case for department & workingfield dropdowns
    if ($a.parents("#nav-my-department").length) {
      text = "Min förvaltning";
    }
    else if ($a.parents("#nav-my-workingfield").length) {
      text = "Mitt arbetsfält";
    }
    else if ($a.parents("#masthead-others").length) {
      text = $a.attr("title");
    }
    else {
      text = $a.text();
    }
    _gaq.push(['_trackEvent', 'topMenuClick', text, $a.attr('href').replace(/https*:\/\/.*\//, '/')]);
    gaDelayEvent($a, event);
  });

// +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// TODO: Remove this when new search integration is made
// +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  // Event tracking of details for selected link in the search results
  $('#search-results h3 a, #search-results .breadcrumb ul li a, #search-categories a').click(function(event) {
    var $a = $(this);
    var link = $a.attr('href');
    var GAAction = $("#essi-queryfield").val();
    var GALabel = $.trim($a.text()) + " " + link;

    // Track all clicks in the results list
    _gaq.push(['_trackEvent', 'SearchClickPosition', GAAction, GALabel, parseInt($a.parent().parent().closest('li').attr('data-position'), 10)]);

    // Track clicks on breadcrumbs in the results list
    if ($a.closest("div.breadcrumb").length > 0) {
      _gaq.push(['_trackEvent', 'SearchClickBreadcrumb', GAAction,  GALabel]);
    }

    // Track clicks on editors choich in the results list
    if ($a.closest("#search-categories").length > 0) {
      _gaq.push(['_trackEvent', 'SearchClickCategory', GAAction,  GALabel]);
    }
    gaDelayEvent($a, event);
  });
// +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

});
