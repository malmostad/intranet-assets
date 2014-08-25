jQuery ($) ->
  # Show instructions for the section
  $toggleInstructions = $('.box .toggle-instructions, .box-menu .help')

  if $toggleInstructions.length
    $toggleInstructions.click (event) ->
      event.preventDefault()
      $(@).closest('.box').find('.box-instructions').slideToggle(100)
