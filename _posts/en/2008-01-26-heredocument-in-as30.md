---
layout: post
title: Here-document in AS3.0
lang: en
tag: ActionScript
---
Here-document is not implemented in AS3... But we can realize it using E4X and `CDATA` section!!

{% highlight actionscript %}
    var s:String = <><![CDATA[bar
foo
<p class="test">Any text here</p>

Ohhhhhhh!!!!!
]]></>;

    trace(s);
/* 
bar
foo
<p class="test">Any text here</p>

Ohhhhhhh!!!!!
*/
{% endhighlight %}

You don't have to escape `"` and `\` in the here-document.