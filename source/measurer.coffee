class Measurer
  constructor: ($origin) ->
    @validate($origin)
    @$origin          = $origin
    @origin           = $origin[0]
    @mirror           = document.createElement('div')
    @$mirror          = $(@mirror)
    @mirror.className = 'autogrow-mirror'
    @applyMirrorStyles(@$origin, @$mirror)

  measure: (text) ->
    @mirror.innerHTML = @textToHTML(text)
    document.body.appendChild(@mirror)
    height = @mirror.getBoundingClientRect().height
    @mirror.parentNode?.removeChild(@mirror)
    height

  validate: ($origin, options) ->
    unless $origin instanceof $
      throw new Error("TextHeight.Measurer: $origin must be jQuery object but #{$origin} given")
    unless $origin[0]?
      throw new Error("TextHeight.Measurer: zero-length $origin given")
    if $origin.data('text-height-measurer')?
      throw new Error("TextHeight.Measurer: already created for #{$origin[0]}")
    return
