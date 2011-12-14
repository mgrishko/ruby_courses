module AutoComplete
  module Action
    def autocomplete
      resource = self.instance_variable_get("@#{controller_name}")
      @values = resource.try("complete_#{params[:field]}".to_sym, params[:query])
      respond_to do |format|
        format.js
       end
    end
  end
end