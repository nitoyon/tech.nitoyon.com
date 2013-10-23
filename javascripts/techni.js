(function(){
$(function(){
  showAlternateLangIfNecessary();

	var ul = $("ul#recententries_list");
	ul.children().remove();
	for (var i = 0; i < Site.archives.posts.length; i++) {
		var post = Site.archives.posts[i];
		$("<li></li>")
			.append($("<a>").attr("href", post.url).text(post.title))
			.appendTo(ul);
	}

	function get_year_month_list() {
		var ret = [];
		var year = 0;
		for (var i = Site.archives.months.length - 1; i >= 0; i--) {
			var ys = Site.archives.months[i].substr(0, 4),
			    ms = Site.archives.months[i].substr(4);
			var y = parseInt(ys, 10),
			    m = parseInt(ms, 10);
			if (y != year) {
				ret[y] = [];
			}
			ret[y].push(m);
			year = y;
		}
		return ret;
	}

	var list = $("ul#archive_month_list");
	list.children().remove();
	var is_en = (Site.lang == "en");
	var month_str = is_en ?
		["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"] :
		["01月", "02月", "03月", "04月", "05月", "06月", "07月", "08月", "09月", "10月", "11月", "12月" ];
	var path = "/" + Site.lang + "/blog/";

	var ym_list = get_year_month_list();
	for (var year in ym_list) {
		var year_li = $("<li>").addClass("year").prependTo(list);
		$("<a>")
			.attr("href", path + year + "/")
			.addClass("year")
			.text(year + (is_en ? ": " : "年: "))
			.appendTo(year_li);

		var m = 0;
		var ul = $("<ul>").addClass("monthes").appendTo(year_li);
		for (var month = 1; month <= 12; month++) {
			var ms = (month < 10 ? "0" + month : month);
			var month_li = $("<li>").appendTo(ul);
			if (ym_list[year][m] == month) {
				$("<a>")
					.attr("href", path + year + "/" + ms + "/")
					.addClass("month")
					.text(month_str[month - 1])
					.appendTo(month_li);
				m++;
			} else {
				$("<span>")
					.addClass("month")
					.text(month_str[month - 1])
					.appendTo(month_li);
			}
			if (month == 6) {
				$("<br>").appendTo(month_li);
			}
		}
	}
});

function showAlternateLangIfNecessary(){
	var lang = navigator.browserLanguage || navigator.language || navigator.userLanguage || "en";
	lang = (lang.substr(0, 2) == "ja" ? "ja" : "en");
	$("#alternate-" + lang + "-notice").show();
}
})();

var _gaq = window._gaq || [];
_gaq.push(['_setAccount', 'UA-1616138-1']);
_gaq.push(['_trackPageview']);
(function(d,e){
	var js,
	jss=d.getElementsByTagName(e),
	fjs=jss[jss.length-1],
	add = function(src, id){
		if(d.getElementById(id)) return;
		js = d.createElement(e);
		js.id = id;
		js.src = src;
		js.async = true;
		fjs.parentNode.insertBefore(js,fjs);
	};

	add(('https:'==location.protocol?'//ssl':'//www')+'.google-analytics.com/ga.js', 'ga_embed');

	if ($("div.share").length) {
		add('//platform.twitter.com/widgets.js', 'twitter-wjs');
		add('//connect.facebook.net/' + (Site.lang == "ja" ? "ja_JP" : "en_US") + '/all.js#xfbml=1&appId=306142992832693', 'facebook-jssdk');
		if (Site.lang == "ja") {
			add('http://b.st-hatena.com/js/bookmark_button.js', 'b_hatena_js');
		}
		window.disqus_shortname = "techni-" + Site.lang;
		add('http://' + window.disqus_shortname + '.disqus.com/embed.js', 'dsq_embed');
	}
}(document,'script'));