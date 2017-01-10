autogrow = (origin, options) ->
  if ($origin = $(origin))[0]?
    if (instance = $origin.data('autogrow'))?
      instance.grow()
    else
      _options = options ? {}
      _options.extralines ?= $origin.data('autogrow-extralines')
      instance = new Autogrow($origin, _options)
      $origin.data('autogrow', instance)
      instance.initialize()
    instance
    
$.fn.autogrow = (options) ->
  autogrow(el, options) for el in this
  this
