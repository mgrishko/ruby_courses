$("#pager").replaceWith "<%= escape_javascript(render "products") %>"

GoodsMaster.products.initPager()