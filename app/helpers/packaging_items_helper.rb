# encoding = utf-8
module PackagingItemsHelper

  def pi_tree(items, options = {}, &block)
    result = ''
    items.reverse.each_with_index do |item, count|
      options[:style] = count > 0 ? 'clear:left' : ''
      options[:class] = count > 0 ? 'secondChild' : ''
      options[:class] = "hasChild #{options[:class]}" if item.children.any?
      result << capture(item, options, &block)
      result << pi_tree(item.children, options, &block) if item.children.any?
    end
    content_tag(:div, result.html_safe, :class=>'branch')
  end

  #TODO russian language pluralization. for calculate_quantity_of_bi and calculate_quantity_of_parent
  # Depicts the quantity of packagingItem
  def calculate_quantity_of_bi(pi)
    content_tag(:span, pluralize(pi.number_of_bi_items, pi.base_item.packaging_name.downcase), :id => "number_of_bi_items")+" "+
    #content_tag(:span, t('pi.in'))+" "+
    content_tag(:span, t('pi.total'))
    #content_tag(:span, pi.packaging_name.downcase)
  end

  def calculate_quantity_of_parent(pi)
    parent = pi.parent ? pi.parent : pi.base_item
    content_tag(:span, pluralize(pi.number_of_next_lower_item, parent.packaging_name.downcase))+" "+
    content_tag(:span, t('pi.in'))+" "+
    content_tag(:span, pi.packaging_name.downcase)
  end

  def parent_packaging_name(pi)
    parent = pi.parent ? pi.parent : pi.base_item
    parent.packaging_name
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


  def convert_mm_to_m item, field

    #FIXME: не самое лучшее решение, но не знаю как сделать удобнее.
    #Может индикатор переключения измерений стоит держать в модели, чтобы не пересчитывать постоянно
    switch = false
    %w{height width depth}.each{|f| switch = item.send(f) and break if item.send(f) and item.send(f)>999}

    value = item.send(field)
    if value > 999 or switch
      "#{value.to_f/1000} #{t('uom.m')}"
    else
      "#{value} #{t('uom.mm')}"
    end

  end

  def convert_grm_to_kg item, field
    value = item.send(field)
    return "- #{t('uom.grm')}" unless value.present?
    #FIXME: не самое лучшее решение, но не знаю как сделать удобнее.
    #Может индикатор переключения измерений стоит держать в модели, чтобы не пересчитывать постоянно
    switch = false
    %w{net_weight gross_weight}.each{|f| switch = item.send(f) and break if item.send(f) and item.send(f)>999}


    if value > 999 or switch
      "#{(value.to_f/1000).round(2)} #{t('uom.kg')}"
    else
      "#{value} #{t('uom.grm')}"
    end

  end
end

