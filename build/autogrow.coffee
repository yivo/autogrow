((factory) ->

  # Browser and WebWorker
  root = if typeof self is 'object' and self isnt null and self.self is self
    self

  # Server
  else if typeof global is 'object' and global isnt null and global.global is global
    global

  # AMD
  if typeof define is 'function' and typeof define.amd is 'object' and define.amd isnt null
    root.TextHeight = factory(root)
    define -> root.TextHeight

  # CommonJS
  else if typeof module is 'object' and module isnt null and
          typeof module.exports is 'object' and module.exports isnt null
    module.exports = factory(root)

  # Browser and the rest
  else
    root.TextHeight = factory(root)

  # No return value
  return

)((__root__) ->
  escape = do ->
    regex = /[&<>"]/g
    rules =
      '&': '&amp;'
      '<': '&lt;'
      '>': '&gt;'
      '"': '&quot;'
    iteratee = (c) -> rules[c] ? c
    (text) -> text.replace(regex, iteratee)
  
  nl2br = (text) -> text.replace(/\n\r?/g, '<br>')
  
  createMirror = -> $(document.createElement('div'))
  
  styleBase = ($base) ->
    base                 = $base[0]
    base.style.overflow  = 'hidden'
    if $base.is('textarea')
      base.style.resize    = 'none'
      base.style.minHeight = base.rows + 'em'
    $base
  
  styleMirror = ($mirror, $base) ->
    mirror                    = $mirror[0]
    mirror.style.display      = 'none'
    mirror.style.wordWrap     = $base.css('word-wrap')
    mirror.style.whiteSpace   = $base.css('white-space')
    mirror.style.wordBreak    = $base.css('word-break')
    mirror.style.overflowWrap = $base.css('overflow-wrap')
    mirror.style.padding      = $base.css('paddingTop')     + ' ' +
                                $base.css('paddingRight')   + ' ' +
                                $base.css('paddingBottom')  + ' ' +
                                $base.css('paddingLeft')
    mirror.style.width        = $base.css('width')
    mirror.style.fontFamily   = $base.css('font-family')
    mirror.style.fontSize     = $base.css('font-size')
    mirror.style.lineHeight   = $base.css('line-height')
    mirror.style.textAlign    = $base.css('text-align')
    $mirror
  
  convertText = (text, options) ->
    t =        if text? then nl2br(escape(text)) else ''
    t += '_'   if t.length is 0 or /<br>$/.test(t)
    t += '\n_' if options?.padding
    t
  
  $body = null
  measure = (text, base, options) ->
    $base   = $(base)
    $mirror = $base.data('autogrow-mirror')
  
    if $mirror?
      styleMirror($mirror, $base)
    else
      $mirror = styleMirror(createMirror(), $base)
      $base.data('autogrow-mirror', $mirror)
  
    $body ?= $(document.body)
    $body.append($mirror)
    content              = convertText(text, options)
    $mirror[0].innerHTML = content
    height               = $mirror.height()
    $mirror.detach()
    height
  
  autogrow = (base, options) ->
    $base   = styleBase($(base))
    $mirror = styleMirror(createMirror(), $base)
    $base.after($mirror[0])
    value   = if $base.is('textarea') then -> base.value else -> $base.text()
    grow    = ->
      content              = convertText(value(), options)
      $mirror[0].innerHTML = content
      $base.height($mirror.height())
      return
  
    # Bind primary grow event
    $base.on('change.autogrow', grow)
  
    # Bind extra events if base is textarea
    $base.on('input.autogrow paste.autogrow', grow) if $base.is('textarea')
  
    # Fire the event for text already present
    grow(); return
  
  $.fn.autogrow = (options) ->
    autogrow(el, options) for el in this
    this
  
  {autogrow, measure, nl2br}
)