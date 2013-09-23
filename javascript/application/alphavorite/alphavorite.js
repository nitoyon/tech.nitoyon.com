delete Object.prototype.extend;

// 集計方法
var analyzers = {
	count : {
		name : "各1pt",
		point : function(){return 1;},
		pixelPerRatio : 16
	},

	fav : {
		name : "被Fav数",
		point : function(hifav, fav, fromid, toid){return hifav},
		pixelPerRatio : 0.16
	},

	fav_ratio : {
		name : "被Fav数 / Fav数",
		point : function(hifav, fav, fromid, toid){return fav != 0 ? hifav / fav : 0},
		pixelPerRatio : 1.6
	}
};

// 
function analyze(options){
	var result = {};
	options = options || {};

	var id_list = [];
	for(var id in fav){
		id_list.push(id);
	}
	var id_size = id_list.length;

	function analyzeOne(){
		if(id_list.length == 0){
			if(typeof options.onComplete == "function") options.onComplete(result);
			return;
		}
		
		var id = id_list.shift();
		var f = fav[id];
		//var param_add = f.favorite.length != 0 ? f.count / f.favorite.length : 0;
		for(var i = 0; i < f.favorite.length; i++){
			var _id = f.favorite[i];
			if(result[_id] == undefined) result[_id] = {count : 0, refer : []};
			var r = result[_id];
			r.refer.push(id);

			for(var type in analyzers){
				if(r[type] == undefined) r[type] = 0;
				r[type] += analyzers[type].point(f.count, f.favorite.length, id, _id);
			}
		}

		if(typeof options.onProgress == "function") options.onProgress(id_list.length / id_size, id);

		setTimeout(analyzeOne, 10);
	};
	analyzeOne();
}


function iconUrl(id, flag){
	if(typeof id != "string"){
		return "";
	}

	var size = flag ? 60 : 16;
	return "http://www.hatena.ne.jp/users/" + id.substr(0, 2) + "/" + id + "/profile" + (flag ? "" : "_s") + ".gif";
}

function iconImg(id, flag){
	if(typeof id != "string"){
		return TAG("img");
	}

	var size = flag ? 60 : 16;
	return TAG("img", {src : iconUrl(id, flag), width : size, height : size, alt : ""}, {cursor: 'pointer'});
}

function imgToHatenaId(img){
	if(img && img.tagName == "IMG" && img.src.match(/\/([^/]+)\/profile(_s)?.gif/)){
		return RegExp.$1;
	}
}

function getClassByHatenaId(id){
	if(isOodanna(id)) return "oodanna";
	if(isDannashu(id)) return "dannashu";
	if(isWakadanna(id)) return "wakadanna";
	return "";
}

function TAG(tagName, attr, css){
	var el = document.createElement(tagName);

	if(attr) Object.extend(el, attr);
	if(css) Object.extend(el.style, css);
	return el;
}

function TEXT(text){
	return document.createTextNode(text);
}

var Graph = {
	count_max : 200,

	initialize : function(){
		this.graph = $("graph");
		if(this.graph) Event.observe(document, "click", this.onClick.bindAsEventListener(this));
	},
	
	setScores : function(scores){
		this.scores = scores;
	},

	isDrawing : function(){
		return this.timer != null;
	},

	stopDrawing : function(){
		if(this.timer){
			clearTimeout(this.timer);
			this.timer = null;
		}
	},

	updateRank : function(){
		if(this.rank && this.curScoreType == Cond.score) return;

		this.rank = [];
		for(var id in this.scores){
			var p = this.scores[id];
			this.rank.push(Object.extend(p, {id : id}));
		}

		this.rank.sort(function(a, b){return b[Cond.score] - a[Cond.score]});
		this.curScaleType = Cond.score;
	},

	draw : function(){
		if(this.isDrawing) this.stopDrawing();
		this.updateRank();

		var graph = this.graph;
		graph.innerHTML = "";

		var rank = this.rank;
		var index = 0;
		var count = 0;
		function outputOne(){
			var i = 0;
			while(i < 5){
				if(index >= rank.length || count >= Graph.count_max){
					Graph.timer = null;
					return;
				}

				var p = rank[index++];
				if(Cond.d1 && isOodanna(p.id)
				|| Cond.d2 && isDannashu(p.id)
				|| Cond.d3 && isWakadanna(p.id)){
					continue;
				}
				else{
					var div = Graph.createBar(p, ++count);
					graph.appendChild(div);
				}
				i++;
			}
			Graph.timer = setTimeout(outputOne, 1);
		}

		outputOne();
	},

	createBar : function(p, count){
		var div = TAG("div", {className : "bar" + ((count % 2) == 0 ? " odd" : "")});

		var span0 = TAG("span", {className : "rank " + getClassByHatenaId(p.id)});
		div.appendChild(span0);
		span0.appendChild(TEXT(count + "."));

		var span1 = TAG("span", {className : "name " + getClassByHatenaId(p.id)});
		div.appendChild(span1);
		span1.appendChild(iconImg(p.id));
		span1.appendChild(TAG("span", {className : "name_id"})).appendChild(TEXT(" " + p.id));

		var span2 = TAG("span", {className : "score"});
		div.appendChild(span2);

		var analyzer = analyzers[Cond.score];
		if(analyzer == null) return div;
		for(var i = 0; i < p.refer.length; i++){
			var id = p.refer[i];
			var w = 16;
			w = analyzer.point(fav[id].count, fav[id].favorite.length, id, p.id) * analyzer.pixelPerRatio;
			var img = iconImg(id, w > 32);
			img.width = w;
			img.height = 16;
			span2.appendChild(img);
		}
		span2.appendChild(TEXT(" " + (Math.floor(p[Cond.score] * 10) / 10)));

		return div;
	},

	onClick : function(event){
		var src = Event.element(event);

		// ロードリンク
		if(src.tagName == "A" && src.hash && src.hash.substr(0, 1) == "#"){
			JsonLoad.init(src.hash.substr(1), src.parentNode);
			Event.stop(event);
			event.cancelBubble = true;
			return;
		}

		// カードの表示処理
		if(src.tagName == "SPAN" && src.className == "name_id"){
			src = src.previousSibling;
		}
		if(src.tagName == "IMG" && src.height == 16){
			this.showCard(src);
			Tooltip.hide();
		}
		else{
			// それ以外
			while(src){
				if(src == this.card) return;
				src = src.parentNode;
			}
			if(this.card) Element.hide(this.card);
			return;
		}
	},

	showCard : function(src){
		var id = imgToHatenaId(src);
		if(!this.card){
			this.card = TAG("div", {id : "card"});
			document.body.appendChild(this.card);
			Element.hide(this.card);
		}

		this._setCardHtml(id);
	},

	_setCardHtml : function(id){
		var score = this.scores[id];

		this.card.innerHTML = "";
		var head = TAG("div", {className : "header"});
		var h2 = TAG("h2");
		var a = h2.appendChild(TAG("a", {href : "http://b.hatena.ne.jp/" + id + "/"}));
		a.appendChild(iconImg(id, true));
		a.appendChild(TEXT(id));
		head.appendChild(h2);
		head.innerHTML += "<div class='cls'>" + (isOodanna(id) ? "大旦那 (被お気に入り100以上)" : isDannashu(id) ? "旦那衆 (被お気に入り30～99)" : isWakadanna(id) ? "若旦那 (被お気に入り25～29)" : "階級なし (被お気に入り25未満)") + "</div></div>";

		var body = TAG("div", {className : "body"});
		body.innerHTML = "<h3>被お気に入り (" + (oodanna[id] || dannashu[id] || wakadanna[id] || "－") + ")</h3>"
		     + "<p>うち大旦那 : " + (score && score.count || "－") + "</p>";
		var p = TAG("p");
		for(var i = 0; score && i < score.refer.length; i++){
			var _id = score.refer[i];
			p.appendChild(iconImg(_id));
		}
		body.appendChild(p);
		body.innerHTML += "<h3>お気に入り (" + (fav[id] ? fav[id].favorite.length : "－") + ")</h3>";
		var p = TAG("p");
		for(var i = 0; fav[id] && i < fav[id].favorite.length; i++){
			p.appendChild(iconImg(fav[id].favorite[i]));
		}
		body.appendChild(p);
		body.innerHTML += '<h3>最近のブックマーク</h3><div class="bkm"><a href="#' + id + '" style="font-size: 90%">見てみる</a></div>';

		this.card.appendChild(head);
		this.card.appendChild(body);
		Element.show(this.card);
	}
}


Cond = {
	initialize : function(form){
		if(!form) return;
		this.url = location.href.replace(/#.*/, "");
		this.form = form;
		Event.observe(form, "click", Cond.onclick.bindAsEventListener(this));
		Event.observe(form.score, "change", Cond.onchange.bindAsEventListener(this));
		this.updateSelect();

		if(location.href.match(/#type=([^&]+)&check=(\d)(\d)(\d)/)){
			this.d1 = this.form.d1.checked = RegExp.$2 == "1";
			this.d2 = this.form.d2.checked = RegExp.$3 == "1";
			this.d3 = this.form.d3.checked = RegExp.$4 == "1";
			this.score = RegExp.$1;
		}

		var index = this.getIndex(this.score);
		index = this.form.score.selectedIndex = (index != -1 ? index : 0);
		this.score = this.form.score.options[index].value;
	},

	getIndex : function(name){
		var options = this.form.score.options;
		for(var i = 0; i < options.length; i++){
			if(name == options[i].value){
				return i;
			}
		}
		return -1;
	},

	updateSelect : function(){
		var options = this.form.score.options;
		
		for(var i in analyzers){
			if(this.getIndex(i) == -1){
				options[options.length] = new Option(analyzers[i].name, i);
			}
		}
	},

	update : function(){
		this.d1 = this.form.d1.checked;
		this.d2 = this.form.d2.checked;
		this.d3 = this.form.d3.checked;

		var index = this.form.score.selectedIndex;
		this.score = this.form.score.options[index].value;
		if(!this.score in analyzers){
			alert("定義されていない集計方法です");
			this.score = "fav";
		}

		this.updateSelect();
		function _bti(f){return f ? "1" : "0";}
		location.href = this.url + "#type=" + this.score + "&check=" + _bti(this.d1) + _bti(this.d2) + _bti(this.d3);

		Graph.stopDrawing();
		setTimeout(function(){Graph.draw();}, 10);
	},

	onclick : function(event){
		if(Event.element(event).tagName == "INPUT"){
			this.update();
		}
	},

	onchange : function(event){
		this.update();
	}
};


var JsonLoad = {
	proxy : 'http://app.drk7.jp/xml2json/',
	
	init : function(id, elm){
		this.stop();
		
		var script = document.createElement('script');
		this.loading = true;
		this.script = script;
		this.elm = elm;
		elm.innerHTML = "";
		elm.appendChild(TAG("img", {src : "loading.gif"}));
		elm.appendChild(TEXT("Loading..."));

		script.charset = 'UTF-8';
		script.src = this.proxy + 'var=JsonLoad&url=' + escape('http://b.hatena.ne.jp/' + id + '/rss');
		document.body.appendChild(script);
	},

	stop : function(){
		this.loading = false;
		if(this.script){
			if(this.script.parentNode) Element.remove(this.script);
			this.script = null;
		}
	},

	onload : function(data){
		if(!data || !data.item){
			JsonLoad.elm.innerHTML = "";
			return;
		}

		var str = "";
		for(var i = 0; i < Math.min(30, data.item.length); i++){
			var item = data.item[i];
			str += '<div class="entry"><div class="link"><a href="' + item.link + '">' + item.title + '</a> '
			     + '<a href="http://b.hatena.ne.jp/entry/' + encodeURI(item.link) + '"><img src="http://b.hatena.ne.jp/entry/image/' + encodeURI(item.link) + '"></a></div>';

			var comment = "";
			if(typeof item["dc:subject"] == "string") item["dc:subject"] = [item["dc:subject"]];
			for(var j = 0; item["dc:subject"] && j < item["dc:subject"].length; j++){
				comment += "[" + item["dc:subject"][j] + "]";
			}
			comment += typeof item.description == "string" ? item.description : "";
			if(comment != "") str += '<div class="comment">' + comment + '</div>';
			str += "</div>";
		}
		JsonLoad.elm.innerHTML = str;

		//JsonLoad.stop();
	}
};


var Tooltip = {
	initialize : function(){
		if(!$("tooltip")){
			document.body.appendChild(TAG("div", {id : "tooltip"}));
		}

		this.el = $("tooltip");
		Element.hide($("tooltip"));
	},

	show : function(event){
		if(!this.el) return;

		var src = Event.element(event);
		this.el.innerHTML = imgToHatenaId(src);
		this.el.style.left = (Event.pointerX(event) + 16) + "px";
		this.el.style.top = (Event.pointerY(event) + 8) + "px";
		Element.show(this.el);
	},

	hide : function(){
		if(!this.el) return;
		Element.hide(this.el);
	}
}

window.onload = function(){
	Graph.initialize();
	Cond.initialize(document.forms[0]);
	Tooltip.initialize();

	Event.observe(document, "mousemove", function(event){
		var src = Event.element(event);
		var tooltip = $("tooltip");
		if(src.tagName != "IMG" || !src.src.match(/\/profile(_s)?.gif/i) || src.height != 16 || Element.hasClassName(src.parentNode, "name")){
			Tooltip.hide(event);
			return;
		}
		
		Tooltip.show(event);
	});
	
	analyze({
		onComplete : function(scores){
			Element.hide("message");
			
			Graph.setScores(scores);
			Graph.draw();
		},

		onProgress : function(remaining, id){
			remaining = Math.floor((1-remaining) * 1000) / 10;
			$("message").innerHTML = "計算中：" + remaining + "%";
		}
	});
}