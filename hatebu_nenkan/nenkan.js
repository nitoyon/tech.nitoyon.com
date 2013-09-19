//******************************************************************************
//
//              Definition
//
//******************************************************************************

PARAM = {
	BOX_MARGIN: 50,
	BOX_TOP: 50,
	BOX_HEIGHT: 500,
	BOX_WIDTH: 655,
	TOTAL_WIDTH: 700,
	PAGE_ITEMS: 20
};

SITES = {
	'www.itmedia.co.jp': 'ITmedia',
	'd.hatena.ne.jp': 'はてなダイアリー',
	'japan.cnet.com': 'CNET Japan',
	'internet.watch.impress.co.jp': 'INTERNET Watch',
	'www.asahi.com': 'asahi.com',
	'hotwired.goo.ne.jp': 'Hotwired Japan',
	'headlines.yahoo.co.jp': 'Yahoo!ニュース',
	'pc.watch.impress.co.jp': 'PC Watch',
	'www.hatena.ne.jp': 'はてな',
	'anond.hatelabo.jp': 'はてな匿名ダイアリー',
	'blog.livedoor.jp': 'livedoor Blog',
	'www.ringolab.com': 'Passion For The Future',
	'itpro.nikkeibp.co.jp': 'ITpro',
	'www.atmarkit.co.jp': '@IT',
	'blog.japan.cnet.com': 'ブログ - CNET Japan',
	'plusd.itmedia.co.jp': 'ITmedia +D',
	'pcweb.mycom.co.jp': 'マイコミジャーナル',
	'satoshi.blogs.com': 'Life is beautiful',
	'www.future-planning.net': 'FPN',
	'arena.nikkeibp.co.jp': 'nikkei TRENDYnet',
	'www.geocities.jp': 'Yahoo!ジオシティーズ',
	'japanese.engadget.com': 'Engadget Japanese',
	'mojix.org': 'Zopeジャンキー日記',
	'phpspot.org': 'phpspot開発日誌',
	'amrita.s14.xrea.com': '圏外からのひとこと',
	'kotonoha.main.jp': '絵文録ことのは',
	'kengo.preston-net.com': 'Going My Way',
	'gigazine.net': 'GIGAZINE',
	'q.hatena.ne.jp': '人力検索はてな',
	'www.youtube.com': 'YouTube',
	'journal.mycom.co.jp': 'マイコミジャーナル',
	'netafull.net': '[N]ネタフル',
	'www.ideaxidea.com': 'IDEA*IDEA',
	'www.popxpop.com': 'POP*POP',
	'sweetlovexx.seesaa.net': ':: Love & Design ::',
	'labs.unoh.net': 'ウノウラボ',
	'www.forest.impress.co.jp': '窓の杜',
	'www.designwalker.com': 'DesignWalker',
	'zapanet.info': 'ZAPAnet総合情報局',
	'e0166.blog89.fc2.com': 'ホームページを作る人のネタ帳',
	'google-mania.net': 'Google Mania',
	'news4vip.livedoor.biz': '【2ch】ニュー速クオリティ',
	'choco--late.com': 'Chocolate',
	'alfalfa.livedoor.biz': 'アルファルファモザイク',
	'coliss.com': 'コリス',
	'www.lifehacker.jp': 'ライフハッカー［日本版］',
	'blog.goo.ne.jp': 'goo ブログ',
	'sankei.jp.msn.com': 'MSN産経ニュース',
	'workingnews.blog117.fc2.com': '人生VIP職人ブログwww',
	'web-tan.forum.impressrd.jp': 'Web担当者Forum',
	'antipop.zapto.org': 'Antipop',
	'www.goodpic.com': 'Goodpic',
	'staff.aist.go.jp': 'AIST： 産業技術総合研究所',
	'www.lucky-bag.com': 'Lucky bag::blog',
	'www.usability.gr.jp': 'U-Site',
	'yagi.xrea.jp': 'いぬビーム',
	'caramel-tea.com': 'caramel*vanilla',
	'g.1o4.jp': 'Googleサービスの使い方！',
	'la.ma.la': '最速インターフェース研究会',
	'toshio.typepad.com': 'B3 Annex',
	'kanou.jp': 'KANOU.JP',
	'dain.cocolog-nifty.com': 'わたしが知らないスゴ本は、きっとあなたが読んでいる',
	'blog.zuzara.com': 'zuzara',
	'hail2u.net': 'hail2u.net',
	'2xup.org': '2xup.org',
	'guideline.livedoor.biz': '【2ch】日刊スレッドガイド',
	'labaq.com': 'らばQ',
	'urasoku.blog106.fc2.com': 'ハムスター速報　２ろぐ',
	'ascii.jp': 'ASCII.jp',
	'b.hatena.ne.jp': 'はてなブックマークニュース',
	'jp.techcrunch.com': 'TechCrunch Japan',
	'hamusoku.com': 'ハムスター速報',
	'kachibito.net': 'かちびと.net',
	'www.google.com': 'Google',
	'r.nanapi.jp': 'ナナピ',
	'togetter.com': 'Togetter',
	'alfalfalfa.com': 'アルファルファモザイク',
	'www.publickey1.jp': 'Publickey',
	'www.lastday.jp': 'Last Day. jp'
};


//******************************************************************************
//
//              Util
//
//******************************************************************************

Number.prototype.px = function(){
	return this.toString() + 'px';
}

function getChildNode(parent, childTagName, childClassName){
	var len = parent.childNodes.length;
	for(var i = 0; i < len; i++){
		var child = parent.childNodes[i];
		if(child.tagName
		&& (childTagName == "*" || child.tagName.toUpperCase() == childTagName.toUpperCase())
		&& (!childClassName || child.className == childClassName)){
			return child;
		}
	}
}

function bound(val, min, max){
	return (val < min ? min : val > max ? max : val);
}

function getFavicon(url){
	return "http://favicon.hatena.ne.jp/?url=" + encodeURI(url);
}

jQuery.easing.easeOutBack = function(x, t, b, c, d, s) {
	if (s == undefined) s = 1.70158;
	return c*((t=t/d-1)*t*((s+1)*t + s) + 1) + b;
}
jQuery.easing.easeOutCubic = function (x, t, b, c, d) {
	return c*((t=t/d-1)*t*t + 1) + b;
}

/*
Copyright (c) 2007, Yahoo! Inc. All rights reserved.
Code licensed under the BSD License:
http://developer.yahoo.net/yui/license.txt
version: 2.4.1
*/
var ua=function(){var C={ie:0,opera:0,gecko:0,webkit:0,mobile:null};var B=navigator.userAgent,A;if((/KHTML/).test(B)){C.webkit=1;}A=B.match(/AppleWebKit\/([^\s]*)/);if(A&&A[1]){C.webkit=parseFloat(A[1]);if(/ Mobile\//.test(B)){C.mobile="Apple";}else{A=B.match(/NokiaN[^\/]*/);if(A){C.mobile=A[0];}}}if(!C.webkit){A=B.match(/Opera[\s\/]([^\s]*)/);if(A&&A[1]){C.opera=parseFloat(A[1]);A=B.match(/Opera Mini[^;]*/);if(A){C.mobile=A[0];}}else{A=B.match(/MSIE\s([^;]*)/);if(A&&A[1]){C.ie=parseFloat(A[1]);}else{A=B.match(/Gecko\/([^\s]*)/);if(A){C.gecko=1;A=B.match(/rv:([^\s\)]*)/);if(A&&A[1]){C.gecko=parseFloat(A[1]);}}}}}return C;}();
var isOpera = ua.opera,
	isSafari = ua.webkit, 
	isGecko = ua.gecko,
	isIE = ua.ie; 
function getViewportSize() {
	var size = [self.innerWidth, self.innerHeight];
	var mode = document.compatMode;

	if (mode || isIE) { // IE, Gecko, Opera
		size[0] = (mode == 'CSS1Compat') ?
				document.documentElement.clientWidth : // Standards
				document.body.clientWidth; // Quirks
	}
	if ( (mode || isIE) && !isOpera ) { // IE, Gecko
		size[1] = (mode == 'CSS1Compat') ?
				document.documentElement.clientHeight : // Standards
				document.body.clientHeight; // Quirks
	}
	return size;
}
function getDocumentSize() {
	var scrollWidth = (document.compatMode != 'CSS1Compat') ? document.body.scrollWidth : document.documentElement.scrollWidth;
	var scrollHeight = (document.compatMode != 'CSS1Compat') ? document.body.scrollHeight : document.documentElement.scrollHeight;
	var size = getViewportSize();
	return [Math.max(scrollWidth, size[0]),
	        Math.max(scrollHeight, size[1])];
}
/* YUI end */


//******************************************************************************
//
//              Doc
//
//******************************************************************************

var Doc = {
	monthList: null,
	yearList: null,
	aboutList: null,

	init: function(){
		var elm = document.getElementById("about");
		elm.parentNode.removeChild(elm);
		this.aboutList = [elm];

		this.monthList = [];
		this.yearList = [];
		elm = document.getElementById("main").firstChild;
		while(elm){
			var next = elm.nextSibling;
			if(elm.nodeName == "DIV"){
				if(elm.className && elm.className.match(/monthly/)){
					elm.parentNode.removeChild(elm);
					this.monthList.push(elm);
				}else if(elm.className && elm.className.match(/yearly/)){
					elm.parentNode.removeChild(elm);
					this.yearList.push(elm);
				}
			}
			elm = next;
		}

		BoxView.init();
		BoxDetailView.init();
		Header.init(BoxView);
		Pager.init();
		Timeline.init();
	}
};


//******************************************************************************
//
//              View
//
//******************************************************************************

//--------------------------------------
//  BoxView
//--------------------------------------

var BoxView = {
	count: 0,
	index: 0,
	pageWidth: 0,

	curList: null,
	year: 2005,
	month: 6,

	type: null,

	init: function(){
		this.index = -1;

		var lh = (location.hash || "").replace("#", "");
		if(lh.match(/^[0-9]{4}$/)){
			this.setType('yearly', parseInt(lh));
		}else if(lh.match(/^[0-9]{6}$/)){
			this.setType('monthly', parseInt(lh.substr(0, 4)), parseInt(lh.substr(4), 10));
		}else{
			this.setType('monthly', 2005 + Math.floor((Doc.monthList.length - 1) / 12), 1 + (Doc.monthList.length - 2 % 12));
		}
	},

	prev: function(){
		this.move(-1);
	},
	next: function(){
		this.move(1);
	},

	move: function(diff){
		this.moveTo(diff + this.index);
	},

	moveTo: function(to, forceNotify){
		to = Math.min(Math.max(0, to), this.curList.length - 1);

		var prev = this.index;
		this.index = to;
		if(forceNotify || prev != this.index){
			this.setYearAndMonthFromIndex(to);
			this.triggerChangeEvent();
		}
	},

	setType: function(type, year, month){
		type = (type == 'monthly' ? 'monthly' : type == 'about' ? 'about' : 'yearly');

		if(year)  year  = bound(year, 2005, 2005 + Doc.yearList.length);
		if(month) month = bound(month, 1, 12);

		if(type != this.type
		|| year && this.year != year
		|| month && this.month != month){
			this.type = type;
			this.curList = (type == 'monthly' ? Doc.monthList : type == 'yearly' ? Doc.yearList : Doc.aboutList);
			if(month) this.month = month;
			if(year) this.year = year;
			if(this.type == 'about'){
				this.index = 0;
				this.triggerChangeEvent();
			}else{
				this.moveTo(this.yyyymm2index(this.year, this.month), true);
			}
		}
	},

	setYearAndMonthFromIndex: function(index){
		if(this.type == 'monthly'){
			this.year = Math.floor((index + 1) / 12) + 2005;
			this.month = (index + 1) % 12 + 1;
		}else{
			this.year = index + 2005;
		}
	},

	yyyymm2index: function(y, m){
		return (this.type == 'monthly' ? (y - 2005) * 12 + m - 2 : y - 2005);
	},

	triggerChangeEvent: function(){
		$(BoxView).trigger("change", [{
			index: this.index,
			element: this.curList[this.index],
			length: this.curList.length,
			type: this.type,
			year: this.year,
			month: this.month
		}]);
	}
};


//--------------------------------------
//  BoxDetailView
//--------------------------------------

BoxDetailView = {
	view: null,
	curBox: null,

	//----------------------------------
	//  API
	//----------------------------------
	init: function(view){
		this.view = view;

		$(BoxView).bind("change", function(event){
			BoxDetailView.update();
		});
		this.update();
	},

	update: function(){
		this.destroyDetailBox();

		var elem = BoxView.curList[BoxView.index];
		this.createDetailBox(elem);
	},

	//----------------------------------
	//  util: box lifecycle
	//----------------------------------
	createDetailBox: function(elem){
		var view = this.view;

		// clone box
		this.curBox = elem.cloneNode(true);

		if(BoxView.type != "about"){
			// "box_detail" - box child
			var boxDetail = getChildNode(this.curBox, "DIV", "");
			if(!boxDetail) return;
			boxDetail.className = "box_detail";

			// init rank
			var entry = getChildNode(boxDetail, "DIV", "entry");
			var tag = getChildNode(boxDetail, "DIV", "tag");
			var domain = getChildNode(boxDetail, "DIV", "domain")
			EntryRank.init(entry);
			TagRank.init(tag);
			DomainRank.init(domain);

			Permalink.init(boxDetail);
		}

		document.getElementById("main").appendChild(this.curBox);
	},

	destroyDetailBox: function(){
		if(this.curBox){
			$(this.curBox).remove();
		}
	}
};


//--------------------------------------
//  Entry Rank
//--------------------------------------

var EntryRank = {
	label1: "続きを見る",
	label2: "折りたたむ",
	folded: true,
	div: null,

	init: function(div){
		this.div = div;

		// add a "see more" link
		var seemore = document.createElement("div");
		seemore.className = "seemore";
		div.appendChild(seemore);
		this.entryLink = $("<a></a>")
			.attr("href", "#")
			.text(this.getText())
			.click(function(event){EntryRank.entryBtnClicked(event)})
			.appendTo(seemore);

		var bgs = [];
		var counts = [];
		this.after10th = [];
		var ol = getChildNode(div, "OL")
		var lis = ol.getElementsByTagName("LI");
		for(var i = 0; i < lis.length; i++){
			var li = lis[i];

			// set list style
			if(i % 2 == 1) li.className = "odd";
			if(i >= 10){
				this.after10th.push(li);
				if(this.folded) li.style.display = "none";
			}

			// entry link
			var entry_link = getChildNode(li, "A");
			var url = entry_link.href;

			var span = document.createElement("span");
			span.className = "order";
			span.appendChild(document.createTextNode((i + 1) + "."));
			li.insertBefore(span, entry_link);

			entry_link.style.backgroundImage = "url('" + getFavicon(url) + "')";

			// create a "XXX users" link
			var strong = getChildNode(li, "strong");
			var users = strong.firstChild.nodeValue;
			strong.removeChild(strong.firstChild);
			var a = document.createElement("a");
			a.href = "http://b.hatena.ne.jp/entry/" + url.replace("#", "%23");
			a.appendChild(document.createTextNode(users));
			strong.appendChild(a);

			// create a "XXX users" background
			var user_count = parseInt(users);
			var bg = document.createElement("div");
			bg.style.backgroundColor = "#FFCCCC";
			bg.style.position = "absolute";
			bg.style.right = "0px";
			bg.style.width = "0px";
			bg.style.height = "1em";
			li.insertBefore(bg, span);

			bgs.push(bg);
			counts.push(user_count);
		}

		var from = [], to = [];
		for(var i = 0; i < bgs.length; i++){
			from.push(parseInt(bgs[i].style.width));
			to.push(75 * counts[i] / counts[4]);
		}
		setTimeout(function(){EntryRank.startAnimation(bgs, from, to, 0)}, 100);
	},

	startAnimation: function(bgs, from, to, pos){
		var ratio = jQuery.easing.easeOutCubic(0, Math.min(pos, 1), 0, 1, 1);
		for(var i = 0; i < bgs.length; i++){
			bgs[i].style.width = ((to[i] - from[i]) * ratio + from[i]) + 'px';
		}
		if(pos < 1){
			setTimeout(function(){EntryRank.startAnimation(bgs, from, to, pos + 0.05)}, 30);
		}
	},

	entryBtnClicked: function(event){
		event.preventDefault();
		if($(":animated", this.div).length) return;
		this.folded = !this.folded;

		var ol = $("ol", this.div);
		var height = ol.height();
		ol.css({
			overflow: "hidden",
			height: height.px()
		});
		this.showAfter10th(true);

		var self = this;
		ol.animate(
			{height: (this.folded ? height / 2 : height * 2)}, 700, 'easeOutCubic',
			function(){
				self.showAfter10th(!self.folded);
				this.style.height = "auto";
			});

		$(this.entryLink).text(this.getText());
	},

	showAfter10th: function(show){
		for(var i = 0; i < this.after10th.length; i++){
			var li = this.after10th[i];
			li.style.display = (show ? "block" : "none");
		}
	},

	getText: function(){
		return this.folded ? this.label1 : this.label2;
	}
}


//--------------------------------------
//  Tag Rank
//--------------------------------------

TagRank = {
	tagCloud: null,
	tagRank: null,
	isCloud: true,

	init: function(div){
		// get the cloud
		this.tagCloud = getChildNode(div, "OL");
		if(!this.tagCloud) return;

		// create a rank
		this.tagRank = this.createTagRank(this.tagCloud);
		div.appendChild(this.tagRank);

		// add a cloud/rank selector
		var img = document.createElement("img");
		img.src = "tagbtn1.png";
		img.width = 29;
		img.height = 13;
		img.style.cursor = 'pointer';
		img.style.marginTop = "17px";
		$(img).css("float", "right");
		img.style.left = "200px";
		this.img = img;
		this.h3 = getChildNode(div, "H3");
		div.insertBefore(img, this.h3);

		// add event
		var self = this;
		$(img).click(function(event){
			event.preventDefault();
			self.isCloud = !self.isCloud;
			self.update()
		});
		$(div).click(function(event){
			var target = event.target;
			while(target){
				if(target.tagName == "LI"){
					event.preventDefault();
					event.stopPropagation();
					var tag = target.firstChild.nodeValue;
					PopupGraph.show(tag, 'tag');
					return;
				}
				target = target.parentNode;
			}
		});

		this.update();
	},

	createTagRank: function(tagCloud){
		var elem = tagCloud.cloneNode(true);
		elem.className = 'tag-rank';

		var lis = $.makeArray(elem.getElementsByTagName('LI'));
		lis.sort(function(a, b){
			var ac = parseInt(a.className.replace("tag", ""));
			var bc = parseInt(b.className.replace("tag", ""));
			return ac - bc;
		});
		for(var i = 0; i < lis.length; i++){
			elem.removeChild(lis[i]);
		}

		// get prev rank
		var prevRank = null;
		if(BoxView.index > 0){
			prevRank = Summary.getTagRankOf(BoxView.curList, BoxView.index - 1);
		}

		var max = null;
		for(var i = 0; i < 10; i++){
			var li = lis[i];
			elem.appendChild(li);
			if(i % 2 == 1){li.className = "odd";}
			var span = li.getElementsByTagName('SPAN')[0];
			if(!span) continue;

			var tag = li.firstChild.nodeValue;
			var val = parseInt(span.firstChild.nodeValue);
			if(i == 0) max = val;

			// background
			var bg = document.createElement("div");
			bg.style.top = '2px';
			bg.style.width = (100 * val / max).px();
			li.insertBefore(bg, span);

			if(prevRank){
				var img = document.createElement("img");
				if(prevRank[tag] == null || i + 1 < prevRank[tag]){img.src = "arrow_up.png";}
				else if(i + 1 == prevRank[tag]){img.src = "arrow_right.png";}
				else{img.src = "arrow_down.png";}
				li.appendChild(img);
			}
		}

		return elem;
	},

	update: function(){
		this.img.src = (this.isCloud ? "tagbtn1.png" : "tagbtn2.png");
		this.h3.className = (this.isCloud ? "tag-cloud" : "tag-rank");
		this.tagCloud.style.display = ( this.isCloud ? "block" : "none");
		this.tagRank .style.display = (!this.isCloud ? "block" : "none");
	}
};


//--------------------------------------
//  Domain Rank
//--------------------------------------

var DomainRank = {
	div: null,

	init: function(div){
		this.div = div;

		// get prev rank
		var prevRank = null;
		if(BoxView.index > 0){
			prevRank = Summary.getDomainRankOf(BoxView.curList, BoxView.index - 1);
		}

		var domain = null;
		var ols = div.getElementsByTagName("OL");
		for(var i = 0; i < ols.length; i++){
			child = ols[i];
			if(child.tagName == 'OL' && child.className == 'domain-rank'){
				domain = child;
				break;
			}
		}
		if(!domain) return;

		var lis = $.makeArray(domain.getElementsByTagName("LI"));
		var max = 1000;
		for(var i = 0; i < lis.length; i++){
			var li = lis[i];
			if(i < 10){
				var val = li.firstChild.nodeValue;
				if(SITES[li.firstChild.nodeValue]){
					li.firstChild.nodeValue = SITES[li.firstChild.nodeValue];
				}
				li.style.backgroundImage = "url('" + getFavicon("http://" + val + "/") + "')";
				if(i % 2 == 1) li.className = "odd";

				// XXX users
				var span = li.getElementsByTagName("span")[0];
				if(span){
					var count = parseInt(span.firstChild.nodeValue);
					if(i == 0) max = count;
					span.removeChild(span.firstChild);
					span.appendChild(document.createTextNode(count + " users"));

					// background
					var bg = document.createElement("div");
					bg.style.top = span.offsetTop.px();
					bg.style.width = (130 * count / max).px();
					li.insertBefore(bg, span);
				}

				if(prevRank){
					var img = document.createElement("img");
					if(prevRank[val] == null || i + 1 < prevRank[val]){img.src = "arrow_up.png";}
					else if(i + 1 == prevRank[val]){img.src = "arrow_right.png";}
					else{img.src = "arrow_down.png";}
					li.appendChild(img);
				}
			}else{
				domain.removeChild(li);
			}
		}

		$(domain).click(function(event){
			var target = event.target;
			while(target){
				if(target.tagName == "LI"){
					event.preventDefault();
					event.stopPropagation();

					var domain = target.style.backgroundImage;
					domain = domain.replace("http://favicon.hatena.ne.jp/?url=", "").replace(/^.*\/\/([^\/]+).*/, "$1");
					PopupGraph.show(domain, 'domain');
					return;
				}
				target = target.parentNode;
			}
		});
	}
}

//--------------------------------------
//  Permalink
//--------------------------------------

var Permalink = {
	init: function(div){
		var yearly = (BoxView.type == 'yearly');
		var id;
		if(yearly){
			id = BoxView.year;
		}else{
			id = (BoxView.year) * 100 + BoxView.month;
		}
		var url = location.href.replace(/#.*/, "") + "#" + id;

		var container = document.createElement("div");
		container.id = "permalink";
		div.appendChild(container);

		var label = document.createElement("label");
		label.htmlFor = "permalink_url";
		container.appendChild(label);

		var input = document.createElement("input");
		input.id = "permalink_url";
		input.type = "text";
		input.value = url;
		container.appendChild(input);
		$(input).click(function(event){this.select()});
	}
};

//--------------------------------------
//  Header
//--------------------------------------

Header = {
	view: null,
	yearlyLink: null,
	monthlyLink: null,

	init: function(view){
		this.view = view;
		var links = $("#header a");
		this.yearlyLink = links[0];
		this.monthlyLink = links[1];
		this.aboutLink = links[2];

		$("#header").click(function(event){Header.clicked(event)});
		$(BoxView).bind("change", function(event){Header.update()});
		this.update();
	},

	update: function(){
		this.setSelected(this.yearlyLink, (BoxView.type == 'yearly'));
		this.setSelected(this.monthlyLink, (BoxView.type == 'monthly'));
		this.setSelected(this.aboutLink, (BoxView.type == 'about'));
	},

	setSelected: function(a, f){
		a.className = (f ? "selected" : "");
	},

	clicked: function(event){
		event.preventDefault();
		if(event.target == this.yearlyLink){
			this.view.setType('yearly');
		}else if(event.target == this.monthlyLink){
			this.view.setType('monthly');
		}else if(event.target == this.aboutLink){
			this.view.setType('about');
		}
		this.update();
	}
};


//--------------------------------------
//  Pager
//--------------------------------------

Pager = {
	init: function(){
		var x = (PARAM.BOX_MARGIN * 2 + PARAM.BOX_WIDTH - 20);
		var y = 300;
		var h = document.documentElement.clientHeight;

		this.left = $("<img/>")
			.addClass('pager')
			.appendTo($("body"))
			.css({
				position: 'absolute',
				top: y.px(),
				left: '10px',
				cursor: 'pointer'
			})
			.attr("src", "left.png")
			.click(this.prev);

		this.right = $("<img/>")
			.addClass('pager')
			.appendTo($("body"))
			.css({
				position: 'absolute',
				left: x.px(),
				top: y.px(),
				cursor: 'pointer'
			})
			.attr("src", "right.png")
			.click(this.next);

		var self = this;
		$(BoxView).bind("change", function(event){Pager.update()});
		Pager.update();
	},

	update: function(){
		this.enable(this.left, BoxView.index != 0);
		this.enable(this.right, BoxView.index != BoxView.curList.length - 1);
	},

	enable: function(elem, val){
		elem.css({
			opacity: val ? 1 : 0.2,
			cursor: val ? 'pointer' : 'default'
		});
	},

	prev: function(event){
		BoxView.prev();
	},
	next: function(event){
		BoxView.next();
	}
};


//--------------------------------------
//  Timeline
//--------------------------------------

var Timeline = {
	WIDTH: 60,

	init: function(){
		var y1 = 2005, y2 = y1 + Doc.yearList.length - 1;
		this.x = PARAM.BOX_WIDTH - (y2 - y1) * this.WIDTH - 25;
		var width = (y2 - y1 + 1) * this.WIDTH;

		this.box = $("<div/>")
			.attr("id", "timeline")
			.css({
				left: this.x + "px",
				width: width + "px"
			})
			.click(this.clicked);

		for(var y = y1; y <= y2; y++){
			var a = $("<span></span>")
				.text(y)
				.css({
					left: ((y - y1) * this.WIDTH) + 'px'
				})
				.appendTo(this.box);
		}

		this.sel = $("<img/>")
			.attr({
				src: 'selector.png'
			})
			.appendTo(this.box)[0];

		$(BoxView).bind("change", function(event){
			Timeline.update();
		});
		Timeline.update(true);

		this.box.appendTo("body")
	},

	update: function(now){
		if(BoxView.type == 'about'){
			this.box.hide();
			return;
		}

		this.box.show();
		var isYear = (BoxView.type == 'yearly');
		var x = (isYear ? BoxView.index * this.WIDTH : (BoxView.index + 1) * this.WIDTH / 12 - 4);

		if(BoxView.type != this.prevType){
			this.sel.src = (isYear ? 'selector1.png' : 'selector2.png');
			if(now){
				this.sel.width = (BoxView.type == 'yearly' ? 59 : 14);
				this.sel.height = 14;
				this.sel.style.left = x + 'px';
			}else{
				this.sel.width = (BoxView.type != 'yearly' ? 59 : 14);
				this.sel.height = 14;
				$(this.sel).animate({left: x, width: (isYear ? 59 : 14)}, 700, 'easeOutCubic');
			}
		}else{
			if(now)
				this.sel.style.left = x + 'px';
			else
				$(this.sel).animate({left: x}, now ? 0 : 700, 'easeOutCubic');
		}

		this.prevType = BoxView.type;
	},

	clicked: function(event){
		event.preventDefault();

		setTimeout(function(){
			var m = Math.floor((event.pageX - Timeline.x) / Timeline.WIDTH * 12);
			var y = Math.floor(m / 12);
			m %= 12;
			if(BoxView.type == 'yearly') BoxView.moveTo(y);
			else BoxView.moveTo(y * 12 + m - 1);
		}, 100);
	}
};


//--------------------------------------
//  PopupGraph
//--------------------------------------

var PopupGraph = {
	bg: null,
	container: null,

	show: function(target, type){
		var data, title, img;
		if(type == 'domain'){
			data = Summary.domain(target);
			title = "「" + (SITES[target] ? SITES[target] : target) + "」の順位変動";
			img = getFavicon("http://" + target + "/");
		}else{
			data = Summary.tag(target);
			title = "「" + target + "」の順位変動";
			img = "tag.png";
		}

		this.createDialog(title, data, img);
	},

	createDialog: function(title, data, img){
		var size1 = getDocumentSize();
		var size2 = getViewportSize();

		this.bg = $("<div></div>")
			.attr("id", "background")
			.width(size1[0])
			.height(size1[1])
			.css({
				opacity: "0.6"
			})
			.appendTo("body");
		this.container = $("<div></div>")
			.attr("id", "popup")
			.css({
				left: (size2[0] - 400) / 2,
				top: (size2[1] - 300) / 2 + (window.scrollY || document.documentElement.scrollTop)
			})
			.appendTo("body")
			.get(0);
		$("<h3></h3>")
			.css({
				'backgroundImage': 'url("' + img + '")'
			})
			.text(title)
			.appendTo(this.container);
		$("<div></div>")
			.attr("id", "graph_container")
			.text("Loading...")
			.appendTo(this.container);
		this.closeButton = $("<button>閉じる</button>")
			.click(this.close)
			.appendTo(
				$("<center></center>").appendTo(this.container)
			)
			.get(0);

		var so = new SWFObject("graph.swf", "graph", "400", "200", "9", "#ffffff");
		so.addVariable("rank", data.join(','));
		so.write("graph_container");

		setTimeout(function(){$("body").click(PopupGraph.close);}, 0);
	},

	monthClick: function(y, m){
		BoxView.setType("monthly", y, m);
		setTimeout(function(){PopupGraph.close();}, 0);
	},

	close: function(event){
		if(event){
			var target = event.target;
			while(target){
				if(target == PopupGraph.container) return;
				if(target == PopupGraph.closeButton) break;
				target = target.parentNode;
			}
		}

		if(PopupGraph.bg) PopupGraph.bg.remove();
		if(PopupGraph.container) $(PopupGraph.container).remove();
		$("body")
			.unbind("click", PopupGraph.close);
	}
};


//--------------------------------------
//  Summary
//--------------------------------------

var Summary = {
	getTagRankOf: function(list, index, asArray){
		var lis = this.getLiByClassName(list[index], "tag-cloud");
		if(!lis) return;

		var ret = (asArray ? [] : {});
		for(var j = 0; j < lis.length; j++){
			var li = lis[j];
			var tagValue = li.firstChild.nodeValue;
			var rank = parseInt(li.className.replace("tag", ""));
			asArray ? ret[rank] = tagValue : ret[tagValue] = rank;
		}
		return ret;
	},

	tag: function(tag){
		var list = Doc.monthList;

		var ranks = [];
		for(var i = 0; i < list.length; i++){
			var lis = this.getLiByClassName(list[i], "tag-cloud");
			if(!lis) return;

			var rank = -1;
			for(var j = 0; j < lis.length; j++){
				var li = lis[j];
				var tagValue = li.firstChild.nodeValue;
				if(tag == tagValue){
					rank = parseInt(li.className.replace("tag", ""));
					break;
				}
			}

			ranks[i] = rank;
		}

		return ranks;
	},

	getDomainRankOf: function(list, index){
		var lis = this.getLiByClassName(list[index], "domain-rank");
		if(!lis) return;

		var ret = {};
		for(var j = 0; j < lis.length; j++){
			var li = lis[j];
			var tagValue = li.firstChild.nodeValue;
			ret[tagValue] = j + 1;
		}
		return ret;
	},

	domain: function(domain){
		var list = Doc.monthList;

		var ranks = [];
		for(var i = 0; i < list.length; i++){
			var r = this.getDomainRankOf(list, i);
			ranks[i] = r[domain] ? r[domain] : -1;
		}

		return ranks;
	},

	getLiByClassName: function(div, className){
		var ols = div.getElementsByTagName("ol");
		for(var i = 0; i < ols.length; i++){
			if(ols[i].className == className){
				return ols[i].getElementsByTagName("li");
			}
		}
	}
};

