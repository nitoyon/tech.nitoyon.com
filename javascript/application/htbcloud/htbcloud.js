var HatebuTagCloud = Class.create();
HatebuTagCloud.prototype = {
	// id : "nitoyon", 
	id : null,

	// タグクラウドの段階数と最小サイズ
	levels : 24,
	smallest : 12,

	initialize : function(div){
		this.trackElm = document.getElementsByClassName("track", div)[0] || div.appendChild(this._DIV("track"));
		this.sliderElm = document.getElementsByClassName("slider", this.trackElm)[0] || this.trackElm.appendChild(this._DIV("slider"));
		this.month = div.getElementsByTagName("h3")[0] || div.appendChild(document.createElement("h3"));
		this.cloud = document.getElementsByClassName("tagcloud", div)[0] || div.appendChild(this._DIV("tagcloud"));

		if(!window.monthTags){
			alert("HatebuTagCloud: monthTags を読み取れません。data.js が同じフォルダにあるか確認してください。");
			return;
		}
		this.monthTags = $H(monthTags);

		if(!div){
			alert("HatebuTagCloud: 引数のタグが null でした。タグクラウドを表示する div エレメントを指定してください。");
			return;
		}

		this.update();
	},

	_DIV : function(className, styles){
		var d = document.createElement("div");
		if(className) d.className = className;
		if(styles) Element.setStyle(d, styles);
		return d;
	},
	
	onSlide : function(v){
		var m = this.monthKeys[v - 1];
		if(m == this.m) return;
		this.m = m;

		var mm = this.monthTags[m];
		this.month.innerHTML = m.substr(0,4) + "年" + m.substr(4, 2) + "月 <span class='count'>タグ数/エントリ数 = " + (mm.entry != 0 ? Math.floor(mm.tag/mm.entry * 100) / 100 : 0) + " (" +  mm.tag + "/" + mm.entry + ")</span>";
		var scores = mm.tags;
		var min = 9999999, max = 0;
		var keys = [];
		for(var key in scores){
			keys.push(key);
			min = Math.min(min, scores[key]);
			max = Math.max(max, scores[key]);
		}
		var factor;
		if(min == max){
			factor = 1;
		}
		else{
			factor = this.levels / (max - min);
		}

		var html = "";
		keys.sort();
		for(var i = 0; i < keys.length; i++){
			var key = keys[i];
			var v = scores[key];
			var size = this.smallest + (v - min) * factor;
			var url = (this.id ? "http://b.hatena.ne.jp/" + this.id + "/" + encodeURI(key) + "/" : "#" + encodeURI(key));
			html += '<a href="' + url + '" style="font-size: ' + size + 'px">' + key +'</a> ';
		}
		this.cloud.innerHTML = html;
	},

	show : function(){
		var keys = this.monthKeys;
		if(keys.length == 0){
			this.cloud.innerHTML = "";
			this.month.innerHTML = "データがありません";
			return;
		}

		var values = keys.collect(function(v, i){return i + 1});
		var options = {range:$R(1, keys.length), values: values, sliderValue : keys.length, onSlide : this.onSlide.bind(this)};
		options.onChange = options.onSlide;
		this.slider = new Control.Slider(this.sliderElm, this.trackElm, options);
		this.onSlide(keys.length);
	},

	update : function(){
		if(this.slider){
			this.slider.dispose();
		}

		this.monthTags = $H(monthTags);
		this.monthKeys = this.monthTags.keys().sort();
		this.m = null;
		this.show();
	}
}

