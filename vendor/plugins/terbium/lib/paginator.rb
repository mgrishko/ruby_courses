module Paginator

  module ViewHelpers
    @@pagination_options = {
      :class          => 'paginator',
      :previous_label => 'Previous',
      :next_label     => 'Next',
      :first_label    => 'first',
      :last_label     => 'last',
      :inner_window   => 4, # links around the current page
      :outer_window   => 1, # links around beginning and end
      :separator      => ' ', # single space is friendly to spiders and non-graphic browsers
      :param_name     => :page,
      :params         => nil,
      :renderer       => 'Paginator::LinkRenderer',
      :page_links     => true,
      :container      => true,
      :id             => true
    }
    mattr_reader :pagination_options

    def would_paginate(collection = nil, options = {})
      options = options.symbolize_keys.reverse_merge Paginator::ViewHelpers.pagination_options
      options = options.reverse_merge WillPaginate::ViewHelpers.pagination_options
      options[:class] = 'paginator'
      
      will_paginate(collection, options)
    end
  end

  class LinkRenderer < WillPaginate::ViewHelpers::LinkRenderer
    def to_html
      html = ''
      js = <<-CODE
        addEvent(window, 'load', function(){
          new Paginator('#{html_attributes[:id]}', #{current_page}, #{total_pages}, '#{@options[:url] || url_for('')}',
            {prev: '#{@options[:previous_label]}',
             next: '#{@options[:next_label]}',
             last: '#{@options[:last_label]}',
             first: '#{@options[:first_label]}'})
        })
      CODE
      @template.content_tag(:div, html, html_attributes) +
        @template.javascript_tag(js)
    end

    def html_attributes
      return @html_attributes if @html_attributes
      @html_attributes = @options.except *(Paginator::ViewHelpers.pagination_options.keys - [:class])

      if @options[:id] === true
        time = Time.now
        @html_attributes[:id] = "pagination_#{time.to_i}_#{time.usec}"
      end
      @html_attributes
    end
  end
end
