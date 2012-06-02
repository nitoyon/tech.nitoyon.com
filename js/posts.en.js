---
lang: en
---
var Archives = {};
Archives.posts = [
{% for post in site.posts limit:5%}{% unless forloop.first %},
{% endunless %}	{url: {{post.url | json}}, title: {{post.title | json}}}{% endfor %}
];

Archives.monthes = [
{% for post in site.posts %}{% capture this_year %}{{ post.date | date: "%Y" }}{% endcapture %}{% capture this_month %}{{ post.date | date: "%m" }}{% endcapture %}{% capture next_year %}{{ post.previous.date | date: "%Y" }}{% endcapture %}{% capture next_month %}{{ post.previous.date | date: "%m" }}{% endcapture %}{% if forloop.first %}  "{{this_year}}{{this_month}}"
{% endif %}{% if forloop.last %}{% elsif this_year != next_year %}, "{{next_year}}{{next_month}}"
{% elsif this_month != next_month %}, "{{next_year}}{{next_month}}"
{% endif %}{% endfor %}];