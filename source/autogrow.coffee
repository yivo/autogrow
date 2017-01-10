class Autogrow
  constructor: ($origin, options) ->
    @validate($origin, options)
    @$origin      = $origin
    @options      = options
    @origin       = $origin[0]
    @initialized  = false
    @textareaMode = @origin.tagName is 'TEXTAREA'

  initialize: ->
    return if @initialized

    @mirror  = document.createElement('div')
    @$mirror = $(@mirror)

    @prepareOrigin()
    @prepareMirror()

    grow   = => @grow()  ; return
    remove = => @remove(); return

    # Bind general change event (useful when origin isn't textarea)
    @$origin.on 'change.autogrow', grow

    # On origin removal remove mirror
    @$origin.on 'remove.autogrow', remove
      
    # Bind extra events if origin is textarea
    if @textareaMode
      @$origin.on 'input.autogrow paste.autogrow keyup.autogrow focus.autogrow', grow

    @$origin.after(@$mirror)

    # Fire the event for text already present
    grow()

    @initialized = true

    this

  grow: ->
    text = if @textareaMode then @origin.value else (@origin.innerText || @origin.textContent)
    @mirror.innerHTML    = @textToHTML(text, @options)
    @mirror.style.width  = "#{@origin.getBoundingClientRect().width}px"
    @origin.style.height = "#{@mirror.getBoundingClientRect().height}px"
    return

  remove: ->
    @$origin.removeClass('autogrow-origin')
    @$origin.removeData('autogrow')
    @resetOriginStyles(@$origin)
    @$mirror.remove()
    @$origin = @origin = @$mirror = @mirror = null
    return

  prepareOrigin: ->
    @$origin.addClass('autogrow-origin')
    @applyOriginStyles(@$origin, @options)
    return

  prepareMirror: ->
    @mirror.className = 'autogrow-mirror'
    @applyMirrorStyles(@$origin, @$mirror, @options)
    return

  validate: ($origin, options) ->
    unless $origin instanceof $
      throw new TypeError("[Autogrow] $origin must be jQuery object but #{$origin} given")
    unless $origin[0]?
      throw new TypeError("[Autogrow] Zero-length $origin given")
    if $origin.data('autogrow')?
      throw new Error("[Autogrow] Autogrow has already been registered for #{$origin[0]}")
    return

  for own methodname, methodbody of Helper
    this::[methodname] = methodbody
