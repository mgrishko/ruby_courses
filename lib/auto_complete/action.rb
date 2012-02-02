module AutoComplete
  module Action
    def autocomplete
      resource = self.instance_variable_get("@#{controller_name}")
      @field = params[:field].pluralize
      @values = resource.send("distinct_#{@field}".to_sym,
                              search: params[:query], limit: Settings.auto_complete.limit) rescue []

      @values.map! { |v| { "id" => v, "name" => v } }

      respond_with(@values)
    end
  end
end