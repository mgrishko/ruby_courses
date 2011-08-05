# encoding = utf-8
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


  def selected_wrapper content, condition=nil
    if condition  # logical true
      "<li class='act'><div style='float:right'><a href='?' title='#{t 'filter.remove'}'>x</a></div>#{content}</li>".html_safe
    else
      "<li>#{content}</li>".html_safe
    end
  end

  def html_pager(pc, pn=nil) #pager_collection, pager_name
    if pc.total_pages > 1
     pn = 'page' unless pn
     p = params.clone
     p.delete('action')
     p.delete('controller')
     p.delete('source')
     p.delete('id')
     i1 = (pc.current_page-1)*pc.per_page+1 # interval 1
     i2 = i1 + pc.count - 1
     i1 = 0 if pc.count == 0
     pager = "<span>#{i1} - #{i2} #{t 'pager.from'} #{pc.total_entries}</span>"
#    if pc.current_page > 2
#      pager =pager+ " <a href='#{current_url(p.merge(pn => 1))}'>#{t 'pager.newest'}</a> "
#    end

     if pc.current_page > 1
       pager = pager + " <a class='prev' href='#{current_url(p.merge(pn => pc.current_page-1))}'></a> "
     else
       pager = pager + " <a class='prev-dis' href='javascript:void(0)' no-repeat 0 0;'></a> "
     end
     if pc.current_page < pc.total_pages
       pager = pager + " <a class='next' href='#{current_url(p.merge(pn => pc.current_page+1))}'></a> "
     else
       pager = pager + " <a class='next-dis' href='javascript:void(0)' no-repeat 0 0;'></a> "
     end

#    if (pc.current_page+1) < pc.total_pages
#      pager = pager + " <a href='#{current_url(p.merge(pn => pc.total_pages))}'>#{t 'pager.oldest'}</a> "
#    end

     pager.html_safe
    end
  end
end

