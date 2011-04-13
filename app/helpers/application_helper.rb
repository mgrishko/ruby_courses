# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def link_to_item_with_count(caption, item, count)
    if count > 0
      link_to(caption + (count ? " (#{count})" : ''), item)
    end
  end

  def dm
    debug methods
  end

  def tree_to_list(tree, &block)
    if tree.is_a?(Array)
      content_tag('ul',
        tree.map do |item|
          tree_to_list(item, &block)
        end,
        {}
      )
    else
      item = tree
      content_tag('li', block.call(item) + tree_to_list(item.children, &block))
    end
  end

  def link_to_new_pi(base_item, packaging_item, parent_id = nil)
    link_to_function('New', "PI.showForm('new', this, '" + url_for(hash_for_base_item_packaging_items_path.merge(:base_item_id => base_item, :id => nil, :parent_id => parent_id, :format => :json)) + "')")
  end
  
  def csrf_meta_tag
    if protect_against_forgery?
      out = %(<meta name="csrf-param" content="%s"/>\n)
      out << %(<meta name="csrf-token" content="%s"/>)
      out % [ Rack::Utils.escape_html(request_forgery_protection_token),
              Rack::Utils.escape_html(form_authenticity_token) ]
    end
  end
end
