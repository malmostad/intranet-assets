jQuery ($) ->
  if "ontouchstart" of window
    $("body").addClass "touch"
