autogrow = (origin, options) ->
  return unless ($origin = $(origin))[0]?
  if (instance = $origin.data('autogrow'))?
    instance.grow()
  else
    _options = options ? {}
    _options.extralines ?= $origin.data('autogrow-extralines')
    $origin.data('autogrow', new Autogrow($origin, _options).initialize())
  return

$.fn.autogrow = (options) ->
  autogrow(el, options) for el in this
  this

measure = (text, origin) ->
  if ($origin = $(origin))[0]?
    unless (instance = $origin.data('text-height-measurer'))?
      instance = new Measurer($origin)
      $origin.data('text-height-measurer', instance)
    instance.measure(text)

for own methodname, methodbody of Helper
  Autogrow::[methodname] = methodbody
  Measurer::[methodname] = methodbody
