class AutocompleteInput < SimpleForm::Inputs::StringInput
  def input
    input_html_options[:type] ||= :string
    add_maxlength!
    add_pattern!
    add_size!
    
    autocomplete_url = @options.delete(:url) ||
      "/#{@builder.object_name.pluralize}/autocomplete/#{@attribute_name}.json"
    
    multiple = @options.delete(:multiple) || false
    
    opts = { 
      "data-autocomplete" => multiple ? :multi : :single,
      "data-autocomplete-url" => autocomplete_url
    }
    
    @builder.text_field(attribute_name, input_html_options.merge(opts))
  end
end