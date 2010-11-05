class AssociatedLinkRenderer < WillPaginate::LinkRenderer

protected

  def page_link(page, text, attributes = {})
    @template.link_to text, '#', attributes.merge(:ids => @options[:ids], :ajax => @template.current_path(:page => page))
  end

end
