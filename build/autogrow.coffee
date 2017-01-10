((factory) ->

  # Browser and WebWorker
  root = if typeof self is 'object' and self isnt null and self.self is self
    self

  # Server
  else if typeof global is 'object' and global isnt null and global.global is global
    global

  # AMD
  if typeof define is 'function' and typeof define.amd is 'object' and define.amd isnt null
    define ['jquery', 'exports'], ($) ->
      root.Autogrow = factory(root, Math, document, Error, TypeError, $)

  # CommonJS
  else if typeof module is 'object' and module isnt null and
          typeof module.exports is 'object' and module.exports isnt null
    module.exports = factory(root, Math, document, Error, TypeError, require('jquery'))

  # Browser and the rest
  else
    root.Autogrow = factory(root, Math, document, Error, TypeError, root.$)

  # No return value
  return

)((__root__, Math, document, Error, TypeError, $) ->
  escape = do ->
    rules =
      '&': '&amp;'
      '<': '&lt;'
      '>': '&gt;'
      '"': '&quot;'
      "'": '&quot;'
    iteratee = (c) -> rules[c] ? c
    (text) -> text.replace(/[&<>"']/g, iteratee)
  
  nl2br = (text) -> text.replace(/\n\r?/g, '<br />&nbsp;')
  
  Helper =
    applyOriginStyles: ($origin, options) ->
      origin                 = $origin[0]
      origin.style.overflowY = 'hidden'
      origin.style.minHeight = 'initial'
      origin.style.resize    = 'none' if origin.tagName is 'TEXTAREA'
      return
  
    resetOriginStyles: ($origin) ->
      origin                 = $origin[0]
      origin.style.overflowY = ''
      origin.style.minHeight = ''
      origin.style.resize    = ''
      origin.style.height    = ''
      return
      
    applyMirrorStyles: ($origin, $mirror, options) ->
      mirror                      = $mirror[0]
  
      mirror.style.display        = 'block'
      mirror.style.position       = 'absolute'
      mirror.style.top            = '0px'
      mirror.style.left           = '-9999px'
  
      mirror.style.padding        = $origin.css('padding')
      mirror.style.width          = $origin.css('width')
      mirror.style.border         = $origin.css('border')
  
      mirror.style.wordWrap       = $origin.css('word-wrap')
      mirror.style.msWordWrap     = $origin.css('-ms-word-wrap')
      mirror.style.whiteSpace     = $origin.css('white-space')
      mirror.style.wordBreak      = $origin.css('word-break')
      mirror.style.msWordBreak    = $origin.css('-ms-word-break')
      mirror.style.lineBreak      = $origin.css('line-break')
      mirror.style.overflowWrap   = $origin.css('overflow-wrap')
      mirror.style.letterSpacing  = $origin.css('letter-spacing')
  
      mirror.style.fontFamily     = $origin.css('font-family')
      mirror.style.fontSize       = $origin.css('font-size')
      mirror.style.fontWeight     = $origin.css('font-weight')
      mirror.style.fontVariant    = $origin.css('font-variant')
      mirror.style.lineHeight     = $origin.css('line-height')
  
      mirror.style.textAlign      = $origin.css('text-align')
      mirror.style.textDecoration = $origin.css('text-decoration')
      return
      
    textToHTML: (text, options) ->
      html = nl2br(escape(text)) + '<br />'
  
      extralines = Math.max(options?.extralines ? 0, 0)
      html += '<br />' while extralines-- > 0
  
      html
  
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
  
  
  {initialize: autogrow, nl2br, VERSION: '1.1.1'}
)