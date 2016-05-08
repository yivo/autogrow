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
      return text.replace(/\n\r?/g, '<br>');
    };
    createMirror = function() {
      return $(document.createElement('div'));
    };
    styleBase = function($base) {
      var base;
      base = $base[0];
      base.style.overflow = 'hidden';
      if ($base.is('textarea')) {
        base.style.resize = 'none';
        base.style.minHeight = base.rows + 'em';
      }
      return $base;
    };
    styleMirror = function($mirror, $base) {
      var mirror;
      mirror = $mirror[0];
      mirror.style.display = 'none';
      mirror.style.wordWrap = $base.css('word-wrap');
      mirror.style.whiteSpace = $base.css('white-space');
      mirror.style.wordBreak = $base.css('word-break');
      mirror.style.overflowWrap = $base.css('overflow-wrap');
      mirror.style.padding = $base.css('paddingTop') + ' ' + $base.css('paddingRight') + ' ' + $base.css('paddingBottom') + ' ' + $base.css('paddingLeft');
      mirror.style.width = $base.css('width');
      mirror.style.fontFamily = $base.css('font-family');
      mirror.style.fontSize = $base.css('font-size');
      mirror.style.lineHeight = $base.css('line-height');
      mirror.style.textAlign = $base.css('text-align');
      return $mirror;
    };
    convertText = function(text, options) {
      var t;
      t = text != null ? nl2br(escape(text)) : '';
      if (t.length === 0 || /<br>$/.test(t)) {
        t += '_';
      }
      if (options != null ? options.padding : void 0) {
        t += '\n_';
      }
      return t;
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
      var $base, $mirror, grow, value;
      $base = styleBase($(base));
      $mirror = styleMirror(createMirror(), $base);
      $base.after($mirror[0]);
      value = $base.is('textarea') ? function() {
        return base.value;
      } : function() {
        return $base.text();
      };
      grow = function() {
        var content;
        content = convertText(value(), options);
        $mirror[0].innerHTML = content;
        $base.height($mirror.height());
      };
      $base.on('change.autogrow', grow);
      if ($base.is('textarea')) {
        $base.on('input.autogrow paste.autogrow', grow);
      }
      grow();
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
