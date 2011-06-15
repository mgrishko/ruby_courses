module BaseItemsHelper
  # if need highlighting returns highlight class
  def highlight attr, new_obj, old_obj=nil, show_title=true
    if old_obj && (old_obj.send(attr) != new_obj.send(attr))
      if show_title
        "class='highlight' title='#{old_obj.send(attr)}'"
      else
        "class='highlight'"
      end
    end
  end

  # Depicts the dimensions of item(baseItem and packagingItem)
  def calculate_dimensions item
    content_tag(:span, item.height, :class => 'd')+" "+
    content_tag(:span, 'x', :class => 't')+" "+
    content_tag(:span, item.width, :class => 'd')+" "+
    content_tag(:span, 'x', :class => 't')+" "+
    content_tag(:span, item.depth, :class => 'd')+" "+
    content_tag(:span, '(В x Д x Ш)', :class => 't')
  end
  # Depicts the weights of item(baseItem and packagingItem)
  def calculate_weights item
    content_tag(:span, item.gross_weight, :class => 'd')+" "+
    content_tag(:span, 'г. брутто,', :class => 't')+" "+
    content_tag(:span, item.net_weight, :class => 'd')+" "+
    content_tag(:span, 'г. нетто', :class => 't')
  end
end

