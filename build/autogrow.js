(function() {
  (function(factory) {
    var root;
    root = typeof self === 'object' && self !== null && self.self === self ? self : typeof global === 'object' && global !== null && global.global === global ? global : void 0;
    if (typeof define === 'function' && typeof define.amd === 'object' && define.amd !== null) {
      root.TextHeight = factory(root);
      define(function() {
        return root.TextHeight;
      });
    } else if (typeof module === 'object' && module !== null && typeof module.exports === 'object' && module.exports !== null) {
      module.exports = factory(root);
    } else {
      root.TextHeight = factory(root);
    }
  })(function(__root__) {
    var $body, autogrow, convertText, createMirror, escape, measure, nl2br, styleBase, styleMirror;
    escape = (function() {
      var iteratee, regex, rules;
      regex = /[&<>"]/g;
      rules = {
        '&': '&amp;',
        '<': '&lt;',
        '>': '&gt;',
        '"': '&quot;'
      };
      iteratee = function(c) {
        var ref;
        return (ref = rules[c]) != null ? ref : c;
      };
      return function(text) {
        return text.replace(regex, iteratee);
      };
    })();
    nl2br = function(text) {
      return text.replace(/\n\r?/g, '<br>&nbsp;');
    };
    createMirror = function() {
      return $(document.createElement('div'));
    };
    styleBase = function($base) {
      var base;
      base = $base[0];
      base.style.overflowY = 'hidden';
      base.style.minHeight = 'initial';
      if ($base.is('textarea')) {
        base.style.resize = 'none';
      }
      return $base;
    };
    styleMirror = function($mirror, $base) {
      var mirror;
      mirror = $mirror[0];
      mirror.style.display = 'block';
      mirror.style.position = 'absolute';
      mirror.style.top = '0px';
      mirror.style.left = '-9999px';
      mirror.style.wordWrap = $base.css('word-wrap');
      mirror.style.msWordWrap = $base.css('-ms-word-wrap');
      mirror.style.whiteSpace = $base.css('white-space');
      mirror.style.wordBreak = $base.css('word-break');
      mirror.style.msWordBreak = $base.css('-ms-word-break');
      mirror.style.lineBreak = $base.css('line-break');
      mirror.style.overflowWrap = $base.css('overflow-wrap');
      mirror.style.letterSpacing = $base.css('letter-spacing');
      mirror.style.padding = $base.css('paddingTop') + ' ' + $base.css('paddingRight') + ' ' + $base.css('paddingBottom') + ' ' + $base.css('paddingLeft');
      mirror.style.width = $base.css('width');
      mirror.style.fontFamily = $base.css('font-family');
      mirror.style.fontSize = $base.css('font-size');
      mirror.style.fontWeight = $base.css('font-weight');
      mirror.style.lineHeight = $base.css('line-height');
      mirror.style.textAlign = $base.css('text-align');
      mirror.style.textDecoration = $base.css('text-decoration');
      mirror.style.border = $base.css('border');
      return $mirror;
    };
    convertText = function(text, options) {
      var t;
      return t = nl2br(escape(text)) + '<br>&nbsp;';
    };
    $body = null;
    measure = function(text, base, options) {
      var $base, $mirror, content, height;
      $base = $(base);
      $mirror = $base.data('autogrow-mirror');
      if ($mirror != null) {
        styleMirror($mirror, $base);
      } else {
        $mirror = styleMirror(createMirror(), $base);
        $base.data('autogrow-mirror', $mirror);
      }
      if ($body == null) {
        $body = $(document.body);
      }
      $body.append($mirror);
      content = convertText(text, options);
      $mirror[0].innerHTML = content;
      height = $mirror.height();
      $mirror.detach();
      return height;
    };
    autogrow = function(base, options) {
      var $base, $mirror, fn, grow, txt;
      $base = $(base);
      if ($base[0] != null) {
        if ((fn = $base.data('autogrow-fn')) != null) {
          fn();
        } else {
          $mirror = createMirror();
          styleBase($base);
          styleMirror($mirror, $base);
          $base.after($mirror[0]);
          txt = $base.is('textarea');
          grow = function() {
            var content, value;
            value = txt ? base.value : base.innerText || base.textContent;
            content = convertText(value, options);
            $mirror[0].innerHTML = content;
            $mirror[0].style.width = ($base[0].getBoundingClientRect().width) + "px";
            $base[0].style.height = ($mirror[0].getBoundingClientRect().height) + "px";
          };
          $base.data('autogrow-fn', grow);
          $base.on('change.autogrow', grow);
          if (txt) {
            $base.on('input.autogrow paste.autogrow', grow);
          }
          grow();
        }
      }
    };
    $.fn.autogrow = function(options) {
      var el, i, len;
      for (i = 0, len = this.length; i < len; i++) {
        el = this[i];
        autogrow(el, options);
      }
      return this;
    };
    return {
      autogrow: autogrow,
      measure: measure,
      nl2br: nl2br
    };
  });

}).call(this);
