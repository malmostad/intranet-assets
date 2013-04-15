jQuery(document).ready(function($) {
  // Show instructions for the section
  var $toggleInstructions = $( '.box .toggle-instructions' );

  if ($toggleInstructions.length ) {
    $toggleInstructions.click( function() {
      $(this).closest('.box').find('.box-instructions').slideToggle(100);
      return false;
    });
  }
});
