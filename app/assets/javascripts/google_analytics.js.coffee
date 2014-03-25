window.UAAccount = 'UA-331614-1'
# Use GA test account for dev and test instances
if $("body.test, body.development, body.staging").length
  window.UAAccount = 'UA-19475063-1'

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
