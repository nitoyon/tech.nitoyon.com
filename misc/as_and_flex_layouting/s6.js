// S6
// SSSSSS created by amachang

if (typeof window.s6 != 'undefined') {
    delete window.s6;
}
var s6 = {};

s6.defaultStyles = {

    '.s6': {
        position: 'absolute',
        margin: 0,
        padding: 0,
        border: 0,
        overflow: 'hidden'
    },

    '.s6.mac': {
        fontFamily: "'ヒラギノ角ゴ Pro W3','Hiragino Kaku Gothic Pro',sans-serif"
    },

    '.s6.win': {
        fontFamily: "'ＭＳ Ｐゴシック',sans-serif"
    },

    '.s6 .page': {
        position: 'absolute',
        height: '100%',
        width: '100%',
        margin: 0,
        padding: 0,
        border: 0,
        overflow: 'hidden',
        lineHeight: 1
    },

    '.s6 .page.default .element': {
        lineHeight: '1.5',
        position: 'relative',
        zIndex: '100'
    },

    '.s6 .page.default h1.element': {
        margin: '20% 5% 5% 5%',
        fontSize: '110%'
    },

    '.s6 .page.default h2.element': {
        margin: '5%'
    },

    '.s6 .page.default h3.element': {
        margin: '2% 5% 2% 5%'
    },

    '.s6 .page.default ul.element': {
        margin: '5% 5% 5% 10%',
        fontSize: '80%'
    },

    '.s6 .page.default ol.element': {
        margin: '5% 5% 5% 10%',
        fontSize: '80%'
    },

    '.s6 .page.default dl.element': {
        margin: '5% '
    },

    '.s6 .page.default dl.element dt': {
        margin: '0%',
        fontSize: '80%'
    },

    '.s6 .page.default dl.element dd': {
        margin: '0% 0% 0% 10%',
        fontSize: '80%'
    },

    '.s6 .page.default p.element': {
        margin: '5%',
        fontSize: '80%'
    },

    '.s6 .page.default address.element': {
        margin: '10% 5% 5% 5%',
        fontSize: '60%',
        textAlign: 'right'
    },

    // FIXME: この色の部分は後でテーマとマージ
    '.s6 .page.default pre.element': {
        fontSize: '50%',
        padding: '1%',
        borderTop: '0.6em solid #666',
        borderBottom: '0.6em solid #666',
        background: 'black'
    },

    // FIXME: この色の部分は後でテーマとマージ
    '.s6 .page.default pre.element strong': {
        color: 'yellow'
    },

    // FIXME: この色の部分は後でテーマとマージ
    '.s6 .page.takahashi .element a': {
        color: 'yellow'
    },
 
    // FIXME: この色の部分は後でテーマとマージ
    '.s6 .page.takahashi .element a:focus': {
        outline: 'none'
    },

    '.s6 .page.takahashi .element': {
        position: 'absolute',
        zIndex: '100',
        whiteSpace: 'nowrap',
        width: '100%',
        textAlign: 'center',
        top: '45%'
    },

    '.s6 .page.custom .element': {
        position: 'absolute',
        zIndex: '100',
        whiteSpace: 'nowrap'
    },

    '.s6 .index.page .inner.s6': {
        height: '100%',
        width: '100%',
        margin: '0.75% 1%'
    },

    // IndexPage 内に格納されたページのスタイル
    '.s6 .index.page .inner.s6 .page .wrapper': {
        fontSize: '18%',
        height: '18%',
        width: '18%',
        margin: '0.6% 0.8%',
        styleFloat: 'left',
        cssFloat: 'left',
        position: 'relative'
    },

    // IndexPage 内に格納されたページのスタイル
    '.s6 .index.page .inner.s6 .page .wrapper .page': {
        top: '4%',
        left: '4%',
        width: '92%',
        height: '92%'
    },

    // ie 6 が > に対応していないためしょうがなく
    '.s6 .page *': {
        fontSize: '100%',
        fontWeight: 'normal',
        fontStyle: 'normal',
        margin: 0,
        padding: 0,
        border: 0
    }

};

// FIXME: この実装は良くない。
// テーマが与えられると要素にクラスが設定されるようにあとで変更
s6.themas = {
    normal: {
        styles: {
            background: {
                backgroundColor: 'black'
            },
            presentation: {
                backgroundColor: 'black',
                color: 'white'
            },
            page: {
                backgroundColor: '#21426F',
                backgroundImage: 'url(background.gif)'
            }
        }
    }
};

s6.transitions = {

    sinoidal: {
        // y = 0.5 - cos(πx)/2
        asc: function(x) {
            return 0.5 - Math.cos(x * Math.PI) / 2;
        },
        // y = 0.5 + cos(πx)/2
        desc: function(x) {
            return 0.5 + Math.cos(x * Math.PI) / 2;
        }
    },

    lenear: {
        // y = x
        asc: function(x) {
            return x;
        },

        // y = 1 - x
        desc: function(x) {
            return 1 - x;
        }
    }
};

s6.PageEffectSlideConstructor = function(from) {
    this.from = from;
    switch(from) {
        case 'right' : this.to = 'left';   break;
        case 'left'  : this.to = 'right';  break;
        case 'top'   : this.to = 'bottom'; break;
        case 'bottom': this.to = 'top';    break;
    }
};
s6.PageEffectSlideConstructor.prototype = {
    setup: function ___slideSetup(
        pageEffect, x, data,
        toPage, toElement, toStyle,
        fromPage, fromElement, fromStyle
    ) {
    },
    update: function ___slideUpdate(
        pageEffect, x, data,
        toPage, toElement, toStyle,
        fromPage, fromElement, fromStyle
    ) {
        toStyle[pageEffect.to] = (1 - x) * 100 + '%';
        fromStyle[pageEffect.from] = x * 100 + '%';
    },
    teardown: function ___slideTeardown(
        pageEffect, x, data,
        toPage, toElement, toStyle,
        fromPage, fromElement, fromStyle
    ) {
        toStyle[pageEffect.to] = '';
        fromStyle[pageEffect.from] = '';
    }
};

// this はプレゼンテーションオブジェクトとなる
s6.pageEffects = {
    slide: new s6.PageEffectSlideConstructor('right'),
    fade: {
        setup: function ___fadeSetup(
            pageEffect, x, data,
            toPage, toElement, toStyle,
            fromPage, fromElement, fromStyle
        ) {
            toStyle.zIndex = '100';
            fromStyle.zIndex = '200';
        },
        update: function ___fadeUpdate(
            pageEffect, x, data,
            toPage, toElement, toStyle,
            fromPage, fromElement, fromStyle
        ) {
            if (s6.uai.ie) {
                fromStyle.filter = 'alpha(opacity=' + (1 - x) * 100 + ')';
            }
            else {
                fromStyle.opacity = 1 - x;
            }
        },
        teardown: function ___fadeTeardown(
            pageEffect, x, data,
            toPage, toElement, toStyle,
            fromPage, fromElement, fromStyle
        ) {
            toStyle.zIndex = '';
            fromStyle.zIndex = '';
            if (s6.uai.ie) {
                fromStyle.filter = '';
            }
            else {
                fromStyle.opacity = '';
            }
        }
    },
    fadeScaleFromUp: {
        setup: function ___fadeScaleFromUpSetup(
            pageEffect, x, data,
            toPage, toElement, toStyle,
            fromPage, fromElement, fromStyle
        ) {
            toStyle.zIndex = '200';
            fromStyle.zIndex = '100';
            if (!s6.uai.ie && !s6.uai.opera) {
                toStyle.height = this.height / this.fontSize + 'em';
                toStyle.width = this.width / this.fontSize + 'em';
            }
        },
        update: function ___fadeScaleFromUpUpdate(
            pageEffect, x, data,
            toPage, toElement, toStyle,
            fromPage, fromElement, fromStyle
        ) {
            
            if (s6.uai.ie || s6.uai.opera) {
                toStyle.width = (1 + (1 - x)) * 100 + '%';
                toStyle.height = (1 + (1 - x)) * 100 + '%';
            }
            toStyle.fontSize = (1 + (1 - x)) * 100 + '%';
            toStyle.top = - 50 + 50 * x + '%';
            toStyle.left = - 50 + 50 * x + '%';
            if (s6.uai.ie) {
                toStyle.filter = 'alpha(opacity=' + x * 100 + ')';
            }
            else {
                toStyle.opacity = x;
            }
        },
        teardown: function ___fadeScaleFromUpTeardown(
            pageEffect, x, data,
            toPage, toElement, toStyle,
            fromPage, fromElement, fromStyle
        ) {
            toStyle.zIndex = '';
            fromStyle.zIndex = '';
            toStyle.height = '';
            toStyle.width = '';
            toStyle.fontSize = '';
            toStyle.top = '';
            toStyle.left = '';
            if (s6.uai.ie) {
                toStyle.filter = '';
            }
            else {
                toStyle.opacity = '';
            }
        }
    },
    fadeScale: {
        setup: function ___fadeScaleSetup(
            pageEffect, x, data,
            toPage, toElement, toStyle,
            fromPage, fromElement, fromStyle
        ) {
            toStyle.zIndex = '100';
            fromStyle.zIndex = '200';
            fromStyle.height = this.height / this.fontSize + 'em';
            fromStyle.width = this.width / this.fontSize  + 'em';
        },
        update: function ___fadeScaleUpdate(
            pageEffect, x, data,
            toPage, toElement, toStyle,
            fromPage, fromElement, fromStyle
        ) {
            var dx = 1 - x;
            var dw = (1 - dx) / 2;
            var px = dx * 100;
            var sx = px + '%';
            var sw = dw * 100 + '%';
            fromStyle.fontSize = sx;
            fromStyle.left = sw;
            fromStyle.top = sw; 
            if (s6.uai.ie) {
                fromStyle.filter = 'alpha(opacity=' + px + ')';
            }
            else {
                fromStyle.opacity = dx;
            }
        },
        teardown: function ___fadeScaleTeardown(
            pageEffect, x, data,
            toPage, toElement, toStyle,
            fromPage, fromElement, fromStyle
        ) {
            toStyle.zIndex = '';
            fromStyle.zIndex = '';
            fromStyle.height = '';
            fromStyle.width = '';
            fromStyle.left = '';
            fromStyle.top = '';
            fromStyle.fontSize = '';
            if (s6.uai.ie) {
                fromStyle.filter = '';
            }
            else {
                fromStyle.opacity = '';
            }
        }
    }
};

// this は Action オブジェクト
s6.actionEffects = {
    fade: {
        changeArgs_in: function(args) {
            args[1] = 0;
            args[2] = 1;
            return args;
        },
        changeArgs_out: function(args) {
            args[1] = 1;
            args[2] = 0;
            return args
        },
        update: function(actionEffect, x, data, args, element) {
            var opacity = args[1] + (args[2] - args[1]) * x;
            if (s6.uai.ie) {
                if (opacity < 0.01) {
                    element.setDisplay(false);
                    element.style.filter = '';
                }
                else if (opacity >= 0.99) {
                    element.setDisplay(true);
                    element.style.filter = '';
                }
                else {
                    element.setDisplay(true);
                    element.style.filter = 'alpha(opacity=' + opacity * 100 + ')';
                }
            }
            else {
                if (opacity < 0.01) {
                    element.setDisplay(false);
                    element.style.opacity = '';
                }
                else if (opacity >= 0.99) {
                    element.setDisplay(true);
                    element.style.opacity = '';
                }
                else {
                    element.setDisplay(true);
                    element.style.opacity = args[1] + (args[2] - args[1]) * x;
                }
            }
        }
    },
    move: {
        update: function(actionEffect, x, data, args, element) {
            var startX = args[1][0];
            var startY = args[1][1];
            var endX = args[2][0];
            var endY = args[2][1];
            element.style.left = startX + (endX - startX) * x + '%';
            element.style.top = startY + (endY - startY) * x + '%';
        }
    }
};

// オブジェクト名: uai オブジェクト
// 以下の uai オブジェクトは以下のサイトの UAIdentifier を基に作っています。
// 問題があれば教えてください。
// http://homepage2.nifty.com/magicant/sjavascript/uai-spec.html
s6.uai = new function() {

    var ua = navigator.userAgent;

    if (typeof(RegExp) == "undefined") {
        if (ua.indexOf("Opera") >= 0) {
            this.opera = true;
        } else if (ua.indexOf("Netscape") >= 0) {
            this.netscape = true;
        } else if (ua.indexOf("Mozilla/") == 0) {
            this.mozilla = true;
        } else {
            this.unknown = slide
        }
        
        if (ua.indexOf("Gecko/") >= 0) {
            this.gecko = true;
        }
        
        if (ua.indexOf("Win") >= 0) {
            this.windows = true;
        } else if (ua.indexOf("Mac") >= 0) {
            this.mac = true;
        } else if (ua.indexOf("Linux") >= 0) {
            this.linux = true;
        } else if (ua.indexOf("BSD") >= 0) {
            this.bsd = true;
        } else if (ua.indexOf("SunOS") >= 0) {
            this.sunos = true;
        }
    }
    else {
    
        /* for Trident/Tasman */
        /*@cc_on
        @if (@_jscript)
            function jscriptVersion() {
                switch (@_jscript_version) {
                    case 3.0:  return "4.0";
                    case 5.0:  return "5.0";
                    case 5.1:  return "5.01";
                    case 5.5:  return "5.5";
                    case 5.6:
                        if ("XMLHttpRequest" in window) return "7.0";
                        return "6.0";
                    case 5.7:
                        return "7.0";
                    default:   return true;
                }
            }
            if (@_win16 || @_win32 || @_win64) {
                this.windows = true;
                this.trident = jscriptVersion();
            } else if (@_mac || navigator.platform.indexOf("Mac") >= 0) {
                // '@_mac' may be 'NaN' even if the platform is Mac,
                // so we check 'navigator.platform', too.
                this.mac = true;
                this.tasman = jscriptVersion();
            }
            if (match = ua.match("MSIE ?(\\d+\\.\\d+)b?;")) {
                this.ie = match[1];
            }
        @else @*/
        
        /* for AppleWebKit */
        if (match = ua.match("AppleWebKit/(\\d+(\\.\\d+)*)")) {
            this.applewebkit = match[1];
        }
        
        /* for Gecko */
        else if (typeof(Components) == "object") {
            if (match = ua.match("Gecko/(\\d{8})")) {
                this.gecko = match[1];
            } else if (navigator.product == "Gecko"
                    && (match = navigator.productSub.match("^(\\d{8})$"))) {
                this.gecko = match[1];
            }
        }
        
        /*@end @*/
        
        if (typeof(opera) == "object" && typeof(opera.version) == "function") {
            this.opera = opera.version();
        } else if (typeof(opera) == "object"
                && (match = ua.match("Opera[/ ](\\d+\\.\\d+)"))) {
            this.opera = match[1];
        } else if (this.ie) {
        } else if (match = ua.match("Safari/(\\d+(\\.\\d+)*)")) {
            this.safari = match[1];
        } else if (match = ua.match("Konqueror/(\\d+(\\.\\d+)*)")) {
            this.konqueror = match[1];
        } else if (ua.indexOf("(compatible;") < 0
                && (match = ua.match("^Mozilla/(\\d+\\.\\d+)"))) {
            this.mozilla = match[1];
            if (match = ua.match("\\([^(]*rv:(\\d+(\\.\\d+)*).*?\\)"))
                this.mozillarv = match[1];
            if (match = ua.match("Firefox/(\\d+(\\.\\d+)*)")) {
                this.firefox = match[1];
            } else if (match = ua.match("Netscape\\d?/(\\d+(\\.\\d+)*)")) {
                this.netscape = match[1];
            }
        } else {
            this.unknown = true;
        }
        
        if (ua.indexOf("Win 9x 4.90") >= 0) {
            this.windows = "ME";
        } else if (match = ua.match("Win(dows)? ?(NT ?(\\d+\\.\\d+)?|\\d+|XP|ME|Vista)")) {
            this.windows = match[2];
            if (match[3]) {
                this.winnt = match[3];
            } else switch (match[2]) {
                case "2000":   this.winnt = "5.0";  break;
                case "XP":     this.winnt = "5.1";  break;
                case "Vista":  this.winnt = "6.0";  break;
            }
        } else if (ua.indexOf("Mac") >= 0) {
            this.mac = true;
        } else if (ua.indexOf("Linux") >= 0) {
            this.linux = true;
        } else if (match = ua.match("\\w*BSD")) {
            this.bsd = match[0];
        } else if (ua.indexOf("SunOS") >= 0) {
            this.sunos = true;
        }
    }

};

// オブジェクト名: opts 関数
// 最終引数に options を使うような場合に引数をうまくマージしてくれる。
s6.opts = function(options, defaults) {
    if (!options) {
        return defaults;
    }
    for (var n in defaults) {
        if (!(n in options)) {
            options[n] = defaults[n];
        }
    }
    return options;
};

// オブジェクト名: attach 関数
// イベントの割当を行い、イベントハンドラ ID を復帰する。
// イベントハンドラ ID は、イベントの解除で使う
s6.attach = function(element, type, handler) {
    if (s6.uai.ie && type == 'keypress') {
        type = 'keydown';
    }
    if (!element['on' + type]) {
        element['on' + type] = this._handleEvent;
    }
    var events = element.__s6events__;
    if (!events) {
        events = element.__s6events__ = {};
    }
    var handlers = events[type];
    if (!handlers) {
        handlers = events[type] = [];
    }
    handlers.push(handler);
    var handlerId = this._eventCount++;
    this._events[handlerId] = {
        element: element,
        type: type,
        handler: handler
    };
    return handlerId;
};
s6._eventCount = 0;
s6._events = [];
s6._handleEvent = function(event) {
    event = event || window.event;
    if (s6.uai.ie) event.target = event.srcElement;
    var handlers = this.__s6events__[event.type];
    for (var i = 0, l = handlers.length; i < l; i ++) {
        var result = handlers[i].call(this, event);
        if (result === false) {
            s6._stopEvent(event);
            return false;
        }
    }
    return true;
};
s6._stopEvent = function(event) {
    if (s6.uai.ie) {
        event.returnValue = false;
        event.cancelBubble = true;
    }
    else {
        event.preventDefault();
        event.stopPropagation();
    }
};

// オブジェクト名: detach 関数
// イベントハンドラ ID を使ってイベントの解除を行う
s6.detach = function(handlerId) {
    var eventInfo = this._events[handlerId];
    this._detach(eventInfo.element, eventInfo.type, eventInfo.handler);
    this._events[handlerId] = null;
};
s6._detach = function(element, type, handler) {
    var events = element.__s6events__;
    var handlers = events[type];
    for (var i = 0, l = handlers.length; i < l; i ++) {
        if (handlers[i] == handler) {
            handlers.splice(i, 1);
            break;
        }
    }
    if (handlers.length == 0) {
        delete events[type];
        element['on' + type] = null;
    }
    var check = false;
    for (var n in events) {
        check = true;
        break;
    }
    if (!check) {
        element.__s6events__ = null;
    }
}

// オブジェクト名: detachAll 関数
// すべてのイベントを解放する
s6.detachAll = function() {
    for (var i = 0; i < this._events.length; i ++) {
        var eventInfo = this._events[i];
        if (eventInfo) {
            this._detach(eventInfo.element, eventInfo.type, eventInfo.handler);
            this._events[i] = null;
        }
    }
};
// 最後に全てのオブジェクトを解放する（メモリリーク対策）
s6.attach(window, 'unload', function(e) {
    s6.detachAll();
    s6.extervalAll();
});

// オブジェクト名: fire 関数
// テストなどに使う、イベントが実行された状態にかなり近い状態を作り出す。
s6._keyModifierTypes = {
    altKey: 'Alt',
    altGraphKey: 'AltGraph',
    ctrlKey: 'Control',
    metaKey: 'Meta',
    shiftKey: 'Shift'
};
s6.fire = function(element, type, options) {

    // イベントの種別によって振り分けて初期化を行う
    switch (type) {

        // Keyboard 系のイベント
        case 'keypress':
        case 'keydown':
        case 'keyup':
            var event = this._keyboardEvent(element, type, options);
            break;

        // Mouse 系のイベント
        case 'click':
        case 'mousemove':
        case 'mouseover':
        case 'mouseout':
        case 'contextmenu':
            var event = this._mouseEvent(element, type, options);
            break;

        // その他のイベント
        default:
            var event = this.opts(options, {
                type: type,
                target: element,
                srcElement: element
            });
    }

    // 残ったプロパティをマージ
    // 実際にイベントの発火シミュレーションする
    if (!event.bubbles) {
        element['on' + event.type](event);
    }
    else {
        // stopPropagation をハンドリングするために上書き
        event.stopPropagation = function() {
            this.cancelBubbles = true;
        }
        do {
            if (element['on' + event.type]) {
                element['on' + event.type](event);
            }
        } while (!event.cancelBubbles && (element = element.parentNode));

        if (!event.cancelBubbles && element != view) {
            var view = this._view(element);
            if (view['on' + event.type]) {
                view['on' + event.type](event);
            }
        }
    }
};
s6._keyboardEvent = function(element, type, options) {
    options = this.opts(options, {
        target: element,
        type: type,
        bubbles: true,
        cancelable: true,
        view: this._view(element),
        detail: 1,
        ctrlKey: false,
        altKey: false,
        shiftKey: false,
        metaKey: false,
        keyCode: 0,
        charCode: 0,
        which: undefined,
        // Safari
        altGraphKey: undefined,
        // IE
        srcElement: element,
        ctrlLeft: undefined,
        altLeft: undefined,
        shiftLeft: undefined,
        // DOM 3 Events
        keyIdentifier: undefined,
        keyLocation: undefined
    });

    // modifiersList を配列として生成
    var modifiersList = [];
    var modifierTypes = this._keyModifierTypes;
    for (var n in modifierTypes) {
        if (options[n]) {
            modifiersList.push(modifierTypes[n]);
        }
    }
    // options とマージする
    options = this.opts(options, { modifiersList: modifiersList.join(' ') });

    return options;
};
s6._mouseEvent = function(element, type, options) {
    return this.opts(options, {
        target: element,
        type: type,
        bubbles: true,
        cancelable: true,
        view: this._view(element),
        detail: 1,
        ctrlKey: false,
        altKey: false,
        shiftKey: false,
        metaKey: false,
        screenX: 0,
        screenY: 0,
        clientX: 0,
        clientY: 0,
        keyCode: 0,
        charCode: 0,
        which: undefined,
        button: 0, // 右クリックの場合は 3
        relatedTarget: element,
        // Safari
        altGraphKey: undefined,
        // IE
        offsetX: 0,
        offsetY: 0,
        x: 0,
        y: 0,
        srcElement: element,
        ctrlLeft: undefined,
        altLeft: undefined,
        shiftLeft: undefined
    });
};
s6._view = function(element) {
    var doc, view;
    if (!element) {
        return window;
    }
    else if (element.window == element) { // defaultView であるか
        return element;
    }
    else if (element.nodeType == 9 && (view = element.defaultView)) { // document であるか
        return view;
    }
    else if ((doc = element.ownerDocument) && (view = doc.defaultView)) { // 要素であれば
        return view;
    }
    else {
        return window;
    }
};

// オブジェクト名: load 関数
// DOM が構築されて描画される直前に実行されるはずの関数
// ここの部分は jQuery のソースを参考にしました。
// 何か問題があれば作者まで連絡してください。
// http://code.jquery.com/jquery-latest.js
s6.load = function(e) {
    // 二回目以降無視する or body が構築されていなければ
    // 実行しない
    if (s6._loaded || !document.body) {
        return;
    }

    // s6.attach(s6, 'ready', function(){}); 
    // というように登録することで実行できる。
    s6.fire(s6, 'ready');

    // 一回目呼ばれた場合はすべてのイベントを破棄して
    // s6._loaded フラグをたてる
    s6._loaded = true;
    var self = arguments.callee;
    if (s6.uai.ie) {
        window.detachEvent('onload', self);
    }
    else {
        if (s6.uai.gecko || s6.uai.opera) {
            document.removeEventListener('DOMContentLoaded', self, false);
        }
        else if (s6.uai.webkit && s6._webkitInitTimer) {
            clearInterval(s6._webkitInitTimer);
            s6._webkitInitTimer = null;
        }
        window.removeEventListener('load', self, false);
    }
};
// DOMContentLoaded イベントが使える場合
if (s6.uai.gecko || s6.uai.opera) {
    document.addEventListener('DOMContentLoaded', s6.load, false);
    window.addEventListener('load', s6.load, false);
}
// IE の場合は defer の script が読まれるタイミングで
else if (s6.uai.ie) {
    document.write('<script id="__s6_init" defer="true" src="//:"></script>');
    document.getElementById('__s6_init').onreadystatechange = function() {
        if (this.readyState != 'complete') {
            return;
        }
        this.parentNode.removeChild(this);
        s6.load();
    };
    window.attachEvent('onload', s6.load);
}
// WebKit の場合は setInterval で実行できるようになるまで待つ。
else if (s6.uai.applewebkit) {
    s6._webkitInitTimer = setInterval(function(){
        if (document.readyState == "loaded" || document.readyState == "complete" ) {

            clearInterval(s6._webkitInitTimer);
            s6._webkitInitTimer = null;

            s6.load();
        }
    }, 10); 
    window.addEventListener('load', s6.load, false);
}
else {
    window.addEventListener('load', s6.load, false);
}
s6.load();

// オブジェクト名: hasClass 関数
// 要素にクラスを追加する
// 無ければ追加あれば追加しない
s6.addClass = function(element, className) {
    if (!s6.hasClass(element, className)) {
        var cache = element.__s6ClassNames__;
        cache.push(className);
        element.__s6ClassName__ = element.className = cache.join(' ');
    }
}

// オブジェクト名: hasClass 関数
// 要素にクラス名があるかどうかを調べる
s6.hasClass = function(element, className) {
    var elmClassName = element.className;
    if (element.__s6ClassName__ != elmClassName || !element.__s6ClassNames__) {
        element.__s6ClassName__ = elmClassName;
        element.__s6ClassNames__ = elmClassName.split(/\s+/);
    }
    var classNames = element.__s6ClassNames__;
    for (var i = 0, l = classNames.length; i < l; i ++) {
        if (classNames[i] == className) {
            return true;
        }
    }
    return false;
};

// オブジェクト名: cstyle 関数
// ComputedStyle や currentStyle を取得する
// IE の場合 currentStyle は以下のような特性があるので注意
//  - 親要素自体が変わると変わるので注意
//  - DOM ツリーに繋がっていない場合は null となる
s6.cstyle = function(element) {
    var doc = element.ownerDocument;
    var view = doc.defaultView;
    if (view) {
        return view.getComputedStyle(element, '');
    }
    else {
        return element.currentStyle;
    }
};

// オブジェクト名: css 関数
// セレクタに指定したスタイルを適用します。
s6.css = function(selector, props, options) {
    options = this.opts(options, {
        doc: document
    });
    var uai = this.uai;

    if (typeof selector == 'string') {
    
        // 最初の一回だけは styleSheet を取得する
        var sheet = this._cssSheet;
        if (!sheet) {
            var doc = options.doc;
    
            // IE の場合は createStyleSheet 関数で一発
            if (uai.ie) {
                var sheet = doc.createStyleSheet();
                this._cssSheet = sheet;
                this._cssRules = sheet.rules;
            }
            else {
                // 一番最初の styleSheet を使ってみる。
                var sheet = this._cssSheet = document.styleSheets[0];
    
                // 一個も styleSheets が無い場合は style 要素を挿入する
                // 既存の styleSheets から取ってくる場合と比べると 10 倍のコストとなる
                if (!sheet) {
                    var styleElm = doc.createElement('style');
                    if (uai.applewebkit) {
                        styleElm.appendChild(document.createTextNode(''));
                    }
                    var heads = doc.getElementsByTagName('head');
                    if (heads) {
                        var parent = heads[0];
                    }
                    if (!parent) {
                        parent = doc.body;
                    }
                    parent.appendChild(styleElm);
                    sheet = this._cssSheet = styleElm.sheet;
                }
                this._cssRules = sheet.cssRules;
            }
            this._cssLength = this._cssRules.length;
        }
        rules = this._cssRules;
    
        if (selector in this._cssStyles) {
            var style = this._cssStyles[selector];
        }

        // selector が無ければ insertRule or addRule によって空のルールを生成し、
        // そのルールの style オブジェクトを取り出す
        else {
            if (uai.ie) {
                sheet.addRule(selector, 'dummy:0');
                this._cssLength ++;
                var addedRule = rules[this._cssLength - 1];
                var style = addedRule.style;
            }
            else {
                // 常に先頭に挿入
                sheet.insertRule(selector + '{}', this._cssLength);
                this._cssLength ++;
    
                // Safari
                if (uai.applewebkit) {
                    rules = this._cssRules = sheet.cssRules;
                    this._cssLength = rules.length;
                }
               
                // 常に先頭を取得 
                var addedRule = rules[this._cssLength - 1]; 
                var style = addedRule.style;
            }
            this._cssStyles[selector] = style;
        }
    }
    else if (selector.style) {
        var style = selector.style;
    }
    else {
        var style = selector;
    }
    for (var n in props) {
        style[n] = props[n];
    }
};
s6._cssStyles = {};

// オブジェクト名: interval 関数
// interval 処理を行う関数を登録する。
// 登録された関数は 40ms ごとに一回呼び出される。
s6.interval = function() {
    var callbacks = this._intervalCallbacks;
    var selfs = this._intervalSelfs;
    var args = this._intervalArguments;
    var uai = s6.uai;
    this._intervalCounter ++;
    var shift = Array.prototype.shift;
    if (uai.opera) {
        var nativeArguments = arguments;
        arguments = [];
        for (var i = 0, l = nativeArguments.length; i < l; i ++) {
            arguments[i] = nativeArguments[i];
        }
    }
    callbacks[this._intervalCounter] = shift.apply(arguments);
    selfs[this._intervalCounter] = shift.apply(arguments);
    args[this._intervalCounter] = arguments;
    if (!this._intervalId) {
        for (var i in callbacks) { 
            if (uai.ie) {
                this._intervalId = setInterval(this._handleIntervalIefix, s6._intervalTime);
            }
            else {
                this._intervalId = setInterval(this._handleInterval, s6._intervalTime, callbacks, selfs, args);
            }
            break;
        }
    }
    return this._intervalCounter;
};


// オブジェクト名: exterval 関数
// interval 関数によって登録された関数を削除する
s6.exterval = function(id) {
    delete this._intervalCallbacks[id];
    delete this._intervalSelfs[id];
    for (var i in this._intervalCallbacks) {
        return;
    }
    if (this._intervalId) {
        clearInterval(this._intervalId);
        this._intervalId = null;
    }
};
s6._intervalTime = 40;
s6._intervalCounter = 0;
s6._intervalCallbacks = {};
s6._intervalSelfs = {};
s6._intervalArguments = {};
s6._handleIntervalIefix = function() {
    var cbs = s6._intervalCallbacks;
    var selfs = s6._intervalSelfs;
    var args = s6._intervalArguments;
    for (var i in cbs) cbs[i].apply(selfs[i], args[i]);
};
s6._handleInterval = function(cbs, selfs, args) {
    for (var i in cbs) cbs[i].apply(selfs[i], args[i]);
};

// オブジェクト名: extervalAll 関数
// interval によって登録されている関数をすべて破棄します。
s6.extervalAll = function() {
    var callbacks = this._intervalCallbacks;
    for (var i in callbacks) {
        this.exterval(i);
    }
};

// オブジェクト名: Page コンストラクタ
// new することによって Page オブジェクトを生成する
s6.Page = function(options) {

    // 継承用のプロトタイプを生成する
    if (options && options.forPrototype) {
        return;
    }

    this.options = options = s6.opts(options, {
        doc: document,
        transition: s6.transitions.sinoidal,
        pageEffect: s6.pageEffects.fade,
        thema: s6.themas.normal,
        element: undefined,
        noIndex: false,
        styleBase: 'default'
    });

    this.noIndex = options.noIndex;

    // action 関係のプロパティ
    this.actionIndex = 0;
    this.busy = false;
    this.actionStateCache = {
        interval: [],
        element: []
    };

    var doc = this.document = options.doc;
    var elm = this.element = options.element || doc.createElement('div');
    elm.__s6Page__ = this;
    var style = this.style = elm.style;
    this.transition = options.transition;
    this.pageEffect = elm.__s6Effect__ || options.pageEffect;

    var thema = this.thema = options.thema;
    var styleValues = thema.styles.page;
    for (var n in styleValues) {
        style[n] = styleValues[n];
    }

    style.display = 'none';
    this.display = false;

    var className = elm.className;

    s6.addClass(elm, 'page');

    this.elements = [];
    var childs = elm.childNodes;
    var styles = elm.__s6Styles__ || [];
    var styleBase = elm.__s6StyleBase__;

    if (styleBase) {
        s6.addClass(elm, styleBase);
    }
    else {
        s6.addClass(elm, options.styleBase);
    }
    for (var i = 0, l = childs.length; i < l; i ++) {
        var node = childs[i];
        if (node.nodeType == 1 && node.nodeName.toLowerCase() != 'script') {
            var separator = node.__s6Separator__;
            var styleOption = styles.shift();
            this.append(new s6.PageElement({ element: node, style: styleOption }));
        }
    }

    this.actions = [];
    if (elm.__s6Actions__) {
        var actionInfos = elm.__s6Actions__;
        for (var i = 0, l = actionInfos.length; i < l; i ++) {
            this.appendAction(actionInfos[i]);
        }
    }
};

// オブジェクト名: Page プロトタイプ
// Page オブジェクトのプロトタイプ。
s6.Page.prototype = {

    // インターバル処理
    interval: function() {
        var id = s6.interval.apply(s6, arguments)
        this.actionStateCache.interval.push(id);
        return id;
    },

    // インターバル解除
    exterval: function(id) {
        var cache = this.actionStateCache.interval;
        for (var i = 0, l = cache.length; i < l; i ++) {
            if (cache[i] == id) {
                cache.splice(i, 1);
                s6.exterval(id);
                return;
            }
        }
    },

    // インターバル全解除
    extervalAll: function() {
        var cache = this.actionStateCache.interval;
        for (var i = 0, l = cache.length; i < l; i ++) {
            var id = cache.push();
            s6.exterval(id);
        }
    },

    // ページのルート要素の style.display を true|false で指定する。
    // これを使うことによって値をキャッシュしてくれる。
    // display を変更する場合は常にこの関数を使うべき
    setDisplay: function(display) {
        if (this.display == display) {
            return;
        }
        if (display) {
            this.style.display = '';
        }
        else {
            this.style.display = 'none';
        }
        this.display = display;
    },

    // プレゼンテーション開始前に
    // 自分のページの表示状態を更新する。
    prepare: function(pagePosition) {
        if (pagePosition == 0) {
            this.setDisplay(true);
        }
        else {
            this.setDisplay(false);
        }
    },

    // このページのルート要素
    cloneElement: function() {
        var element = this.element.cloneNode(true);
        if (!this.display) {
            element.style.display = '';
        }
        return element;
    },

    // プレゼンテーションに割り当てられたときに
    // Presentation オブジェクトから呼び出される。
    setPresentation: function(presentation) {
        this.presentation = presentation;
    },

    // プレゼンテーションと切り離されたときに
    // Presentation オブジェクトから呼び出される。
    deletePresentation: function(presentation) {
        if (this.presentation == presentation) {
            this.presentation = null;
        }
    },

    // ページにアクションを追加する。
    // [[1, 2], 'fade opacity', 
    appendAction: function(actions) {
        this.actions.push(new s6.ActionSet(this, actions));
    },

    // ページのアクションを実行する
    action: function() {
        this.busy = true;
        var action = this.actions[this.actionIndex];
        action.action();
    },

    // Action が終了すると
    // このメソッドが呼ばれる
    finishAction: function() {
        this.actionIndex ++;
        this.busy = false;

        // added by nitoyon
        this.pollAction();
    },

    // 次のアクションを自動実行する
    // added by nitoyon
    pollAction: function() {
        if(this.actionIndex < this.actions.length) {
            try {
                var actions = this.actions[this.actionIndex].actions;
                var arg0 = actions[0].args[0];
                if(typeof arg0 == 'object' && arg0['auto']) {
                    if(arg0['wait']) {
                        var self = this;
                        setTimeout(function(){self.action()}, arg0['wait']);
                    }
                    else {
                        this.action();
                    }
                }
            }
            catch(e){
                alert(e.toString());
            }
        }
    },

    // まだ実行していないアクションが存在すれば
    // true を返す。 !! は bool 化
    hasAction: function() {
        return !!this.actions[this.actionIndex];
    },

    // すべてのアクションを初期化する
    // すべての要素の変化を初期化する
    // たとえ、 busy であろうと途中で中断する。
    reset: function() {
        var actions = this.actions;

/*
        TODO:いる？いらない？
        for (var i = 0, l = actions.length; i < l; i ++) {
            actions[i].reset();
        }
*/

        var elements = this.elements;
        for (var i = 0, l = elements.length; i < l; i ++) {
            elements[i].reset();
        }
        this.actionIndex = 0;
        this.extervalAll();
        this.busy = false;
    },

    // PageElement 要素を追加する。
    append: function(element) {
        this.elements.push(element);
        element.setPage(this);
    }

};

// オブジェクト名: IndexPage コンストラクタ
// Page コンストラクタを拡張したもの
// Presentation の全ページのリストを作ることができる。
s6.IndexPage = function(options) {
    options = s6.opts(options, {
        styleBase: 'index'
    });

    s6.Page.apply(this, arguments);
    this.options = options = s6.opts(this.options, {
        rowCount: 5,
        presentation: undefined
    });

    this.pageElements = [];

    if (options.presentation) {
        this.setPresentation(options.presentation);
    }

    this.rowCount = options.rowCount;
    this.innerPresentation = new s6.Presentation({
        noIndexPage: true, 
        additionalClassName: 'inner', 
        basePresentation: this.presentation
    });
    this.element.appendChild(this.innerPresentation.element);
};

// オブジェクト名: IndexPage プロトタイプ
// Page プロトタイプを継承している。
// IndexPage オブジェクトのプロトタイプとなるオブジェクト。
s6.IndexPage.prototype = new s6.Page({ forPrototype: true });
s6.IndexPage.prototype.prepare = function() {
    this.createIndex();
    this.innerPresentation.start();
};
s6.IndexPage.prototype.next = function() {
    this.innerPresentation.next();
};
s6.IndexPage.prototype.prev = function() {
    this.innerPresentation.prev();
};
s6.IndexPage.prototype.attach = function(event, callback) {
    var parent = this.element;
    s6.attach(parent, event, function(e) {
        var element = e.target;
        do {
            if (element == parent) {
                return false;
            }
            else if (typeof element.__s6PageIndex__ == 'number') {
                break;
            }
        } while(element = element.parentNode);
        callback(element.__s6PageIndex__, element, element.parentNode);
        return false;
    });
};
s6.IndexPage.prototype.createIndex = function() {
    var pages = this.presentation.pages;
    var innerPresentation = this.innerPresentation;
    var innerPage, innerElement;
    var pageMaxCount = this.rowCount * this.rowCount;
    var pageElements = this.pageElements;
    var pageCount = 0;
    for (var i = 0, l = pages.length; i < l; i ++) {
        var page = pages[i];
        if (!page.noIndex) {
            if (pageCount % pageMaxCount == 0) {
                innerPage = new s6.Page({
                    styleBase: 'index',
                    pageEffect: s6.pageEffects.slide
                });
                innerPresentation.append(innerPage)
                innerElement = innerPage.element;
            }
            var pageElement = page.cloneElement()
            var wrapperElement = document.createElement('div');
            s6.addClass(wrapperElement, 'wrapper');
            wrapperElement.appendChild(pageElement);
            innerElement.appendChild(wrapperElement);
            pageElements.push(pageElement);
            pageElement.__s6PageIndex__ = i;
            pageCount ++;
        }
    }
};
s6.IndexPage.prototype.destroyIndex = function() {
    var innerPresentation = this.innerPresentation;
    innerPresentation.removeAll();
};

// オブジェクト名: PageElement コンストラクタ
// new 演算することによって、
// ページの要素上のトップレベルの要素を管理するラッパーを生成する。
s6.PageElement = function(options) {
    options = s6.opts(options, {
        element: undefined,
        style: undefined,
        tagName: 'div',
        reset: undefined
    });

    var elm = this.element = options.element || document.createElement(options.tagName);
    s6.addClass(elm, 'element');
    elm.__s6PageElement__ = this;
    var style = this.style = elm.style;
    if (options.style) {
        var styleHash = options.style;
        if (s6.uai.ie && 'opacity' in styleHash) {
            styleHash.filter = 'alpha(opacity=' + styleHash.opacity * 100 + ')';
            delete styleHash.opacity;
        }
        for (var n in styleHash) {
            style[n] = styleHash[n];
        }
    }
    if (options.reset) {
        this.resetHandler = options.reset;
    }
    this.styleCache = style.cssText;

    if (this.style.display == 'none') {
        this.display = false;
    }
    else {
        this.display = true;
    }
};

// オブジェクト名: PageElement プロトタイプ
// PageElement オブジェクトのプロトタイプとなるオブジェクト
s6.PageElement.prototype = {

    // style.display を true|false で指定する。
    // これを使うことによって値をキャッシュしてくれる。
    // display を変更する場合は常にこの関数を使うべき
    setDisplay: function(display) {
        if (this.display == display) {
            return;
        }
        if (display) {
            this.style.display = '';
        }
        else {
            this.style.display = 'none';
        }
        this.display = display;
    },

    // スタイルを設定する
    setStyle: function(styles) {
        var pageStyle = this.style;
        for (var n in styles) {
            pageStyle[n] = styles[n];
        }
    },

    // page に append した時にページ側から呼ばれる。
    setPage: function(page) {
        var elm = this.element;
        this.page = page;
        var pageElm = page.element;
        if (!(elm.parentNode == pageElm)) {
            pageElm.appendChild(elm);
        }
    },

    // interval を開始する
    // page.interval のラッパー
    interval: function() {
        var page = this.page;
        return page.interval.apply(page, arguments);
    },

    // exterval を開始する
    // page.exterval のラッパー
    exterval: function() {
        var page = this.page;
        return page.exterval.apply(page, arguments);
    },

    // elementCache を有効にする
    snapshot: function() {
        this.elementCache = this.element.cloneNode(true);
    },

    // htmlCache と styleCache を元に戻す。
    reset: function() {
        if (typeof this.elementCache != 'undefined') {
            var elm = this.element;
            var parent = elm.parentNode;
            var cache = this.elementCache;
            parent.replaceChild(cache, elm);
            this.element = cache;
            delete this.elementCache;
        }
        if (typeof this.styleCache != 'undefined') {
            var style = this.style;
            var cache = this.styleCache;
            if (style.cssText != cache) {
                style.cssText = cache;
            }
        }
        if (this.resetHandler) {
            this.resetHandler();
        }
    }
};

// オブジェクト名: Action コンストラクタ
// new することによって PageElement に対するアクションを定義する
s6.Action = function(set, elements, actionEffect, transition, args) {
    this.set = set;
    this.page = set.page;
    this.elements = elements;
    this.actionEffect = actionEffect;
    this.transition = transition;
    this.args = args;
};

// オブジェクト名: Action プロトタイプ
// Action オブジェクトのコンストラクタ。
s6.Action.prototype = {
    action: function() {
        if (this.busy) {
            return;
        }
        this.busy = true;
        // カウントを持つオブジェクト TODO: gain
        var position = new s6.IncrementalObject(this.gain);

        var page = this.page; 
        var transition = this.transition;
        var actionEffect = this.actionEffect;
        var args = this.args;
        var data = {};
        var elements = this.elements;

        this.effectId = page.interval(this.handleActionEffect, this,
            actionEffect, transition, position, data, args, elements);

        this.handleActionEffect(
            actionEffect, transition, position, data, args, elements);
    },
    handleActionEffect: function(actionEffect, transition, position, data, args, elements) {
        var pos = +position;

        var x = transition(pos);
        for (var i = 0, l = elements.length; i < l; i ++) {
            actionEffect.call(this, actionEffect, x, data, args, elements[i]);
        }
        if (pos >= 0.99) {
            this.set.finish(this);
            this.busy = false;
            if (this.effectId) {
                this.page.exterval(this.effectId);
            }
            this.effectId = null;
        }
    }
}

// オブジェクト名: ActionSet コンストラクタ
// new することによってページ内のアクションを行うためのオブジェクトを作る。
s6.ActionSet = function(page, actionInfos) {
    this.page = page;
    var pageElements = this.pageElements = page.elements;
    var actions = this.actions = [];
    for (var i = 0, l = actionInfos.length; i < l; i ++) {
        var actionInfo = actionInfos[i];

        var elementIndexes = actionInfo.shift();
        var elements = [];
        for (var j = 0, l0 = elementIndexes.length; j < l0; j ++) {
            var element = pageElements[elementIndexes[j]];
            elements.push(element);
        }

        var effectInfos = actionInfo.shift().split(/\s+/);
        var actionEffect = s6.actionEffects[effectInfos.shift()];
        var args = actionInfo;
        var transition;
        for (var j = 0, l0 = effectInfos.length; j < l0; j ++) {
            var effectInfo = effectInfos.shift();
            var argsChanger;
            // transition があれば transition を取得
            if (s6.transitions[effectInfo]) {
                transition = s6.transitions[effectInfo];
            }
            // transition じゃない場合で actionEffect に changeArgs_xxxx という関数があれば実行
            // args を補完する目的
            else if (argsChanger = actionEffect['changeArgs_' + effectInfo]) {
                args = argsChanger(args);
            }
        }

        // transition のデフォルト値は今のところ決め打ち
        transition = transition || s6.transitions.sinoidal;

        actions.push(new s6.Action(this, elements, actionEffect.update, transition.asc, args));
    }
};

// オブジェクト名: ActionSet プロトタイプ
// ActionSet オブジェクトのコンストラクタ。
s6.ActionSet.prototype = {
    action: function() {
        if (this.busy) {
            return;
        }
        this.count = 0;
        this.countEnd = this.actions.length;
        this.busy = true;
        var actions = this.actions;
        for (var i = 0, l = actions.length; i < l; i ++) {
            actions[i].action();
        }
    },
    finish: function(action) {
        if (this.busy) {
            this.count ++;
            if (this.count >= this.countEnd) {
                this.page.finishAction();
                this.count = null;
                this.countEnd = null;
                this.busy = false;
            }
        }
    }
};

// オブジェクト名: Presentation コンストラクタ
// new することによって Presentation オブジェクトを作る
s6.Presentation = function(options) {
    options = s6.opts(options, {
        doc: document,
        thema: 'normal',
        ratio: 0.75,                    // プレゼンテーションの縦横比
        width: undefined,               // 横幅、省略されなかった場合 height から求められる
        height: undefined,              // 縦幅、指定されても width が指定された場合は無視される。両方指定されなかった場合は width が 400 となる
        fontSize: 0.1,                  // height にこの値を掛けた値がベースのフォントサイズとなる
        startIndex: 0,
        noIndexPage: false,             // このオプションが true の場合、 index ページは作られません
        additionalClassName: undefined, // 追加されるクラス名です。
        basePresentation: undefined,    // ここにプレゼンが設定されている場合は、そのプレゼンから ratio, width, height, fontSize を継承
        element: undefined              // このオプションに要素が設定された場合は要素を生成しません
    });
    if (!options.width && !options.height) {
        options.width = 1000;
    }

    this.index = options.startIndex || 0;
    this.pages = [];
    this.funcPages = {};
    this.backQueue = [];

    // DOM 関連の設定
    var doc = this.document = options.doc;
    var elm = this.element = options.element || doc.createElement('div');

    // options.element で与えられた要素が body だった場合
    // あらたに、要素を生成
    if (options.element && elm.nodeName.toLowerCase() == 'body') {
        var bodyElm = elm;
        this.element = elm = document.createElement('div');
        bodyElm.appendChild(elm);
    }

    elm.__s6Presentation__ = this;
    var style = this.style = elm.style;
    var body = this.body = doc.body;

    s6.addClass(elm, 's6');
    if (s6.uai.mac) {
        s6.addClass(elm, 'mac');
    }
    else {
        s6.addClass(elm, 'win');
    }
    if (options.additionalClassName) {
        s6.addClass(elm, options.additionalClassName);
    }

    // thema の適用
    var thema = this.thema = s6.themas[options.thema];
    var styleValues = thema.styles.presentation;
    for (var n in styleValues) {
        style[n] = styleValues[n];
    }

    if (options.basePresentation) {
        var basePresentation = options.basePresentation;
        this.width = basePresentation.width;
        this.height = basePresentation.height;
        this.fontSize = basePresentation.fontSize;
        style.width = '100%';
        style.height = '100%';
        style.fontSize = '100%';
    }
    else {
        // page 内の大きさ(%, em)の基準となる値(width, height, fontSize)の設定
        if (options.width) {
            var width = this.width = options.width;
            var height = this.height = width * options.ratio;
        }
        else {
            var height = this.height = options.height;
            var width = this.width = options.height / options.ratio;
        }
        var fontSize = this.fontSize = height * options.fontSize;
        style.width = width + 'px';
        style.height = height + 'px';
        style.fontSize = fontSize + 'px';
    }

    // オプションで要素が指定された場合
    // 直下の小要素を読んで
    // page に追加する
    if (options.element) {
        var node = options.element.firstChild;

        var pages = [];
        if (node) {
            // すべての子ノードを走査
            do {
                // 要素だったら
                if (node.nodeType == 1 && node.nodeName.toLowerCase() != 'script' && !s6.hasClass(node, 's6')) {
                    pages.push(new s6.Page({ element: node , noIndex: node.__s6Separator__ }));
                }
            } while(node = node.nextSibling);
        }
        for (var i = 0, l = pages.length; i < l; i ++) {
            this.append(pages[i]);
        }
    }
    else {
        body.appendChild(elm);
    }

    // 機能ページ
    if (!options.noIndexPage) {
        var indexPage = this.funcPages.index = new s6.IndexPage({
            pageEffect: s6.pageEffects.fadeScaleFromUp,
            transition: s6.transitions.lenear,
            presentation: this
        });
        this.element.appendChild(indexPage.element);
    }

};

// オブジェクト名: Presentation プロトタイプ
// Presentation オブジェクトのプロトタイプ
s6.Presentation.prototype = {

    // 現在のページのアクションを消化する
    // もし、現在のページのアクションが無ければページを遷移させる。
    step: function() {
        var page = this.getPage(this.index);

        // Action 中だった場合
        if (page.busy) {
            return;
        }

        if (page.hasAction()) {
            page.action();
        }
        else {
            this.next();
        }
    },

    // 次のページに移動するトリガーとなる関数
    // 現在が機能ページの場合は機能ページの next を呼び出す
    next: function() {
        if (typeof this.index == 'number') {
            this.go(this.index + 1);
        }
        else {
            this.getPage(this.index).next();
        }
    },

    // 前のページに移動するトリガーとなる関数
    // 現在が機能ページの場合は機能ページの prev を呼び出す
    prev: function() {
        if (typeof this.index == 'number') {
            this.go(this.index - 1);
        }
        else {
            this.getPage(this.index).prev();
        }
    },

    // 一つ前に開いていたページに戻る
    // ブラウザの戻るボタンみたいなもの
    // 機能ページに遷移した後に戻る場合に使う
    back: function() {
        var backQueue = this.backQueue;
        if (backQueue.length) {
            this.go(this.backQueue.pop());
        }
        // push されたページをキャンセル
        this.backQueue.pop();
    },

    // 移動先のページの index を指定することで
    // ページを移動する。
    go: function(toIndex) {
        if (this.busy) {
            return;
        }
        
        var fromIndex = this.index;
        var toPage = this.getPage(toIndex);

        if (!(toPage instanceof s6.Page)) {
            return
        }

        var fromPage = this.getPage(fromIndex);

        if (fromIndex == toIndex) {
            return;
        }

        // 戻れるようにいまのページをキャッシュさせておく
        this.backQueue.push(fromIndex);

        // Effect 開始
        // 1 ページ目から 2 ページ目というように
        // 昇順にページ遷移が行われた場合は遷移先のページの
        // エフェクトが使われる
        // (ページ遷移のエフェクトは、終わるページより始まるページのものだから)
        // その逆で 2 ページ目から 1 ページ目のように
        // 降順にページ遷移が行われた場合は遷移元のページの
        // エフェクトの巻き戻しが使われる
        // (感覚として真逆に動いていないと変だから)
        if (this.getDirection(fromIndex, toIndex)) {
            // 正順にページ遷移した場合
            this.startEffect(fromPage, toPage, toPage.pageEffect, toPage.transition.asc);
        }
        else {
            // 逆順にページ遷移した場合
            this.startEffect(toPage, fromPage, fromPage.pageEffect, fromPage.transition.desc);
        }

        this.toIndex = toIndex;
        this.fromIndex = fromIndex;

        // エフェクト中は操作を無効にする
        // あとで仕様変更はあるかも
        this.busy = true;
    },

    // Effect を開始するためのインターバルの登録と
    // 最初の一タイムラインを行う。
    startEffect: function(fromPage, toPage, pageEffect, transition) {
        // カウントを持つオブジェクト
        var position = new s6.IncrementalObject();

        // イベント中に起こった現象を保存するためのキャッシュ
        var data = {};

        // 要素とスタイル
        var toElement = toPage.element;
        var toStyle = toPage.style;
        var fromElement = fromPage.element;
        var fromStyle = fromPage.style;

        // インターバルの登録
        this.effectId = s6.interval(
            this.pageEffect, this,
            pageEffect, transition, position, data,
            toPage, toElement, toStyle,
            fromPage, fromElement, fromStyle);

        // 最初の一タイムラインを実行
        this.pageEffect(
            pageEffect, transition, position, data,
            toPage, toElement, toStyle,
            fromPage, fromElement, fromStyle);
    },

    // ページ番号または機能の id からページを取り出す。
    getPage: function(i) {
        if (typeof i == 'number') {
            var page = this.pages[i];
        }
        else {
            var page = this.funcPages[i];
        }
        return page;
    },

    // ページの進む方向を決める
    // エフェクトの方向を順方向か逆方向か決める
    // 順方向だったら true
    // 逆方向だったら false を返す
    getDirection: function(from, to) {
        var fromType = typeof from;
        var toType = typeof to;

        if (fromType == 'number') {
            if (toType == 'number') {
                if (from - to < 0) {
                    return true;
                }
                else {
                    return false;
                }
            }
            else {
                return true;
            }
        }
        else {
            if (toType == 'number') {
                return false;
            }
            else {
                return true;
            }
        }
    },

    pageEffect: function(
        pageEffect, transition, position, data,
        toPage, toElement, toStyle,
        fromPage, fromElement, fromStyle
    ) {
        var pos = +position;
        var x = transition(pos);

        if (x < 0.01) {
            toPage.setDisplay(false);
            fromPage.setDisplay(true);
        }
        else if (x > 0.99) {
            toPage.setDisplay(true);
            fromPage.setDisplay(false);
        }
        else {
            toPage.setDisplay(true);
            fromPage.setDisplay(true);
            pageEffect.update.call(
                this, pageEffect, x, data,
                toPage, toElement, toStyle,
                fromPage, fromElement, fromStyle
            );
        }

        if (pos <= 0.01) {
            pageEffect.setup.call(
                this, pageEffect, x, data,
                toPage, toElement, toStyle,
                fromPage, fromElement, fromStyle
            );
        }
        else if (pos >= 0.99) {
            pageEffect.teardown.call(
                this, pageEffect, x, data,
                toPage, toElement, toStyle,
                fromPage, fromElement, fromStyle
            );
            this.pageEffectEnd();
        }
    },

    // ページエフェクトが終わると呼び出される
    pageEffectEnd: function() {
        if (this.effectId) {
            s6.exterval(this.effectId);
            this.effectId = null;
        }
        this.busy = false;
        this.index = this.toIndex;
        this.toIndex = null;
        this.getPage(this.fromIndex).reset();
        this.fromIndex = null;

        // added by nitoyon
        var page = this.getPage(this.index);
        page.pollAction();
    },

    // プレゼンテーションの開始
    start: function() {
        var index = this.index, pages = this.pages;
        for (var i = 0, l = pages.length; i < l; i ++) {
            pages[i].prepare(i - index);
        }
        for (var n in this.funcPages) {
            this.funcPages[n].prepare();
        }
    },

    // ページの追加
    append: function(page) {
        page.setPresentation(this);
        this.pages.push(page);
        var pageElement = page.element;

        // もう既にページの要素が
        // プレゼンの要素の直下にある場合
        if (!(pageElement.parentNode == this.element)) {
            this.element.appendChild(page.element);
        }
    },

    // ページの挿入
    insert: function(page, i) {
        if (typeof i == 'undefined' || i >= this.pages.length) {
            this.append(page);
        }
        else {
            page.setPresentation(this);
            var beforePage = this.pages[i];
            this.pages.splice(i, 0, page);
            this.element.insertBefore(page.element, beforePage.element);
        }
    },

    // ページの削除
    remove: function(page) {
        var pages = this.pages;
        for (var i = 0, l = pages.length; i < l; i ++) {
            if (pages[i] == page) {
                this._remove(page);
                pages.splice(i, 1);
                return;
            }
        }
    },

    // ページを削除の内部関数
    _remove: function(page) {
        page.deletePresentation(this);
        this.element.removeChild(page.element);
    },

    // すべてのページの削除
    removeAll: function() {
        var pages = this.pages;
        for(var i = 0, l = pages.length; i < l; i ++) {
            this._remove(pages.shift());
        }
    },

    // プレゼンテーションを終了する
    // すべてのイベントを解除する
    // プレゼンテーション要素を body から削除する
    end: function() {
        // TODO イベントを手動で削除
        if (this.effectId) {
            s6.exterval(this.effectId);
            this.effectId = null;
        }
        this.removeAll();
        this.body.removeChild(this.element);
    }
};

// オブジェクト名: IncrementalObject コンストラクタ
// 値を評価するたびに値が増えていくオブジェクト
s6.IncrementalObject = function(gain) {
    this.value = 0;
    this.gain = gain || (1/7);
};
s6.IncrementalObject.prototype = {
    valueOf: function() {
        var value = this.value;
        this.value += this.gain;
        return value;
    }
};

// オブジェクト名: presentation 関数
s6.presentation = function(json) {
};

// オブジェクト名: page 関数
// HTML ソース上にプレゼン用のデータを埋め込む
s6.page = function(json) {
    var scripts = document.getElementsByTagName('script');
    var currentScript = scripts[scripts.length - 1];

    var wrap = json.wrap;
    if (wrap) {
        var pElm = currentScript;
        var childs = [];
        while (pElm = pElm.previousSibling) {
            if (pElm.nodeType == 1 && pElm.nodeName.toLowerCase != 'script') {
                wrap --;
                childs.unshift(pElm);
                if (wrap == 0) {
                    break;
                }
            }
        }
        var elm = document.createElement('div');
        for (var i = 0, l = childs.length; i < l; i ++) {
            elm.appendChild(childs[i]);
        }
        currentScript.parentNode.insertBefore(elm, currentScript);
    }
    else {
        var elm = currentScript.parentNode;
    }

    var backgroundImage = json.backgroundImage;
    if (backgroundImage) {
        var imgElm = document.createElement('img');
        imgElm.src = backgroundImage;
        var imgStyle = imgElm.style;
        imgStyle.position = 'absolute';
        imgStyle.width = '100%';
        imgStyle.height = '100%';
        imgStyle.top = '0';
        imgStyle.left = '0';
        imgStyle.zIndex = '1';

        elm.appendChild(imgElm);
    }

    var backgroundWrapper = json.backgroundWrapper;
    if (typeof backgroundWrapper != 'undefined') {
        var wrpElm = document.createElement('div');
        var wrpStyle = wrpElm.style;
        wrpStyle.position = 'absolute';
        wrpStyle.background = 'black';
        wrpStyle.width = '100%';
        wrpStyle.height = '100%';
        wrpStyle.top = '0';
        wrpStyle.left = '0';
        wrpStyle.zIndex = '2';
        if (s6.uai.ie) {
            wrpStyle.filter = 'alpha(opacity=' + backgroundWrapper * 100 + ')';
        }
        else {
            wrpStyle.opacity = backgroundWrapper;
        }

        elm.appendChild(wrpElm);
    }

    var effect = json.effect;
    if (effect) {
        elm.__s6Effect__ = s6.pageEffects[effect];
    }

    var separator = json.separator;
    if (separator) {
        var parent = elm.parentNode;
        var sepElm = document.createElement('div');
        sepElm.__s6Separator__ = true;
        parent.insertBefore(sepElm, elm);
        sepElm.__s6Effect__ = s6.pageEffects[separator];
    }

    var styleBase = json.styleBase;
    if (styleBase) {
        elm.__s6StyleBase__ = styleBase;
    }

    var styles = json.styles;
    if (styles) {
        elm.__s6Styles__ = styles;
    }

    var actions = json.actions;
    if (actions) {
        actions = arguments.callee.parseActions(actions);
        elm.__s6Actions__ = actions;
    }

};

// オブジェクト名: page.parseActions 関数
s6.page.parseActions = function(actions) {
    var result = [];
    for (var i = 0, l = actions.length; i < l; i ++) {
        var actionSet = actions[i];
        var asResult = [];
        if (actionSet.length < 2 || (actionSet[0] instanceof Array && actionSet[1] instanceof Array)) {
            for (var j = 0, l0 = actionSet.length; j < l0; j ++) {
                asResult.push(arguments.callee.action(actionSet[j]));
            }
        }
        else {
            asResult.push(arguments.callee.action(actionSet))
        }
        result.push(asResult);
    }
    return result;
};
s6.page.parseActions.action = function(action) {
    if (typeof action[0] == 'number') {
        action[0] = [action[0]];
    }
    return action;
};

// 初期か処理をここに書く
s6.attach(s6, 'ready', function() {
    var styles = this.defaultStyles;
    for (var selector in styles) {
        this.css(selector, styles[selector]);
    }
});


