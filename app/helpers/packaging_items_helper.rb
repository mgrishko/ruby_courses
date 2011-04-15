module PackagingItemsHelper
  def recursive_tree_output set, options = {}, &block
    prev_level = set.first.level_cache - 1 if set.present?
    concat("<ul#{" class=\"#{options[:class]}\"" if options[:class]}#{" id=\"#{options[:id]}\"" if options[:id]}>\n") unless options[:without_root]

    set.each do |node|
      level = node.level_cache
      next if level - prev_level > 1
      concat("<ul>\n") if level > prev_level && prev_level != -1
      concat("</li>\n") if level == prev_level
      (prev_level-level).times { |i| concat("</li>\n</ul>\n") } if level < prev_level
      concat("</li>\n") if level < prev_level
      if node.first? and node.last?
	if node.root? and @base_item.has_forest?
	  concat("<li id=\"#{dom_id node}\" class='pack'>\n")
	else
	  concat("<li id=\"#{dom_id node}\" style='background: none;'>\n")
	end
      else
	concat("<li id=\"#{dom_id node}\" class='pack'>\n")
      end

      concat capture(node, &block)

      prev_level = level
    end

    (prev_level - set.first.level_cache + 1).times { |i| concat("</li>\n</ul>\n") } if set.present?
  end
end
