escape = do ->
  regex = /[&<>"]/g
  rules =
    '&': '&amp;'
    '<': '&lt;'
    '>': '&gt;'
    '"': '&quot;'
  iteratee = (c) -> rules[c] ? c
  (text) -> text.replace(regex, iteratee)

nl2br = (text) -> text.replace(/\n\r?/g, '<br>&nbsp;')

createMirror = -> $(document.createElement('div'))

styleBase = ($base) ->
  base                 = $base[0]
  base.style.overflowY  = 'hidden'
  base.style.minHeight = 'initial'
  if $base.is('textarea')
    base.style.resize = 'none'
  $base

styleMirror = ($mirror, $base) ->
  mirror                    = $mirror[0]
  mirror.style.display      = 'block'
  mirror.style.position      = 'absolute'
  mirror.style.top      = '0px'
  mirror.style.left      = '-9999px'

  mirror.style.wordWrap     = $base.css('word-wrap')
  mirror.style.msWordWrap     = $base.css('-ms-word-wrap')
  mirror.style.whiteSpace   = $base.css('white-space')
  mirror.style.wordBreak    = $base.css('word-break')
  mirror.style.msWordBreak    = $base.css('-ms-word-break')
  mirror.style.lineBreak    = $base.css('line-break')
  mirror.style.overflowWrap = $base.css('overflow-wrap')
  mirror.style.letterSpacing = $base.css('letter-spacing')

  mirror.style.padding      = $base.css('paddingTop')     + ' ' +
                              $base.css('paddingRight')   + ' ' +
                              $base.css('paddingBottom')  + ' ' +
                              $base.css('paddingLeft')
  mirror.style.width        = $base.css('width')
  mirror.style.fontFamily   = $base.css('font-family')
  mirror.style.fontSize     = $base.css('font-size')
  mirror.style.fontWeight     = $base.css('font-weight')
  mirror.style.lineHeight   = $base.css('line-height')
  mirror.style.textAlign    = $base.css('text-align')
  mirror.style.textDecoration = $base.css('text-decoration')
  mirror.style.border    = $base.css('border')

  $mirror

convertText = (text, options) ->
  t = nl2br(escape(text)) + '<br>&nbsp;'

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
  $base = $(base)

  if $base[0]?
    if (fn = $base.data('autogrow-fn'))?
      fn()
    else
      $mirror = createMirror()
      styleBase($base)
      styleMirror($mirror, $base)
      $base.after($mirror[0])
      txt     = $base.is('textarea')
      grow    = ->
        value = if txt then base.value else (base.innerText || base.textContent)

        content              = convertText(value, options)
        $mirror[0].innerHTML = content

        $mirror[0].style.width = "#{$base[0].getBoundingClientRect().width}px"

        $base[0].style.height = "#{$mirror[0].getBoundingClientRect().height}px"

        return

      $base.data('autogrow-fn', grow)

      # Bind primary grow event
      $base.on('change.autogrow', grow)

      # Bind extra events if base is textarea
      $base.on('input.autogrow paste.autogrow', grow) if txt

      # Fire the event for text already present
      grow()
  return

$.fn.autogrow = (options) ->
  autogrow(el, options) for el in this
  this

{autogrow, measure, nl2br}