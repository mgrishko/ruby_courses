# encoding = utf-8
module PackagingItemsHelper

  def pi_tree(items, options = {}, &block)
    result = ''
    result << "<div class='branch'>"
    items.each_with_index do |item, count|
      options[:style] = count > 0 ? 'clear:left' : ''
      options[:class] = count > 0 ? 'secondChild' : ''
      options[:class] = "hasChild #{options[:class]}" if item.children.any?
      result << capture(item, options, &block)
      result << pi_tree(item.children, options, &block) if item.children.any?
    end
    result << '</div>'

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

  def pi_image_tag(item, options ={})
    begin
     id = BaseItem.packaging_types.find{|i|i[:code]==item.packaging_type}[:id]
   rescue
     id = 31
   end
     image_tag "pi_new/#{id}.jpg", options
  end
end

