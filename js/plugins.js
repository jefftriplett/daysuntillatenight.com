// Avoid `console` errors in browsers that lack a console.
(function() {
    var method;
    var noop = function () {};
    var methods = [
        'assert', 'clear', 'count', 'debug', 'dir', 'dirxml', 'error',
        'exception', 'group', 'groupCollapsed', 'groupEnd', 'info', 'log',
        'markTimeline', 'profile', 'profileEnd', 'table', 'time', 'timeEnd',
        'timeStamp', 'trace', 'warn'
    ];
    var length = methods.length;
    var console = (window.console = window.console || {});

    while (length--) {
        method = methods[length];

        // Only stub undefined methods.
        if (!console[method]) {
            console[method] = noop;
        }
    }
}());

/* lazyload.js (c) Lorenzo Giuliani
* MIT License (http://www.opensource.org/licenses/mit-license.html)
*
* expects a list of:
* `<img src="blank.gif" data-src="my_image.png" width="600" height="400" class="lazy">`
*/
$(function() {
var $q = function(q, res){
      if (document.querySelectorAll) {
        res = document.querySelectorAll(q);
      } else {
        var d=document
          , a=d.styleSheets[0] || d.createStyleSheet();
        a.addRule(q,'f:b');
        for(var l=d.all,b=0,c=[],f=l.length;b<f;b++)
          l[b].currentStyle.f && c.push(l[b]);

        a.removeRule(0);
        res = c;
      }
      return res;
    }
  , addEventListener = function(evt, fn){
      window.addEventListener
        ? this.addEventListener(evt, fn, false)
        : (window.attachEvent)
          ? this.attachEvent('on' + evt, fn)
          : this['on' + evt] = fn;
    }
  , _has = function(obj, key) {
      return Object.prototype.hasOwnProperty.call(obj, key);
    }
  ;

function loadImage (el, fn) {
  var img = new Image()
    , src = el.getAttribute('data-src');
  img.onload = function() {
    if (!! el.parent)
      el.parent.replaceChild(img, el)
    else
      el.src = src;

    fn? fn() : null;
  }
  img.src = src;
}

function elementInViewport(el) {
  var rect = el.getBoundingClientRect()

  return (
     rect.top    >= 0
  && rect.left   >= 0
  && rect.top <= (window.innerHeight || document.documentElement.clientHeight)
  )
}

  var images = new Array()
    , query = $q('img.lazy')
    , processScroll = function(){
        for (var i = 0; i < images.length; i++) {
          if (elementInViewport(images[i])) {
            loadImage(images[i], function () {
              images.splice(i, i);
            });
          }
        };
      }
    ;
  // Array.prototype.slice.call is not callable under our lovely IE8
  for (var i = 0; i < query.length; i++) {
    images.push(query[i]);
  };

  processScroll();
  addEventListener('scroll',processScroll);

});

