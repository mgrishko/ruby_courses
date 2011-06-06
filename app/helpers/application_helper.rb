# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def humanize_date something
    something.strftime("%d.%m.%y %H:%M")
  end
  
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
  
  def selected_wrapper content, condition=nil
    if condition  # logical true
      "<div class='selected'>#{content}<div class='fright'><a href='?' title='#{t 'filter.remove'}'>x</a></div></div>"
    else
      "<div>#{content}</div>"
    end
  end

  def html_pager(pc, pn=nil) #pager_collection, pager_name
    pn = 'page' unless pn
    p = params.clone
    p.delete('action')
    p.delete('controller')
    p.delete('source')
    p.delete('id')
    i1 = (pc.current_page-1)*pc.per_page+1 # interval 1
    i2 = i1 + pc.count - 1
    i1 = 0 if pc.count == 0
    pager = "#{i1} - #{i2} #{t 'pager.from'} #{pc.total_entries}"
    if pc.current_page > 1
      pager = " <a href='#{current_url(p.merge(pn => pc.current_page-1))}'>#{t 'pager.previous'}</a> "+pager
    end
    if pc.current_page > 2
      pager = " <a href='#{current_url(p.merge(pn => 1))}'>#{t 'pager.newest'}</a> "+pager
    end
    if pc.current_page < pc.total_pages
      pager = pager + " <a href='#{current_url(p.merge(pn => pc.current_page+1))}'>#{t 'pager.next'}</a> "
    end
    if (pc.current_page+1) < pc.total_pages
      pager = pager + " <a href='#{current_url(p.merge(pn => pc.total_pages))}'>#{t 'pager.oldest'}</a> "
    end
    pager
  end
end
