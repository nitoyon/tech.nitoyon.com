# Force page url to be /:path/:basename:output_ext

Jekyll::Hooks.register :pages, :post_init do |page|
    page.data['permalink'] = '/:path/:basename:output_ext'
end
