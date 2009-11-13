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

  def link_to_new_pi(article, packaging_item, parent_id = nil)
    link_to_function('New', "PI.showForm('new', this, '" + url_for(hash_for_article_packaging_items_path.merge(:article_id => article, :id => nil, :parent_id => parent_id, :format => :json)) + "')")
  end
end
