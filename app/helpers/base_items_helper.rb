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
end
