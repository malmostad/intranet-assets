window.UAAccount = 'UA-1659147-1'
# Use GA test account for dev and test instances
if $("body.test, body.development").length
  window.UAAccount = 'UA-19475064-1'

window._gaq = []
_gaq.push(['_setAccount', UAAccount])
_gaq.push(['_setDomainName', '.malmo.se'])

(->
  ga = document.createElement('script')
  ga.type = 'text/javascript'
  ga.async = true
  ga.src = (if 'https:' is document.location.protocol then 'https://ssl' else 'http://www') + '.google-analytics.com/ga.js'
  s = document.getElementsByTagName('script')[0]
  s.parentNode.insertBefore(ga, s)
  return
)()

jQuery ($) ->
  # Delay click events so GA has time to collect data before executed
  window.gaDelayEvent = ($a, event) ->
    if !event.isDefaultPrevented() and !$a.attr('target') and !$a.attr('onclick')
      event.preventDefault()
      setTimeout('document.location = "' + $a.attr('href') + '"', 100)

  # Check if a custom URI is defined on the Sitevision page
  if typeof currentURI is "string"
    _gaq.push(['_trackPageview', currentURI + document.location.search])
  else
    _gaq.push(['_trackPageview'])

  # Track department/working field from cookie as Event logging
  $.cookie.json = true
  profile = $.cookie('myprofile') or {}
  _gaq.push(['_trackEvent', 'Department', profile.department or 'none'])
  _gaq.push(['_trackEvent', 'WorkingField', profile.workingfield or 'none'])

  # Track outgoing links as regular page views
  $("a[href^='http://'], a[href^='https://']").click (event) ->
    $a = $(@)
    # Don't hijack href's in search results and URL's to malmo.se apps
    if $a.parents('div.search').length is 0 and !$a.attr('href').match(/.malmo\.se\//)
      _gaq.push(['_trackPageview', 'ExternalLink ' + $a.attr("href")])
      gaDelayEvent($a, event)

  # Track file downloads
  fileTypes = ['doc', 'docx', 'xls','xlsx', 'ppt', 'pptx', 'pdf', 'zip']
  $('a').each () ->
    $a = $(@)
    href = $a.attr('href')
    if typeof href is "string"
      href = href.split('.').pop()
      extension  = href.split('#').shift(); # pdf files has an # in the search results

      if $.inArray(extension, fileTypes) isnt -1
        $a.click (event) ->
          link = $(this).attr("href")
          _gaq.push(['_trackPageview', 'FileDownload ' + link])
          gaDelayEvent($a, event)

  # Tracking of categories and author for "Nyheter" and "Blogg". `newsTracking` and `blogTracking` is defined on those sites
  if typeof newsTracking isnt 'undefined'
    $.each newsTracking['categories'], (index, category) ->
      _gaq.push(['_trackEvent', 'newsCategory',   "newsCategory-" + category])
    _gaq.push(['_trackEvent', 'newsAuthor', "newsAuthor-" + newsTracking['author']])

  if typeof blogTracking isnt 'undefined'
    $.each blogTracking['categories'], (index, category) ->
      _gaq.push(['_trackEvent', 'blogCategory', "blogCategory-" + category])
    _gaq.push(['_trackEvent', 'blogAuthor', "blogAuthor-" + blogTracking['author']])

  # GA event tracking of top menu selection
  $("#malmo-masthead .nav-logo a, #malmo-masthead nav li[class!='dropdown'] a, #malmo-masthead nav li.dropdown ul a").click (event) ->
    $a = $(@);

    # Special case for department & workingfield dropdowns
    if $a.parents("#nav-my-department").length then text = "Min förvaltning"
    else if $a.parents("#nav-my-workingfield").length then text = "Mitt arbetsfält"
    else if $a.parents("#masthead-others").length then text = $a.attr("title")
    else text = $a.text()

    _gaq.push(['_trackEvent', 'topMenuClick', text, $a.attr('href').replace(/https*:\/\/.*\//, '/')])
    gaDelayEvent($a, event)
