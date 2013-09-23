/* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * Portions created by the Initial Developer are Copyright (C) 2005
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *
 * Alternatively, the contents of this file may be used under the terms of
 * either the GNU General Public License Version 2 or later (the "GPL"), or
 * the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
 * in which case the provisions of the GPL or the LGPL are applicable instead
 * of those above. If you wish to allow use of your version of this file only
 * under the terms of either the GPL or the LGPL, and not to allow others to
 * use your version of this file under the terms of the MPL, indicate your
 * decision by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL or the LGPL. If you do not delete
 * the provisions above, a recipient may use your version of this file under
 * the terms of any one of the MPL, the GPL or the LGPL.
 *
 * ***** END LICENSE BLOCK ***** */


function IEerBug(){

//////////////////////////////////////////////////////////////////////////////////////////////////
// setting
var pathToScript = "";
var scriptParams = {
	debug: false,
	showJSErrors : true,
	stopJSErrors : true,
	x : 50, y : 200,
	width : 500, height : 250
};
{
	var matches;
	var scripts = document.getElementsByTagName("SCRIPT");
	for(var i = 0; i < scripts.length; i++){
		if(typeof scripts[i].src == "string"){
			if(matches = scripts[i].src.match(/^(.*)ieerbug.js(\?.*)?$/)){
				pathToScript = matches[1];
				if(matches[2] == null) break;

				var params = matches[2].substr(1).split("&");
				for(var k in params){
					if(typeof params[k] != "string" || params[k] == "") continue;
					var param = params[k].split("=", 2);

					if(param[0] in scriptParams){
						switch(typeof scriptParams[param[0]]){
							case "number":
								scriptParams[param[0]] = parseInt(param[1], 10);
								break;

							case "boolean":
								scriptParams[param[0]] = (param[1].toLowerCase() == "true");
								break;
						}
					}
				}
				break;
			}
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////
// set window.console
if(window.console && !scriptParams.debug)
{
	return;
}
window.console = new FireBugConsole();

// set error handler
function ScriptError(msg, src, num)
{
	this.errorMessage = msg;
	this.sourceName = src;
	this.lineNumber = num;
}

if(scriptParams.showJSErrors){
	window.onerror = function(message, file, num){
		var caller = arguments.callee.caller;
		//if(caller) caller = caller.caller;
		
		var s = new ScriptError(message, file, num);
		s.errorStackTrace = new StackTrace(caller);
		console.logRelay(s, "consoleError");
		return scriptParams.stopJSErrors;
	}
}


//////////////////////////////////////////////////////////////////////////////////////////////////
// console creation
function createPopupConsole(){
	var win = window.open("", "IEerBug_popup", "width=400, height=350, resizable=yes, scrollbars=yes");
	if(win == null){
		return null;
	}

	win.document.open();
	win.document.write('<html><head><link rel="stylesheet" type="text/css" href="console.css" /></head><body></body></html>');
	win.document.close();
	return win.document.body;
}

function createIframeConsole(){
	// library
	function copyStyle(elm, css){
		if(typeof elm != "object" || !elm.style || typeof css != "object"){
			return;
		}

		for(var name in css){
			if(typeof css[name] == "string"){
				if(name == "float"){
					elm.style[document.all ? "styleFloat" : "cssFloat"] = css[name];
				}
				else{
					elm.style[name] = css[name];
				}
			}
		}
	}

	function createElm(tagName, css, context){
		var e = document.createElement(tagName);
		copyStyle(e, css);
		if(typeof context == "string" && context != ""){
			e.innerHTML = context;
		}
		return e;
	}

	function px(p){return p + "px";}

	Event_observe = function(element, name, observer, useCapture) {
		useCapture = useCapture || false;
		if (element.addEventListener) {
			element.addEventListener(name, observer, useCapture);
		} else if (element.attachEvent) {
			element.attachEvent('on' + name, observer);
		}
	}

	Event_stopObserving = function(element, name, observer, useCapture) {
		useCapture = useCapture || false;
		
		if (element.removeEventListener) {
			element.removeEventListener(name, observer, useCapture);
		} else if (element.detachEvent) {
			element.detachEvent('on' + name, observer);
		}
	}

	/*** create ***/
	// try to append iframe until document.body becomes available
	function appendElement(){
		if(document && document.body){
			document.body.appendChild(iframe);
			return;
		}
		setTimeout(function(){appendElement()}, 100);
	}

	// register or unregister iframe onload event
	function setIframeOnload(elm, onload){
		if(!onload) return;

		if(elm.addEventListener) {
			//elm.addEventListener('load', onload);  // Firefox error
			elm.onload = function(){
				elm.onload = null;
				onload();
			}
		}
		else if(elm.attachEvent){ // IE doesn't call onload event
			elm.onreadystatechange = function(){
				if(elm.readyState == "loaded" || elm.readyState == "complete"){
					elm.onreadystatechange = null;
					onload();
				}
			};
		}
	}

	/*** UI ***/
	function setPosition(force){
		if(!force){
			width = width < min_width ? min_width : width;
			height = height < min_height ? min_height : height;
		}

		copyStyle(iframe, {
			left: px(x), top: px(y),
			width: px(width), height: folded ? px(title_height) : px(height)
		});

		if(divBody && divStatus){
			divBody.style.height = px(height - title_height - status_height);
			divBody.style.display = folded ? "none" : "";
			divStatus.style.display = folded ? "none" : "";
			divStatus.style.height = px(status_height);
		}
	}

	/*** Event ***/
	// init iframe event
	function setIframeEvent(){
		if(doc == null) return;
		doc.getElementById("title").onmousedown = mousedownHandler;
		doc.getElementById("resize").onmousedown = mousedownHandler;
	}

	var drag_start_x, drag_start_y;
	var param_start_x, param_start_y;
	function mousedownHandler(event){
		if(!doc || !win) return;

		var event = event || win.event
		var element = event.target || event.srcElement;

		if(element.tagName == "SPAN" && !FireBugUtils.hasClass(element, "disabled")){
			switch(element.innerHTML){
				case "Clear": FireBug.clearConsole(); break;
				case "Fold":  folded = !folded; setPosition(); break;
				case "Close": iframe.style.display = "none"; break;
				case "Console": FireBug.switchMainView("console"); break;
				case "DOM": FireBug.switchMainView("inspector"); break;
			}
			return;
		}

		drag_start_x = event.pageX || (event.clientX + (doc.documentElement.scrollLeft || doc.body.scrollLeft));
		drag_start_y = event.pageY || (event.clientY + (doc.documentElement.scrollTop || doc.body.scrollTop));
		drag_start_x += x;
		drag_start_y += y;
		Event_observe(document, "mousemove", mousemoveHandler);
		Event_observe(document, "mouseup", mouseupHandler);
		Event_observe(doc, "mousemove", mousemoveHandler);
		Event_observe(doc, "mouseup", mouseupHandler);

		isHandle = (element == divResize || element.parentNode == divResize);
		if(isHandle){
			param_start_x = width;
			param_start_y = height;
		}else{
			param_start_x = x;
			param_start_y = y;
		}
	}

	function mousemoveHandler(event){
		var event = event || window.event
		var element = event.target || event.srcElement;

		var cur_x = (event.pageX || (event.clientX + (document.documentElement.scrollLeft || document.body.scrollLeft)));
		var cur_y = (event.pageY || (event.clientY + (document.documentElement.scrollTop  || document.body.scrollTop)));
		if(element.ownerDocument == doc){
			cur_x += x;
			cur_y += y;
		}
		cur_x -= window.pageXOffset
					|| document.documentElement.scrollLeft
					|| document.body.scrollLeft
					|| 0;
		cur_y -= window.pageYOffset
					|| document.documentElement.scrollTop
					|| document.body.scrollTop
					|| 0;

		if(isHandle){
			width  = cur_x - drag_start_x + param_start_x;
			height = cur_y - drag_start_y + param_start_y;
		}
		else{
			x = cur_x - drag_start_x + param_start_x;
			y = cur_y - drag_start_y + param_start_y;
		}
		setPosition();
	}

	function mouseupHandler(event){
		var event = event || window.event
		var element = event.target || event.srcElement;

		Event_stopObserving(document, "mousemove", mousemoveHandler);
		Event_stopObserving(document, "mouseup", mouseupHandler);
		Event_stopObserving(doc, "mousemove", mousemoveHandler);
		Event_stopObserving(doc, "mouseup", mouseupHandler);
	}

	// param
	var doc = null, win = null;
	var divBody, divTitle, divStatus, divResize;
	var folded = false;
	var x = parseInt(scriptParams.x, 10), y = parseInt(scriptParams.y, 10);
	var width = parseInt(scriptParams.width, 10), height = parseInt(scriptParams.height, 10);
	var title_height = 22, status_height = 14;
	var min_width = 250, min_height = 50;

	// main routine
	var iframe = createElm("IFRAME", {
		position: "absolute",
		border: "0px", 
		left: px(x), top: px(y), 
		width: px(width), height: px(height)}
	);
	iframe.frameBorder = "0";

	setIframeOnload(iframe, function(){
		doc = iframe.contentDocument || iframe.Document;
		win = iframe.contentWindow;

		divBody = doc.getElementById("body");
		divTitle = doc.getElementById("title");
		divStatus = doc.getElementById("status");
		divResize = doc.getElementById("resize");
		if(!divBody || !divTitle || !divStatus || !divResize) return;
		Event_observe(window, "unload", function(){
			doc = win = divBody = divTitle = divStatus = divResize = null;
		});

		setPosition();
		FireBug.initialize(iframe);
		setIframeEvent();
	});

	iframe.src = pathToScript +"ieerbug.html";
	appendElement();
}

//var div = createPopupConsole();
createIframeConsole();


//////////////////////////////////////////////////////////////////////////////////////////////////
// firebug.js
var FireBug = 
{
	contexts: [],

	views: {},
	viewTypes: {
		"console": FireBugConsoleView,
		"dom": FireBugDOMView
	},

	stringCropLength: 100
}

FireBug.initialize = function(frame)
{
	this.browser = frame;

	this.attach();
}

FireBug.attach = function()
{
	for (var viewName in this.viewTypes)
	{
		var viewType = this.viewTypes[viewName];

		var newView = new viewType();
		this.views[viewName] = newView;
		
		//newView.optionsMenu = document.getElementById("fbOptionsMenu_" + viewName);
		newView.viewName = viewName;

		var doc = this.browser.contentDocument || this.browser.Document;
		var node = doc.createElement("div");
		node.className = "contextNode contextNode-" + viewName;
		doc.getElementById("body").appendChild(node);

		newView.initialize(this.browser);
		newView.contextNode = node;
		
		//for (var i in this.contexts)
		//	newView.attachContext(this.contexts[i]);
	}

	this.console = this.views["console"];
	this.currentView = this.console;
	window.console.flushQueue();
}

FireBug.showContext = function(view, context)
{
	view.context = context;
	view.contextNode = this.ensureContextNode(view, context);

	view.contextNode.style.display = "block";

	view.showContext(context);
}

/**
 * Selects an object and displays it in the most appropriate view.
 */
FireBug.selectObject = function(object, viewName, switchView, keepHistory)
{
	if (!object)
		object = window;

	this.selectedObject = object;

	// Just update the current view to show the selected object
	var view = this.views[viewName];
	this.showContext(this.currentView, this.selectedObject);
}

FireBug.selectView = function(viewName, object, keepHistory)
{
	// Once you switch to an inspector view, it becomes the default from then on
	if (this.isMainViewName(viewName))
		this.switchMainView(viewName);

	else
	{
		if (this.currentContext)
			this.currentContext.lastInspector = viewName;
		
		this.switchMainView("dom"); // currently, "inspector"->"dom"

		this.defaultViewName = viewName;
	}
	
	var view = this.views[viewName];
	if (!view)
		return;
	
	if (this.currentContext)
	{
		if (this.currentView && this.currentView != view)
		{
			this.hideContext(this.currentView, this.currentContext);
			
			var viewButton = document.getElementById("fbTab-" + this.currentView.viewName);
			if (viewButton)
				viewButton.removeAttribute("selected");
		}

		this.currentContext.view = view;
		this.currentView = view;

		if (!object)
			object = this.currentContext.selectedObject;
		
		if (!keepHistory)
			this.updateHistory(object, view.viewName);
		
		this.validateHistory();

		this.showContext(view, this.currentContext);

		this.updateObjectPath(object);

		var viewButton = document.getElementById("fbTab-" + viewName);
		viewButton.setAttribute("selected", "true");
		
		var contextNode = this.currentContext.contextNodes[view.viewName];
		this.searchBox.value = contextNode && contextNode.searchText ? contextNode.searchText : "";
		this.searchBox.disabled = !view.searchable;

		this.setOptionsMenu(view.optionsMenu);
		
		this.clearCommand.setAttribute("disabled", !view.clearable);
	}
}

FireBug.switchMainView = function(viewName)
{	
	var doc = this.browser.contentDocument || this.browser.Document;

	var tabConsole = doc.getElementById("fbTab-console");
	var tabInspector = doc.getElementById("fbTab-inspector");

	if (viewName == "console")
	{
		FireBugUtils.setClass(tabConsole, "selected");
		FireBugUtils.removeClass(tabInspector, "selected");

		this.views["console"].contextNode.style.display = "block";
		this.views["dom"].contextNode.style.display = "none";

		this.currentView = this.views["console"];
		FireBugUtils.removeClass(doc.getElementById("cmd_clearConsole"), "disabled");
	}
	else if (viewName == "inspector")
	{
		FireBugUtils.removeClass(tabConsole, "selected");
		FireBugUtils.setClass(tabInspector, "selected");
		
		this.views["console"].contextNode.style.display = "none";
		this.views["dom"].contextNode.style.display = "block";

		this.currentView = this.views["dom"];
		FireBugUtils.setClass(doc.getElementById("cmd_clearConsole"), "disabled");
	}
}

FireBug.isMainViewName = function(viewName)
{
	return viewName == "console" || viewName == "js";
}

FireBug.clearConsole = function()
{
	this.currentView.clear();
}


/**
 * Called when an object link is clicked.
 */
FireBug.browseObject = function(object)
{
	var view = this.views["dom"];
	this.switchMainView("inspector");
	view.inspect(object);
}

//
function SourceLink(href, line)
{
	this.href = href;
	this.line = line;
}

function StackTrace(frame)
{
	this.frames = [];
	
	// IEerBug: 
	function getFuncName(f){
		if(!f){
			return "null";
		}
		
		var s;
		try{
			s = ("" + f).match(/function (\w*)/)[1];
		}
		catch(e){}
		return (s == null || s.length == 0) ? "[anonymous]" : s;
	}

	// IEerBug: get stack trace using arguments.callee
	var i = 0;
	for (; frame; frame = frame.caller)
	{
		this.frames.push({
			functionName: getFuncName(frame),
			fileName: null,
			line: null
		});
		i++;

		if(i > 50) break;
	}

	// IEerBug: toplevel null function must be added
	if(this.frames.length == 0){
		this.frames.push({functionName: "null", fileName : null, line : null});
	}
}


//////////////////////////////////////////////////////////////////////////////////////////////////
// consoleAPI.js
function FireBugConsole()
{
	this.firebug = "0.4";
	var context = null;  // context is not implemented in IEerBug... by nitoyon
	var queue = [];
	var timeCounters;
	var frameCounters;

	// ieerbug : Until FireBug.console is defined, stock the arguments to queue.
	this.flushQueue = function(){
		if(queue){
			for(var i = 0; i < queue.length; i++){
				var q = queue[i];
				FireBug.console.log(q[0], q[1], q[2], q[3]);
			}
			queue = null;
		}
	}
	
	this.logRelay = function(args, rowClass, rowFunc, context){
		if(typeof FireBug == "object" && FireBug.console){
			if(queue){
				this.flushQueue();
			}

			FireBug.console.log(args, rowClass, rowFunc, context);
		}
		else{
			queue.push(arguments);
		}
	}

	this.log = function()
	{
		this.logRelay(arguments, "log", FireBug_logFormattedRow);
	}

	this.logMessage = function(messages, rowClass, showLine)
	{
		this.logRelay(messages, rowClass, FireBug_logFormattedRows, context, showLine);
	}

	this.logAssert = function(messages, caption)
	{
		//FireBug.increaseErrorCount(context);
	
		if (!messages || !messages.length)
			messages = ["Assertion Failure"];
		
		this.logRelay([messages, caption], "assert", FireBug_logFormattedRows, context, true);
	
		/* ieerbug : comment out
		if (win && typeof(win.onassert) == "function")
		{
			// XXXjoe Convert args to a string
			win.onassert(message, caption);
		}*/
	}
	
	this.debug = function()
	{
		this.logRelay(arguments, "debug", FireBug_logFormattedRow, context, true);
	}
	
	this.info = function()
	{
		this.logRelay(arguments, "info", FireBug_logFormattedRow, context, true);
	}
	
	this.warn = function()
	{
		this.logRelay(arguments, "warn", FireBug_logFormattedRow, context, true);
	}
	
	this.error = function()
	{
		//FireBug.increaseErrorCount(context);
		this.logRelay(arguments, "error", FireBug_logFormattedRow, context, true);
	}

	this.fail = function()
	{
		this.logAssert(arguments, null);
	}
	
	this.assert = function(x)
	{
		if (!x)
			this.logAssert(sliceArray(arguments, 1), ["%o", x]);
	}

	this.assertEquals = function(x, y)
	{
		if (x != y)
			this.logAssert(sliceArray(arguments, 2), ["%o != %o", x, y]);
	}	

	this.assertNotEquals = function(x, y)
	{
		if (x == y)
			this.logAssert(sliceArray(arguments, 2), ["%o == %o", x, y]);
	}	

	this.assertGreater = function(x, y)
	{
		if (x <= y)
			this.logAssert(sliceArray(arguments, 2), ["%o <= %o", x, y]);
	}	

	this.assertNotGreater = function(x, y)
	{
		if (!(x > y))
			this.logAssert(sliceArray(arguments, 2), ["!(%o > %o)", x, y]);
	}	

	this.assertLess = function(x, y)
	{
		if (x >= y)
			this.logAssert(sliceArray(arguments, 2), ["%o >= %o", x, y]);
	}	

	this.assertNotLess = function(x, y)
	{
		if (!(x < y))
			this.logAssert(sliceArray(arguments, 2), ["!(%o < %o)", x, y]);
	}	

	this.assertContains = function(x, y)
	{
		if (!(x in y))
			this.logAssert(sliceArray(arguments, 2), ["!(%o in %o)", x, y]);
	}	

	this.assertNotContains = function(x, y)
	{
		if (x in y)
			this.logAssert(sliceArray(arguments, 2), ["%o in %o", x, y]);
	}	

	this.assertTrue = function(x)
	{
		this.assertEquals(x, true);
	}	

	this.assertFalse = function(x)
	{
		this.assertEquals(x, false);
	}	

	this.assertNull = function(x)
	{
		this.assertEquals(x, null);
	}	

	this.assertNotNull = function(x)
	{
		this.assertNotEquals(x, null);
	}	

	this.assertUndefined = function(x)
	{
		this.assertEquals(x, undefined);
	}	

	this.assertNotUndefined = function(x)
	{
		this.assertNotEquals(x, undefined);
	}	

	this.assertInstanceOf = function(x, y)
	{
		if (!(x instanceof y))
			this.logAssert(sliceArray(arguments, 2), ["!(%o instanceof %o)", x, y]);
	}	

	this.assertNotInstanceOf = function(x, y)
	{
		if (x instanceof y)
			this.logAssert(sliceArray(arguments, 2), ["%o instanceof %o", x, y]);
	}	

	this.assertTypeOf = function(x, y)
	{
		if (typeof(x) != y)
			this.logAssert(sliceArray(arguments, 2), ["typeof(%o) != %o", x, y]);
	}	

	this.assertNotTypeOf = function(x)
	{
		if (typeof(x) == y)
			this.logAssert(sliceArray(arguments, 2), ["typeof(%o) == %o", x, y]);
	}	

	this.group = function(name)
	{
	}
	
	this.groupEnd = function(name)
	{
	}
	
	this.time = function(name, reset)
	{
		if (!name)
			return;
		
		var time = new Date().getTime();
		
		if (!timeCounters)
			timeCounters = {};

		if (!reset && name in timeCounters)
			return;
		
		timeCounters[name] = time;
	}
	
	this.timeEnd = function(name)
	{
		var time = new Date().getTime();

		if (!timeCounters)
			return;

		var timeCounter = timeCounters[name];
		if (timeCounter)
		{
			var diff = time - timeCounter;
			var label = name + ": " + diff + "ms";
			FireBug.console.log(label, "log", FireBug_logTextRow, context, true, true);
			
			delete timeCounters[name];
		}
	}
	
	this.count = function(key)
	{
		var frameId = "";  // ieerbug
		//var frameId = FireBugUtils.getStackFrameId();
		//if (frameId)
		{
			if (!frameCounters)
				frameCounters = {};
			
			if (key != undefined)
				frameId += key;
						
			var frameCounter = frameCounters[frameId];
			if (!frameCounter)
			{
				var logRow = FireBug.console.log("", "count", FireBug_logTextRow, context,
					true, true);
				
				frameCounter = {logRow: logRow, count: 1};
				frameCounters[frameId] = frameCounter;
			}
			else
				++frameCounter.count;
				
			var label = key == undefined
				? frameCounter.count
				: key + " " + frameCounter.count;

			frameCounter.logRow.firstChild.firstChild.nodeValue = label;
		}
	}
	
	this.trace = function()
	{
		var trace = new StackTrace(arguments.callee.caller);
		FireBug.console.log(trace, "stackTrace", FireBug_logObjectRow, context);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////
// console.js
function FireBugConsoleView()
{
}

FireBugConsoleView.prototype.initialize = function(browser)
{
	this.browser = browser
}

FireBugConsoleView.prototype.log = function(args, rowClass, rowFunc, context){
	var logRow = this.createLogRow(rowClass);

	if (!rowFunc)
		rowFunc = FireBug_logObjectRow;

	var canceled = rowFunc.apply(this, [args, logRow, context]);
	if(canceled) return null;

	this.appendLogRow(logRow);
	return logRow;
}

FireBugConsoleView.prototype.clearable = true;

FireBugConsoleView.prototype.clear = function()
{
	if (this.contextNode)
		FireBugUtils.clearNode(this.contextNode);
}

FireBugConsoleView.prototype.createLogRow = function(rowClass){
	var logDocument = this.browser.contentDocument || this.browser.Document;

	var div = logDocument.createElement("div");
	div.className = "logRow logRow-" + rowClass;
	return div;
}

FireBugConsoleView.prototype.appendLogRow = function(logRow){
	this.contextNode.appendChild(logRow);
	logRow.scrollIntoView();
}

//////////////////////////////////////////////////////////////////////////////////////////////////
// dom.js
function FireBugDOMView() {}

FireBugDOMView.prototype.initialize = function(browser)
{
	this.browser = browser
}

FireBugDOMView.prototype.inspect = function(object)
{
	if (object == this.contextNode.latestObject)
		return;

	FireBugUtils.clearNode(this.contextNode);

	this.contextNode.latestObject = object;
	
	FireBug_logDOM(object, this.contextNode);
}


//////////////////////////////////////////////////////////////////////////////////////////////////
// loggers.js
FireBug_objectFormatMap =
{
	"text": FireBug_logText,
	"undefined": FireBug_logUndefined,
	"null": FireBug_logNull,
	"number": FireBug_logPrimitive,
	"string": FireBug_logString,
	"element": FireBug_logElement,
	"document": FireBug_logDocument,
	"textNode": FireBug_logTextNode,
	"object": FireBug_logObject,
	"array": FireBug_logArray,
	"consoleError": FireBug_logConsoleError,
	"function": FireBug_logFunction,
	"sourceLink": FireBug_logSourceLink,
	"stackTrace": FireBug_logStackTrace
};

FireBug_appendObject = function(object, logRow, precision, partial)
{
	var format;
	try
	{
		format = FireBug_getFormatForObject(object);
	}
	catch (exc)
	{
		format = FireBug_defaultObjectFormat;
	}
	
	var formatter = FireBug_objectFormatMap[format];
	formatter.apply(this, [object, logRow, precision, partial]);
}

FireBug_getFormatForObject = function(object)
{
	var type = typeof(object);
	
	if (type == "undefined")
		return "undefined";

	else if (object == null)
		return "null";

	else if (type == "object")
	{
		// Cross-browser class check (IE doesn't support "object instanceof Window") by nitoyon
		if(object instanceof ScriptError){
			return "consoleError";
		}
		
		if ("innerHTML" in object && typeof(object.innerHTML) == "string"
		 && "tagName" in object && typeof(object.tagName) == "string"
		 && "attributes" in object && typeof(object.attributes) == "object"
		 && "length" in object.attributes && typeof(object.attributes.length) == "number")
			return "element";
		else if ("location" in object && typeof(object.location) == "object"
		 && "write"  in object && "writeln" in object && "open" in object && "close" in object)
			return "document";
		else if ("setTimeout" in object && "setInterval"  in object && "history" in object)
			return "object";
		else if ("nodeType" in object && typeof(object.nodeType) == "number"
		 && object.nodeType == 3) // TEXT_NODE
			return "textNode";
		else if ("length" in object && typeof(object.length) == "number")
			return "array";
		else if (object instanceof SourceLink)
			return "sourceLink";
		else if (object instanceof StackTrace)
			return "stackTrace";
		return "object";
	}
	else if (type == "function")
		return "function";

	else if (type == "number" || type == "boolean")
		return "number";

	else if (type == "string")
		return "string";

	else
		return "object";
}

// Row Loggers
function FireBug_logFormattedRow(objects, logRow, context){
	FireBug_appendFormatted(objects, logRow);
}

function FireBug_logFormattedRows(objects, logRow, context)
{
	for (var i = 0; i < objects.length; ++i)
	{
		if (objects[i])
		{
			var objectRow = logRow.ownerDocument.createElement("div");
			objectRow.className = "row" + (i+1);
			FireBug_appendFormatted(objects[i], objectRow);
			logRow.appendChild(objectRow);
		}
	}
}

FireBug_appendFormatted = function(objects, logRow)
{
	if (!objects || !objects.length)
		return;
	
	var format = objects[0];
	var objIndex = 0;
	if (typeof(format) != "string"){
		format = "";
		objIndex = -1;
	}

	var formatParts = FireBug_parseFormat(format);
	for (var i = 0; i < formatParts.length; ++i){
		var formatPart = formatParts[i];
		if (formatPart && typeof(formatPart) == "object"){
			var object = objects[++objIndex];
			formatPart.func.apply(this, [object, logRow, formatPart.precision]);
		}
		else
			FireBug_logText(formatPart, logRow);
	}

	for (var i = objIndex+1; i < objects.length; ++i)
	{
		FireBug_logText(" ", logRow);
		FireBug_appendObject(objects[i], logRow, 0, false);
	}
}

// Object Loggers
function FireBug_logAnything(object, logRow, precision, partial)
{
	if (!precision || partial)
		FireBug_appendObject(object, logRow, precision, partial);
	else if (precision == -1)
		FireBug_logKeys(object, logRow);
	else
		FireBug_logDOM(object, logRow, precision, partial);
}

function FireBug_logNull(value, logRow, precision, partial)
{
	var doc = logRow.ownerDocument;

	var objectBox = FireBugUtils.createObjectSpan(doc, value, "null");
	logRow.appendChild(objectBox);
}

function FireBug_logUndefined(value, logRow, precision, partial)
{
	var doc = logRow.ownerDocument;

	var objectBox = FireBugUtils.createObjectSpan(doc, value, "undefined");
	logRow.appendChild(objectBox);
}

FireBug_parseFormat = function(format)
{
	var formatParts = [];
	
	var reg = /((^%|[^\\]%)(\d+)?(\.)([a-zA-Z]))|((^%|[^\\]%)([a-zA-Z]))/;
	var index = 0;
	
	for (var m = reg.exec(format); m; m = reg.exec(format))
	{
		var type = m[8] ? m[8] : m[5];
		var precision = m[3] ? parseInt(m[3]) : (m[4] == "." ? -1 : 0);
		
		var func = null;
		switch (type)
		{
			case "s":
				func = FireBug_logText;
				break;
			case "f":
			case "i":
			case "d":
				func = FireBug_logPrimitive;
				break;
			case "o":
				func = FireBug_logAnything;
				break;
			//case "x":
			//	func = FireBug_logElementFull;
				break;
		}
		
		formatParts.push(format.substr(0, m[0].charAt(0) == "%" ? m.index : m.index+1)); // m[0][0] -> m[0].charAt(0) by nitoyon
		formatParts.push({func: func, precision: precision});
		
		format = format.substr(m.index+m[0].length);
	}
	
	formatParts.push(format);
	
	return formatParts;
}

function FireBug_logText(value, logRow, precision, partial){
	var doc = logRow.ownerDocument;

	var objectBox = FireBugUtils.createObjectSpan(doc, value, value, "text");
	logRow.appendChild(objectBox);
}

function FireBug_logPrimitive(value, logRow, precision, partial){
	var doc = logRow.ownerDocument;

	var objectBox = FireBugUtils.createObjectSpan(doc, value, value);
	logRow.appendChild(objectBox);
}

function FireBug_logString(value, logRow, precision, partial)
{
	var doc = logRow.ownerDocument;

	if (partial)
	{
		if (value.length >= FireBug.stringCropLength)
			value = value.substr(0, FireBug.stringCropLength) + "...";

		value = FireBugUtils.escapeNewLines(value);
	}

	value = '"' + value + '"';
	
	var objectBox = FireBugUtils.createObjectSpan(doc, value, value);
	logRow.appendChild(objectBox);
}

// Row Loggers
function FireBug_logTextRow(object, logRow, context)
{
	FireBug_logText(object, logRow);
}

function FireBug_logObjectRow(object, logRow, context)
{
	FireBug_appendObject(object, logRow, 0, false);
}

// Object Loggers
function FireBug_logObject(object, logRow, precision, partial)
{
	if (!precision || partial)
	{
		var caption = FireBug.getObjectTitle(object);
		
		var logLink = withDocument(logRow.ownerDocument, function() {
			return FireBugUtils.createObjectLink(object, caption);
		});
		logRow.appendChild(logLink);
	}
	else if (precision == -1)
		FireBug_logKeys(object, logRow);
	else
		FireBug_logDOM(object, logRow, precision, partial);
}

function FireBug_logKeys(object, logRow)
{
	var names = [];
	for (var name in object)
		names.push(name);

	FireBug_logArray(names, logRow);
}

function FireBug_logFunction(fn, logRow, precision, partial)
{
	var doc = logRow.ownerDocument;

	// ieerbug : regex IE support
	//var fnRegex = /(function [^(]*\([^)]*\) )\{(.*?)\}$/;
	var fnRegex = /(function[^(]*\([^)]*\))/;

	var fnText = new String(fn).replace("\n", " ", "g");
		
	var m = fnRegex.exec(fnText);
	if (m)
		fnText = m[1] + " {...}";

	var objectBox = FireBugUtils.createObjectSpan(doc, fnText);
	logRow.appendChild(objectBox);
}

function FireBug_logArray(array, logRow, precision, partial)
{
	var doc = logRow.ownerDocument;
	
	withDocument(doc, function()
	{
		logRow.appendChild(SPAN({"class": "arrayLeftBracket"}, "["));
	
		if (partial)
			logRow.appendChild(SPAN({"class": "arrayItem"}, array.length));

		else
		{
			for (var i = 0; i < array.length; ++i)
			{
				if (i > 0)
					logRow.appendChild(SPAN({"class": "arrayComma"}, ","));
		
				var itemNode = SPAN({"class": "arrayItem"});
				logRow.appendChild(itemNode);
				
				FireBug_appendObject(array[i], itemNode, 0, false);
			}
		}
		
		logRow.appendChild(SPAN({"class": "arrayRightBracket"}, "]"));
	});
}

function FireBug_logElement(element, logRow, precision, partial)
{
	if (!isElement(element))
		return;
	
	//logRow.title = FireBugUtils.getElementXPath(element);

	var html = FireBugUtils.getElementLineLabel(element, partial);
	var logLink = withDocument(logRow.ownerDocument, function() {
		return FireBugUtils.createObjectLink(element, html);
	});

	logRow.appendChild(logLink);
}

function FireBug_logDocument(doc, logRow, precision, partial)
{
	var caption = "[Document] " + doc.location;
	var logLink = withDocument(logRow.ownerDocument, function() {
		return FireBugUtils.createObjectLink(doc, caption);
	});
	logRow.appendChild(logLink);
}

function FireBug_logTextNode(textNode, logRow, precision, partial)
{
	var nodeValue = FireBugUtils.escapeNewLines(textNode.nodeValue);
	
	var caption = "[Text] \"" + nodeValue + "\"";
	var logLink = withDocument(logRow.ownerDocument, function() {
		return FireBugUtils.createObjectLink(textNode, caption);
	});
	logRow.appendChild(logLink);
}

function FireBug_logConsoleError(scriptError, logRow, precision, partial)
{
	var sourceName = scriptError.sourceName;
	var fromCommandLine = false;
	//var showStackTrace = false;
	//var fromCommandLine = sourceName.indexOf(FireBugCommandLine.evalScript) != -1;
	var showStackTrace = !fromCommandLine && scriptError.errorStackTrace;
	var titleBox = withDocument(logRow.ownerDocument, function() {
		return DIV({"class": "errorTitle"}, [
			showStackTrace ? TWISTY({onclick: onDiscloseError}) : null,
			TEXT(scriptError.errorMessage)
		]);
	});
	logRow.appendChild(titleBox);

	if (showStackTrace)
		logRow.errorStackTrace = scriptError.errorStackTrace;

	scriptError.errorStackTrace = null;

	if (scriptError.lineNumber && !fromCommandLine)
	{
		FireBugUtils.setClass(logRow, "logRow-sourceLink");
		var sourceLink = new SourceLink(sourceName, scriptError.lineNumber);
		FireBug_appendObject(sourceLink, logRow);
	}
	
	if (scriptError.sourceLine)
	{
		var sourceBox = withDocument(logRow.ownerDocument, function() {
			return DIV({"class": "errorSource"}, [TEXT(scriptError.sourceLine)]);
		});
		logRow.appendChild(sourceBox);
	}
}

function onDiscloseError()
{
	var titleBox = this.parentNode;
	var logRow = titleBox.parentNode;
	
	//var twisty = FireBugUtils.getChildByClassName(titleBox, "twisty");
	var twisty = titleBox.getElementsByTagName("img")[0];
	var body = FireBugUtils.getChildByClassName(logRow, "errorStack");

	if (!body)
	{
		body = withDocument(this.ownerDocument, function() {
			return DIV();
		});
		body.className = "disclosure errorStack";
		logRow.appendChild(body);
		
		FireBug_logStackTrace(logRow.errorStackTrace, body);
	}

	var closed = body.style.display != "block";
	twisty.src = pathToScript + (closed ? "twistyOpen.gif" : "twistyClosed.gif");
	body.style.display = closed ? "block" : "none";
}

function FireBug_logSourceLink(sourceLink, logRow, precision, partial)
{
	var fileName = FireBugUtils.parseFileNameFromURL(sourceLink.href);
	var linkTitle = fileName + " (line " + sourceLink.line + ")";

	var logLink = withDocument(logRow.ownerDocument, function() {
		return FireBugUtils.createObjectLink(sourceLink, linkTitle);
	});
	
	logLink.title = sourceLink.href;
	
	logRow.appendChild(logLink);
}

function FireBug_logStackTrace(stackTrace, logRow, precision, partial)
{
	for (var i = 0; i < stackTrace.frames.length; ++i)
	{
		var frame = stackTrace.frames[i];
		
		var functionName = frame.functionName ? frame.functionName : "null";
		
		var itemRow = withDocument(logRow.ownerDocument, function() {
			return DIV({"class": "stackFrame"}, [
				SPAN({"class": "stackFunctionName"}, functionName),
			]);
		});

		// IEerBug: arguments.callee callstack cannot support fileName & line...
		//var sourceLink = new SourceLink(frame.fileName, frame.line);
		//FireBug_logSourceLink(sourceLink, itemRow);
		
		logRow.appendChild(itemRow);
	}
}

function FireBug_logSourceString(sourceString, logRow, precision, partial)
{
	sourceString = FireBugUtils.escapeHTML(sourceString);
	
	// Split the source by line breaks
	var lines = sourceString.split(/\r\n|\r|\n/);
	
	var maxLines = (lines.length + "").length;
	var html = [];

	withDocument(logRow.ownerDocument, function() {
		for (var i = 0; i < lines.length; ++i)
		{
			// Make sure all line numbers are the same width (with a fixed-width font) 
			var lineNo = (i+1) + "";
			while (lineNo.length < maxLines)
				lineNo = " " + lineNo;

			html.push('<div class="sourceRow"><a class="sourceLine">');
			html.push(lineNo);
			html.push('</a><span class="sourceRowText">');
			html.push(lines[i]);
			html.push('</span></div>');
		}
	});

	// Believe it or not, using innerHTML is 10x faster (no exaggeration) than constructing
	// DOM elements and inserting them one by one
	logRow.innerHTML = html.join("");
}

function FireBug_logDOM(object, logRow, precision, partial)
{
	var doc = logRow.ownerDocument;
	
	function isFunction(value) { return (typeof value) == "function"; }
	function isNotFunction(value) { return (typeof value) != "function"; }

	precision = precision > 0 ? precision-1 : 0;
	
	var objectType = typeof(object);
	if (objectType == "function")
	{
		FireBug_logSourceString(object+"", logRow);
	}
	else if (objectType == "string")
	{
		FireBug_logSourceString(object, logRow);
	}
	else if (objectType == "object")
	{
		var table = doc.createElement("table");

		/* ieerbug */
		table.style.width = "100%";
		table.style.tableLayout = "fixed";

		var col = doc.createElement("col");
		col.style.width = "200px";
		table.appendChild(col);
		var col = doc.createElement("col");
		table.appendChild(col);

		var tbody = doc.createElement("tbody");	// IE needs tbody tag.
		table.appendChild(tbody);
		/* ieerbug end */
		
		for (var name in object)
		{
			try
			{
				FireBug_createObjectRow(name, object[name], isNotFunction, tbody, precision);
			}
			catch (exc) {}
		}
		
		for (var name in object)
		{
			try
			{
				FireBug_createObjectRow(name, object[name], isFunction, tbody, precision);
			}
			catch (exc) {}
		}

		logRow.appendChild(table);
	}
}

function FireBug_createObjectRow(name, value, filter, table, precision)
{
	if ((filter && !filter(value)))
		return;
	
	var isFunction = typeof(value) == "function";
	var isConstant = FireBugUtils.isAllUpperCase(name);

	var doc = table.ownerDocument;
	var tr = doc.createElement("tr");
	tr.className = "propertyRow" + 
		(isFunction ? " propertyRow-function" : "") +
		(isConstant ? " propertyRow-constant" : "");

	var td = doc.createElement("td");
	td.setAttribute("vAlign", "top");
	td.className = "propertyLabel";

	// Create the property name
	var labelElt = doc.createElement("span");
	labelElt.className = "propertyName";
	var labelText = doc.createTextNode(name);
	labelElt.appendChild(labelText);
	tr.appendChild(td);

	// Create the twisty if the value is an object
	var valueType = typeof(value);
	if (valueType == "function" || (valueType == "object" && value != null)
		|| (valueType == "string" && value.length > FireBug.stringCropLength))
	{
		td.className += " propertyContainerLabel"
		labelElt.className += " propertyContainerName"
				
		var twisty = doc.createElement("img");
		twisty.src = "blank.gif";
		twisty.className = "twisty propertyTwisty";
		td.appendChild(twisty);

		var self = this;
		labelElt.onclick = function() { FireBug_toggleObjectRow(value, tr); }
		twisty.onclick = function() { FireBug_toggleObjectRow(value, tr); }
	}

	td.appendChild(labelElt);

	// Create the property value
	td = doc.createElement("td");
	td.className = "propertyValue";
	td.setAttribute("valign", "top");
	
	FireBug_appendObject(value, td, 0, true);
	
	tr.appendChild(td);
	table.appendChild(tr);

	if (valueType == "object" && value != null && precision > 0)
		FireBug_toggleObjectRow(value, tr, precision);
}

function FireBug_toggleObjectRow(object, tr, precision)
{
	var doc = tr.ownerDocument;
	
	var twisty = tr.firstChild.firstChild;

	if (tr.nextSibling && tr.nextSibling.className == "propertyChildRow")
	{
		FireBugUtils.removeClass(twisty, "open");
		
		tr.parentNode.removeChild(tr.nextSibling);
	}
	else
	{
		FireBugUtils.setClass(twisty, "open");

		var td = doc.createElement("td");
		td.className = "propertyChildBox";
		td.setAttribute("colSpan", 2);	// colspan -> colSpan
		
		FireBug_logDOM(object, td, precision);

		var newRow = doc.createElement("tr");
		newRow.className = "propertyChildRow";
		newRow.appendChild(td);
		
		if (tr.nextSibling)
			tr.parentNode.insertBefore(newRow, tr.nextSibling);
		else
			tr.parentNode.appendChild(newRow);
	}
}


//////////////////////////////////////////////////////////////////////////////////////////////////
// util.js
var FireBugUtils = {};

FireBugUtils.isAllUpperCase = function(str)
{
	return str.search(/[A-Z]/) >= 0 && str.search(/[a-z]/) == -1;
}

FireBugUtils.getElementLineLabel = function(element, partial)
{
	var tagName = element.tagName.toLowerCase();
	
	var html = "&lt;<span class=\"nodeTag\">" + tagName + "</span>";
	
	if (partial)
		html += this.getElementPartialAttributes(element);
	else
		html += this.getElementFullAttributes(element);

	html += "&gt;";

	return html;
}

FireBugUtils.getElementFullAttributes = function(element)
{
	var html = "";
	
	for (var i = 0; i < element.attributes.length; ++i)
	{
		var attr = element.attributes[i];
		
		// Hide attributes set by FireBug
		if ((attr.localName || attr.nodeName).indexOf("firebug-") == 0)
			continue;

		// filter for IE by nitoyon
		if(attr.nodeValue == null || attr.nodeValue == "")
			continue;

		html += " " + (attr.localName || attr.nodeName)
			+ '="<span class="nodeAttr" targetAttr="' + attr.localName + '">'
			+ attr.nodeValue + '</span>"';
	}

	return html;	
}

FireBugUtils.getElementPartialAttributes = function(element)
{
	var html = "";
	
	if (element.id)
		html += ' id="<span class="nodeAttr" targetAttr="id">' + element.id + '</span>"';
	if (element.className)
		html += ' class="<span class="nodeAttr" targetAttr="class">'
				+ element.className + '</span>"';
	
	return html;
}

FireBugUtils.parseFileNameFromURL = function(url)
{
	if (!url)
		return "";
	
	var lastSlash = Math.max(url.lastIndexOf("/"), url.lastIndexOf("\\"));
	var fileName = url.substr(lastSlash+1);
	if (fileName.length == 0)
		fileName = url;
	if (fileName.length > 17)
		fileName = fileName.substr(0, 17) + "...";

	return fileName;
}

FireBugUtils.createObjectSpan = function(doc, object, title, format)
{
	if (!format)
		format = FireBug_getFormatForObject(object);

	var span = doc.createElement("span");
	span.className = "objectBox objectBox-"+format;

	var text = doc.createTextNode(title ? title : object);
	span.appendChild(text);
	
	return span;
}

FireBug.getObjectTitle = function(object)
{
	if (typeof(object) == "undefined")
	{
		return "undefined";
	}
	else if (object == null)
	{
		return "null";
	}
	// deleted (i.e. "if(object instanceof Window)") by nitoyon
	else
		return object;
}

FireBugUtils.createObjectLink = function(object, title, className, onClick)
{
	var link = contextDocument.createElement("a");
	if (className)
		link.className = className;

	this.makeObjectLink(object, title, link, onClick);
	
	return link;
}

FireBugUtils.makeObjectLink = function(object, title, linkElt, onClick)
{
	var format = FireBug_getFormatForObject(object);
	FireBugUtils.setClass(linkElt, "objectLink objectLink-"+format);
	
	linkElt.linkObject = object;
	
	if (!linkElt.firstChild)
		linkElt.innerHTML = title;
	else
		linkElt.firstChild.nodeValue = title;

	linkElt.href = "#";
/*	linkElt.onmouseover = function(event)
	{
		FireBug.highlightObject(object);
	}
	
	linkElt.onmouseout = function(event)
	{
		FireBug.highlightObject(null);
	}*/
	
	linkElt.onclick = function(event)
	{
		var event = event || window.event

//		if (event.button == 0 && !event.ctrlKey && !event.shiftKey &&
//			!event.altKey && !event.metaKey)
//		{
			if (onClick)
				onClick.apply(linkElt);
			else
				FireBug.browseObject(object);
//		}
//		else if (event.metaKey || event.ctrlKey)
//			FireBug.visitObject(object);
	}
}

FireBugUtils.escapeNewLines = function(value)
{
	return value.replace(/\r/g, "\\r").replace(/\n/g, "\\n");
}

FireBugUtils.escapeHTML = function(value)
{
	return value.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
}

FireBugUtils.clearNode = function(node)
{
	while (node.lastChild)
		node.removeChild(node.lastChild);
}

FireBugUtils.hasClass = function(node, name)
{
	return node && node.className && node.className.indexOf(name) != -1;
}

FireBugUtils.setClass = function(node, name)
{
	if (node && !this.hasClass(node, name))
		node.className += " " + name;
}

FireBugUtils.removeClass = function(node, name)
{
	if (node && node.className)
	{
		var index = node.className.indexOf(name);
		if (index >= 0)
		{
			var size = name.length;
			node.className = node.className.substr(0,index-1) + node.className.substr(index+size);
		}
	}
}

FireBugUtils.toggleClass = function(elt, name)
{
	if (this.hasClass(elt, name))
		this.removeClass(elt, name);
	else
		this.setClass(elt, name);
}

FireBugUtils.getChildByClassName = function(node, className)
{
	for (var child = node.firstChild; child; child = child.nextSibling)
	{
		if (this.hasClass(child, className))
			return child;
	}
	
	return null;
}

//
var contextDocument = document;

FireBugUtils.createElement = function(name, attrs, content)
{
	var node = contextDocument.createElement(name);

	if (attrs)
	{
		for (var name in attrs)
		{
			var value = attrs[name];
			if (typeof(value) == "function")
				node[name] = value;
			else
				node.setAttribute(name, value);
		}
	}
	
	if (content != null && content != undefined)
	{
		// IEerBug: commented out
		//if (content instanceof Node)
		//	node.appendChild(content);
		if(content instanceof Array)
			appendNodes(node, content);
		else
			node.innerHTML = content;
	}
	
	return node;
}

function H1(attrs, text) { return FireBugUtils.createElement("h1", attrs, text); }
function H2(attrs, text) { return FireBugUtils.createElement("h2", attrs, text); }
function H3(attrs, text) { return FireBugUtils.createElement("h3", attrs, text); }
function DIV(attrs, text) { return FireBugUtils.createElement("div", attrs, text); }
function PRE(attrs, text) { return FireBugUtils.createElement("pre", attrs, text); }
function SPAN(attrs, text) { return FireBugUtils.createElement("span", attrs, text); }
function IMG(attrs, text) { return FireBugUtils.createElement("img", attrs, text); }
function HR(attrs, text) { return FireBugUtils.createElement("hr", attrs, text); }
function LI(attrs, text) { return FireBugUtils.createElement("li", attrs, text); }
function A(attrs, text) { return FireBugUtils.createElement("a", attrs, text); }
//function TWISTY(attrs) { attrs["class"] = "twisty"; attrs["src"] = "blank.gif"; return IMG(attrs); }
function TWISTY(attrs) { var i = IMG(attrs); i.src = "twistyClosed.gif"; i.style.verticalAlign = "middle"; return i; }
function TEXT(text) { return contextDocument.createTextNode(text); }

function withDocument(doc, fn)
{
	var previousDocument = contextDocument;
	contextDocument = doc;

	var result = fn();

	contextDocument = previousDocument;
	
	return result;
}

function appendNodes(parent, nodes)
{
	for (var i in nodes)
	{
		var content = nodes[i];

		// IEerBug changed.
		var type = FireBug_getFormatForObject(content);
		//if (content instanceof Node)
		if (type == "textNode" || type == "element"){
			parent.appendChild(content);}
		else if (content instanceof Array)
			appendNodes(parent, content);
		else if (content != null && content != undefined)
			parent.appendChild(parent.ownerDocument.createTextNode(content));
	}
	
	return parent;
}

function isElement(o)
{
	try{
		// edited by nitoyon
		if(typeof(o.innerHTML) == "string"){
			return true;
		}
	}
	catch (ex) {
		return false;
	}
}

function sliceArray(array, index)
{
	var slice = [];
	for (var i = index; i < array.length; ++i)
		slice.push(array[i]);
		
	return slice;
}
}

IEerBug();
