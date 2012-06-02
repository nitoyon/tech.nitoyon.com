#!/usr/bin/env ruby19
module Jekyll
	class CustomPage < Page
		def initialize(site, base, dir, layout,name='index.html')
			@site = site
			@base = base
			@dir	= dir
			@name = name
			
			self.process(@name)
			self.read_yaml(File.join(base, '_layouts'), layout + '.html')
		end
		
		def check_cache(name, filename, custom_url=nil)
			cache = "_cache/#{name}-#{filename}.cache"
			# cache = "_cache/#{name}#{filename}.cache"
			data = ""
			
			if !File.exists?(cache) then
				# this stuff is bit hackish, but it works
				# this will fail if the file isn't present
				puts "https://raw.github.com/#{site.config['github_user']}/#{name}/master/#{filename}"
				url = custom_url ? custom_url : "https://raw.github.com/#{site.config['github_user']}/#{name}/master/#{filename}"
				data = `curl #{url}` 
				data.gsub!(/\`{3} ?(\w+)\n(.+?)\n\`{3}/m, "{% highlight \\1 %}\n\\2\n{% endhighlight %}")
				data = Liquid::Template.parse(data).render(
					{}, :filters => [Jekyll::Filters], :registers => { :site => site }
				)
				File.open(cache, "w") { |f| f.puts data } 
			else 
				data = IO.read cache
			end
			return data
		end
		
	end
	
	class Site
		def write_page(page)
			page.render(self.layouts, site_payload)
			page.write(self.dest)
			self.pages << page
		end
	end
end
 