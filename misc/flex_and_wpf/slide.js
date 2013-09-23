var pages = [];
var num = 0;
var width, height;
var parser = new Hatena({sectionanchor : " "});
var canvas;



function parseDoc(doc)
{
	pages = [];
	pages = doc.split(/\n+----\n+/);

	num = parseInt(location.hash.substr(1));
	if(isNaN(num)) num = 0;
	showPage();
}

function showPage()
{
	var page = pages[num];
	location.hash = num;
	parser.parse(page);

	canvas.style.visibility = "hidden";
	canvas.innerHTML = parser.html();

	updateSectionPosition();
	canvas.style.visibility = "visible";
}

function nextPage()
{
	if(num < pages.length - 1)
	{
		num++;
		showPage();
	}
}

function prevPage()
{
	if(num > 0)
	{
		num--;
		showPage();
	}
}


//----------------------------
window.onload = function()
{
	canvas = document.getElementById("canvas");

	loadXml();

	initEvent();
}


// from prototype.js
function observe(element, name, observer, useCapture) {
	if (element.addEventListener) {
		element.addEventListener(name, observer, useCapture);
	} else if (element.attachEvent) {
		element.attachEvent('on' + name, observer);
	}
}

Function.prototype.bindAsEventListener = function(object) {
	var __method = this;
	return function(event) {
		return __method.call(object, event || window.event);
	}
}


function initEvent()
{
	observe(document, "keydown", keyhandler.bindAsEventListener());
	observe(window, "resize", updateSize);

	updateSize();
}


function keyhandler(event)
{
	switch(event.keyCode)
	{
		case 39: // right
		case 32: // space
			nextPage();
			break;
		case 37: // left
			prevPage();
			break;
	}
}

function updateSize()
{
	width = getWindowSize()[0];
	height = getWindowSize()[1];

	width = Math.min(width, height * 1.333);
	height = Math.min(width / 1.333, height);

	canvas.style.width = width + "px";
	document.body.style.fontSize = (width / 640 * 50) + "px";

	updateSectionPosition();
}

function updateSectionPosition()
{
	var div = canvas.getElementsByTagName("div")[0];
	if(div)
	{
		var imgs = div.getElementsByTagName("img");
		for(var i = 0; i < imgs.length; i++)
		{
			if(imgs[i]._flag == null)
			{
				observe(imgs[i], "load", updateSectionPosition);
				imgs[i].flag = true;
			}
		}

		div.style.marginTop = Math.max((height - div.offsetHeight) / 2, 0) + "px";
	}
}


// ウインドウサイズ取得
function getWindowSize(win){
	var win = win || window;
	var doc = win.document;
	var width = 0;
	var height = 0;

	if(doc.compatMode == 'CSS1Compat' && !window.opera){
		// Strict Mode && Non Opera
		width  = doc.documentElement.clientWidth;
		height = doc.documentElement.clientHeight;
	}else{
		// other
		width  = doc.body.clientWidth;
		height = doc.body.clientHeight;
	}

	return [width, height];
}

//----------------------------
function parseXml(xml)
{
	var root = xml.documentElement;
	try{
		parseDoc(root.firstChild.nodeValue);
	}
	catch(e){
		alert("XML の構造が変だよ : " + e.toString());
	}
}


function loadXml(){
	var ajax = createXmlHttp();
	if (ajax == null) {
		window.alert("XMLHttpRequest非対応のブラウザです。");
	}
	
	/* レスポンスデータ処理方法の設定 */
	ajax.onreadystatechange = function handleHttpEvent(){
		if (ajax.readyState == 4 && ajax.status == 200) {
			parseXml(ajax.responseXML);
		} else if(ajax.readyState == 4){
			window.alert("通信エラーが発生しました。");
		}
	}
	
	/* HTTPリクエスト実行 */
	ajax.open("GET", "slide.xml?" + (new Date()).getTime() , true);
	ajax.send(null);
}
 
function createXmlHttp(){
	if (window.XMLHttpRequest) {
		return new XMLHttpRequest();
	} else if (window.ActiveXObject) {
		try {
			return new ActiveXObject("Msxml2.XMLHTTP");
		} catch(e) {
			return new ActiveXObject("Microsoft.XMLHTTP");
		}
	} else {
		return null;
	}
}
