$(function(){
	var ul = $("ul#recententries_list");
	ul.children().remove();
	for (var i = 0; i < Archives.posts.length; i++) {
		var post = Archives.posts[i];
		$("<li></li>")
			.append($("<a>").attr("href", post.url).text(post.title))
			.appendTo(ul);
	}

	var list = $("ul#archive_month_list").remove("li");
	list.children().remove();
	var year_li;
	var year = 0;
	var month_en = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
	for (i = Archives.monthes.length - 1; i >= 0; i--) {
		var ys = Archives.monthes[i].substr(0, 4),
		    ms = Archives.monthes[i].substr(4);
		var y = parseInt(ys, 10),
		    m = parseInt(ms, 10);
		if (y != year) {
			year_li = $("<li>").appendTo(list);
			$("<a>")
				.attr("href", "/en/blog/" + ys + "/")
				.addClass("year")
				.text(ys + ": ")
				.appendTo(year_li);
			year = y;
		}
		$("<span>").addClass("delimiter").text(" | ").appendTo(year_li);
		$("<a>")
			.attr("href", "/en/blog/" + ys + "/" + ms + "/")
			.addClass("month")
			.text(month_en[m - 1])
			.appendTo(year_li);
	}
});

var _gaq = window._gaq || [];
_gaq.push(['_setAccount', 'UA-1616138-1']);
_gaq.push(['_trackPageview']);
(function(d,e){
	var js,
	fjs=d.getElementsByTagName(e)[0],
	add = function(src, id){
		if(d.getElementById(id)) return;
		js = d.createElement(e);
		js.id = id;
		js.src = src;
		js.async = true;
		fjs.parentNode.insertBefore(js,fjs);
	};

	add(('https:'==location.protocol?'//ssl':'//www')+'.google-analytics.com/ga.js');
	add('//platform.twitter.com/widgets.js', 'twitter-wjs');
	add('//connect.facebook.net/en_US/all.js#xfbml=1', 'facebook-jssdk');
}(document,'script'));