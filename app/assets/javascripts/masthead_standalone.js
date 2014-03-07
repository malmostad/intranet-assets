//= require jquery
//= require masthead_standalone_without_jquery

jQuery(document).ready(function($) {
  // Steal back the BS dropdown events that SV hijacked
  if ($svjq) {
    window.setTimeout(function() { $("[data-toggle=dropdown]").dropdown(); }, 500);
  }
});
