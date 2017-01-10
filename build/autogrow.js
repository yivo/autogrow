(function() {
  var hasProp = {}.hasOwnProperty;

  (function(factory) {
    var root;
    root = typeof self === 'object' && self !== null && self.self === self ? self : typeof global === 'object' && global !== null && global.global === global ? global : void 0;
    if (typeof define === 'function' && typeof define.amd === 'object' && define.amd !== null) {
      define(['jquery', 'exports'], function($) {
        return root.Autogrow = factory(root, Math, document, Error, TypeError, $);
      });
    } else if (typeof module === 'object' && module !== null && typeof module.exports === 'object' && module.exports !== null) {
      module.exports = factory(root, Math, document, Error, TypeError, require('jquery'));
    } else {
      root.Autogrow = factory(root, Math, document, Error, TypeError, root.$);
    }
  })(function(__root__, Math, document, Error, TypeError, $) {
    var Autogrow, Helper, autogrow, escape, nl2br;
    escape = (function() {
      var iteratee, rules;
      rules = {
        '&': '&amp;',
        '<': '&lt;',
        '>': '&gt;',
        '"': '&quot;',
        "'": '&quot;'
      };
      iteratee = function(c) {
        var ref;
        return (ref = rules[c]) != null ? ref : c;
      };
      return function(text) {
        return text.replace(/[&<>"']/g, iteratee);
      };
    })();
    nl2br = function(text) {
      return text.replace(/\n\r?/g, '<br />&nbsp;');
    };
    Helper = {
      applyOriginStyles: function($origin, options) {
        var origin;
        origin = $origin[0];
        origin.style.overflowY = 'hidden';
        origin.style.minHeight = 'initial';
        if (origin.tagName === 'TEXTAREA') {
          origin.style.resize = 'none';
        }
      },
      resetOriginStyles: function($origin) {
        var origin;
        origin = $origin[0];
        origin.style.overflowY = '';
        origin.style.minHeight = '';
        origin.style.resize = '';
        origin.style.height = '';
      },
      applyMirrorStyles: function($origin, $mirror, options) {
        var mirror;
        mirror = $mirror[0];
        mirror.style.display = 'block';
        mirror.style.position = 'absolute';
        mirror.style.top = '0px';
        mirror.style.left = '-9999px';
        mirror.style.padding = $origin.css('padding');
        mirror.style.width = $origin.css('width');
        mirror.style.border = $origin.css('border');
        mirror.style.wordWrap = $origin.css('word-wrap');
        mirror.style.msWordWrap = $origin.css('-ms-word-wrap');
        mirror.style.whiteSpace = $origin.css('white-space');
        mirror.style.wordBreak = $origin.css('word-break');
        mirror.style.msWordBreak = $origin.css('-ms-word-break');
        mirror.style.lineBreak = $origin.css('line-break');
        mirror.style.overflowWrap = $origin.css('overflow-wrap');
        mirror.style.letterSpacing = $origin.css('letter-spacing');
        mirror.style.fontFamily = $origin.css('font-family');
        mirror.style.fontSize = $origin.css('font-size');
        mirror.style.fontWeight = $origin.css('font-weight');
        mirror.style.fontVariant = $origin.css('font-variant');
        mirror.style.lineHeight = $origin.css('line-height');
        mirror.style.textAlign = $origin.css('text-align');
        mirror.style.textDecoration = $origin.css('text-decoration');
      },
      textToHTML: function(text, options) {
        var extralines, html, ref;
        html = nl2br(escape(text)) + '<br />';
        extralines = Math.max((ref = options != null ? options.extralines : void 0) != null ? ref : 0, 0);
        while (extralines-- > 0) {
          html += '<br />';
        }
        return html;
      }
    };
    Autogrow = (function() {
      var methodbody, methodname;

      function Autogrow($origin, options) {
        this.validate($origin, options);
        this.$origin = $origin;
        this.options = options;
        this.origin = $origin[0];
        this.initialized = false;
        this.textareaMode = this.origin.tagName === 'TEXTAREA';
      }

      Autogrow.prototype.initialize = function() {
        var grow, remove;
        if (this.initialized) {
          return;
        }
        this.mirror = document.createElement('div');
        this.$mirror = $(this.mirror);
        this.prepareOrigin();
        this.prepareMirror();
        grow = (function(_this) {
          return function() {
            _this.grow();
          };
        })(this);
        remove = (function(_this) {
          return function() {
            _this.remove();
          };
        })(this);
        this.$origin.on('change.autogrow', grow);
        this.$origin.on('remove.autogrow', remove);
        if (this.textareaMode) {
          this.$origin.on('input.autogrow paste.autogrow keyup.autogrow focus.autogrow', grow);
        }
        this.$origin.after(this.$mirror);
        grow();
        this.initialized = true;
        return this;
      };

      Autogrow.prototype.grow = function() {
        var text;
        text = this.textareaMode ? this.origin.value : this.origin.innerText || this.origin.textContent;
        this.mirror.innerHTML = this.textToHTML(text, this.options);
        this.mirror.style.width = (this.origin.getBoundingClientRect().width) + "px";
        this.origin.style.height = (this.mirror.getBoundingClientRect().height) + "px";
      };

      Autogrow.prototype.remove = function() {
        this.$origin.removeClass('autogrow-origin');
        this.$origin.removeData('autogrow');
        this.resetOriginStyles(this.$origin);
        this.$mirror.remove();
        this.$origin = this.origin = this.$mirror = this.mirror = null;
      };

      Autogrow.prototype.prepareOrigin = function() {
        this.$origin.addClass('autogrow-origin');
        this.applyOriginStyles(this.$origin, this.options);
      };

      Autogrow.prototype.prepareMirror = function() {
        this.mirror.className = 'autogrow-mirror';
        this.applyMirrorStyles(this.$origin, this.$mirror, this.options);
      };

      Autogrow.prototype.validate = function($origin, options) {
        if (!($origin instanceof $)) {
          throw new TypeError("[Autogrow] $origin must be jQuery object but " + $origin + " given");
        }
        if ($origin[0] == null) {
          throw new TypeError("[Autogrow] Zero-length $origin given");
        }
        if ($origin.data('autogrow') != null) {
          throw new Error("[Autogrow] Autogrow has already been registered for " + $origin[0]);
        }
      };

      for (methodname in Helper) {
        if (!hasProp.call(Helper, methodname)) continue;
        methodbody = Helper[methodname];
        Autogrow.prototype[methodname] = methodbody;
      }

      return Autogrow;

    })();
    autogrow = function(origin, options) {
      var $origin, _options, instance;
      if (($origin = $(origin))[0] != null) {
        if ((instance = $origin.data('autogrow')) != null) {
          instance.grow();
        } else {
          _options = options != null ? options : {};
          if (_options.extralines == null) {
            _options.extralines = $origin.data('autogrow-extralines');
          }
          instance = new Autogrow($origin, _options);
          $origin.data('autogrow', instance);
          instance.initialize();
        }
        return instance;
      }
    };
    $.fn.autogrow = function(options) {
      var el, i, len, ref;
      ref = this;
      for (i = 0, len = ref.length; i < len; i++) {
        el = ref[i];
        autogrow(el, options);
      }
      return this;
    };
    return {
      initialize: autogrow,
      nl2br: nl2br,
      VERSION: '1.1.1'
    };
  });

}).call(this);
