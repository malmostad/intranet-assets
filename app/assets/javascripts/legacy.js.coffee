jQuery ($) ->
  # For missing placeholder support (IE9)
  unless 'placeholder' in document.createElement('input')
    $('.malmo-form [placeholder]').focus ->
      if $(@).val() is $(@).attr('placeholder')
        $(@).val('')
        $(@).removeClass('placeholder')
    .blur ->
      if $(@).val() is '' or $(@).val() is $(@).attr('placeholder')
        $(@).addClass('placeholder')
        $(@).val($(@).attr('placeholder'))

    $('[placeholder]').parents('form').submit ->
      $(@).find('[placeholder]').each ->
        if $(@).val() is $(@).attr('placeholder')
          $(@).val('')
