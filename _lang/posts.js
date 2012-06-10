---
---
var Site = {
	lang: "{{ page.lang }}", 
	locale: "{{ 'locale'|t }}",
	archives: {}
};

{% include enum-lang-posts.html %}
Site.archives.posts = [
{% for post in posts limit:5%}{% unless forloop.first %},
{% endunless %}	{url: {{post.url | json}}, title: {{post.title | json}}}{% endfor %}
];

Site.archives.monthes = [
{% for post in site.posts %}{% capture this_year %}{{ post.date | date: "%Y" }}{% endcapture %}{% capture this_month %}{{ post.date | date: "%m" }}{% endcapture %}{% capture next_year %}{{ post.previous.date | date: "%Y" }}{% endcapture %}{% capture next_month %}{{ post.previous.date | date: "%m" }}{% endcapture %}{% if forloop.first %}  "{{this_year}}{{this_month}}"
{% elsif forloop.last %}{% elsif this_year != next_year %}, "{{this_year}}{{this_month}}"
{% elsif this_month != next_month %}, "{{this_year}}{{this_month}}"
{% endif %}{% endfor %}];