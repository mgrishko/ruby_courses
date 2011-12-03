class ApplicationDecorator < Draper::Base

  # Generates a show link if current ability allows to view object:
  #
  #   show_link @product, class: "button"
  #   # => <a href="/products/1">Show</a>
  #
  #   show_link @product, class: "button", name: :title
  #   # => <a href="/products/1">This is a product title</a>
  #
  #   show_link @product, class: "button", name: :title, fallback: true
      # returns a link name if ability does not allow to view object
  #   # => This is a product title
  #
  # @param [Instance] object to create a show link
  # @param [Hash] opts optional options for link_to helper.
  # @return [String, nil] link to show an object.
  def show_link(opts = {})
    opts = (opts || {}).with_indifferent_access

    # Returning default name if name option does not present or object does not respond to name_method
    name_method = opts.delete(:name)
    name = (model.try(name_method.to_sym) unless name_method.nil?) || I18n.t("show")

    fallback = opts.delete(:fallback)

    if h.can?(:read, model)
      h.link_to(name, model, opts)
    elsif fallback
      name
    end
  end

  # Generates an edit link if current ability allows to edit object:
  #
  #   edit_link @product, class: "button"
  #   # => <a href="/products/1/edit">Edit Product</a>
  #
  # @param [Instance] object to create an edit link
  # @param [Hash] opts optional options for link_to helper
  # @return [String, nil] link to edit an object.
  def edit_link(opts = {})
    h.link_to(I18n.t("edit", scope: scope(model)), [:edit, model], opts) if h.can?(:update, model)
  end

  # Generates a destroy link if current ability allows to destroy object:
  #
  #   destroy_link @product, class: "button"
  #   # => <a href="/products/1" rel="nofollow" data-method="delete" data-confirm="Are you sure?">Delete Product</a>
  #
  # @param [Instance] object to create a destroy link
  # @param [Hash] opts optional options for link_to helper
  # @return [String, nil] link to destroy an object.
  def destroy_link(opts = {})
    if h.can?(:destroy, model)
      opts = (opts || {}).with_indifferent_access
      opts.merge!(method: :delete, confirm: I18n.t("confirm"))
      h.link_to(I18n.t("destroy", scope: scope(model)), model, opts)
    end
  end

  # Generates a create link if current ability allows to create object:
  #
  #   create_link Product, class: "button"
  #   # => <a href="/products/new" class="button">New Product</a>
  #
  # @param [Class] object to create a new link
  # @param [Hash] opts optional options for link_to helper
  # @return [String, nil] link to new object page.
  #def create_link(opts = {})
    #if h.can?(:create, model)
      #model_class = (model.kind_of?(Class) ? model : model.class)
      #h.link_to(I18n.t("new", scope: scope(model)), [:new, model_class.name.underscore.to_sym], opts)
    #end
  #end

  private

  # Returns translation scope for object.
  #
  # @param [Class, Instance] object class or class instance
  # @return [String] scope of link translations
  def scope(model)
    "#{(model.kind_of?(Class) ? model : model.class).name.underscore.pluralize}.defaults"
  end
end
