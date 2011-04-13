module BaseItemsHelper
  def highlight attr, new_obj, old_obj=nil, show_title=true
    if old_obj && (old_obj.send(attr) != new_obj.send(attr))
      if show_title
        "class='highlight' title='#{old_obj.send(attr)}'"
      else
        "class='highlight'"
      end
    end
  end

  def selected_wrapper content, condition=nil
    if condition  #logical true
      "<div class='selected'>#{content}<div class='fright'><a href='?' title='Remove this filter'>x</a></div></div>"
    else
      "<div>#{content}</div>"
    end
  end
end
