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
          content_tag('li', block.call(item) + tree_to_list(item.children, &block))
        end,
        {}
      )
    else
      debugger
    end
  end

end
