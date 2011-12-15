module AutoComplete
  module Action
    def autocomplete
      resource = self.instance_variable_get("@#{controller_name}")
      @field = params[:field]
      @values = resource.send("complete_#{@field}".to_sym,
                              params[:query], limit: Settings.auto_complete.limit) rescue []
      @values = @values.collect{ |v| { id: v, name: v } }
      respond_with(@values)
    end
  end
end