class AutocompleteInput < SimpleForm::Inputs::StringInput
  def input
    input_html_options[:type] ||= :text
    autocomplete_by = @options.delete(:autocomplete_by) || @attribute_name
    multiple = @options.delete(:multiple) || false
    
    opts = { 
      "data-autocomplete" => multiple ? :multi : :single,
      "data-autocomplete-url" => 
        "/#{@builder.object_name.pluralize}/autocomplete/#{autocomplete_by}.json"
    }
    
    @builder.text_field(attribute_name, input_html_options.merge(opts))
  end
end