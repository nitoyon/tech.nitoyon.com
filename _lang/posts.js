---
---
var Site = {
	lang: "{{ page.lang }}", 
	locale: "{{ 'locale'|t }}",
	archives: {}
};

Site.archives.posts = [
{% for post in site.posts limit:5%}{% unless forloop.first %},
{% endunless %}	{url: {{post.url | jsonify}}, title: {{post.title | jsonify}}}{% endfor %}
];

Site.archives.months = [
{% for post in site.posts %}{% capture this_year %}{{ post.date | date: "%Y" }}{% endcapture %}{% capture this_month %}{{ post.date | date: "%m" }}{% endcapture %}{% capture next_year %}{{ post.next.date | date: "%Y" }}{% endcapture %}{% capture next_month %}{{ post.next.date | date: "%m" }}{% endcapture %}{% if forloop.first %}  "{{this_year}}{{this_month}}"
{% elsif forloop.last %}{% elsif this_year != next_year %}, "{{this_year}}{{this_month}}"
{% elsif this_month != next_month %}, "{{this_year}}{{this_month}}"
{% endif %}{% endfor %}];