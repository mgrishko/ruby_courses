# encoding = utf-8
module PackagingItemsHelper
  def recursive_tree_output(set, options = {}, &block)
    prev_level = set.first.level_cache - 1 if set.present?
    result = ''
    result << "<ul #{ ("class='" +options[:class]+"'") if options[:class]} #{ ("id='"+options[:id]+"'") if options[:id]}>\n".html_safe  unless options[:without_root]

    set.each do |node|
      level = node.level_cache
      next if level - prev_level > 1
      result << "<ul>\n" if level > prev_level && prev_level != -1
      result << "</li>\n" if level == prev_level
      (prev_level-level).times { |i| result << "</li>\n</ul>\n" } if level < prev_level
      result << "</li>\n"  if level < prev_level
      if node.first? and node.last?
	      if node.root? and @base_item.has_forest?
      	  result << "<li id=\"#{dom_id node}\" class='pack'>\n"
        else
      	  result << "<li id=\"#{dom_id node}\" style='background: none;'>\n"
      	end
      else
        result << "<li id=\"#{dom_id node}\" class='pack'>\n"
      end

      result << capture(node, &block)

      prev_level = level
    end
    (prev_level - set.first.level_cache + 1).times { |i| result << "</li>\n</ul>\n" } if set.present?

    result.html_safe
  end

  # Depicts the quantity of packagingItem
  def calculate_quantity(pi)
    content_tag(:span, pi.number_of_next_lower_item, :class => 'd')+" "+
    content_tag(:span, 'уп. внутри', :class => 't')+" "+
    content_tag(:span, pi.number_of_bi_items, :class => 'd')+" "+
    content_tag(:span, 'ед.', :class => 't')
  end

  # Depicts the pallete  of packagingItem
  def calculate_pallet(pi)
    content_tag(:span, pi.quantity_of_layers_per_pallet, :class => 'd')+" "+
    content_tag(:span, 'слоев, по', :class => 't')+" "+
    content_tag(:span, pi.quantity_of_trade_items_per_pallet_layer, :class => 'd')+" "+
    content_tag(:span, 'уп. ', :class => 't')
    content_tag(:span, pi.stacking_factor, :class => 'd')+" "+
    content_tag(:span, 'стекинг', :class => 't')
  end
end

