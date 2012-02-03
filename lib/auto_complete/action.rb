module AutoComplete
  module Action

    # This is a autocomplete controller action.
    # Model should be set to autocomplete fields (see Mongoid::Searh for details)
    #
    # Example:
    #   In controller:
    #     class ProductsController < MainController
    #       include AutoComplete::Action
    #
    #   In routes.rb:
    #     get 'autocomplete/:field' => "products#autocomplete", as: :autocomplete, on: :collection
    #
    #   In autocomplete.js.coffe template:
    #     <% if @values.any? %>
    #       "<%= @values.join(", ") %>"
    #     <% end %>
    #
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