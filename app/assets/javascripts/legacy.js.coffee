jQuery ($) ->
  # For missing placeholder support (IE9)
  unless 'placeholder' in document.createElement('input')
    $('.malmo-form input[placeholder]').focus ->
      if $(@).val() is $(@).attr('placeholder')
        $(@).val('')
        $(@).removeClass('placeholder')
    .blur ->
      setPlaceholder(this)

    setPlaceholder = (self) ->
      if $(self).val() is '' or $(self).val() is $(self).attr('placeholder')
        $(self).addClass('placeholder')
        $(self).val($(self).attr('placeholder'))

    # Set on load
    $('input[placeholder]').each ->
      setPlaceholder(@)

    $('input[placeholder]').parents('form').submit ->
      $(@).find('input[placeholder]').each ->
        if $(@).val() is $(@).attr('placeholder')
          $(@).val('')
