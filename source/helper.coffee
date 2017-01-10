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
