//= require json2
//= require jquery.cookie
//= require jquery-ui.custom.min
//= require bootstrap
//= require masthead_content
//= require masthead
//= require site_search
//= require employee_search
//= require fastclick
//= require google_analytics
//= require legacy

jQuery(document).ready(function($) {
  // Steal back the BS dropdown events that SV hijacked
  window.setTimeout(function() { $("[data-toggle=dropdown]").dropdown(); }, 500);
});
