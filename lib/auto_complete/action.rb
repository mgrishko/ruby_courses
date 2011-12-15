module AutoComplete
  module Action
    def autocomplete
      resource = self.instance_variable_get("@#{controller_name}")
      @field = params[:field]
      @values = resource.send("complete_#{@field}".to_sym,
                              params[:query], limit: Settings.auto_complete.limit) rescue []
      respond_to do |format|
        format.js
       end
    end
  end
end