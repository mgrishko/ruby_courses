module CancanHelper

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
  def show_link(object, opts = {})
    opts = (opts || {}).with_indifferent_access

    # Returning default name if name option does not present or object does not respond to name_method
    name_method = opts.delete(:name)
    name = (object.try(name_method.to_sym) unless name_method.nil?) || I18n.t("show")

    fallback = opts.delete(:fallback)

    if can?(:read, object)
      link_to(name, object, opts)
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
  def edit_link(object, opts = {})
    link_to(I18n.t("edit", scope: scope(object)), [:edit, object], opts) if can?(:update, object)
  end

  # Generates a destroy link if current ability allows to destroy object:
  #
  #   destroy_link @product, class: "button"
  #   # => <a href="/products/1" rel="nofollow" data-method="delete" data-confirm="Are you sure?">Delete Product</a>
  #
  # @param [Instance] object to create a destroy link
  # @param [Hash] opts optional options for link_to helper
  # @return [String, nil] link to destroy an object.
  def destroy_link(object, opts = {})
    if can?(:destroy, object)
      opts = (opts || {}).with_indifferent_access
      opts.merge!(method: :delete, confirm: I18n.t("confirm"))
      link_to(I18n.t("destroy", scope: scope(object)), object, opts)
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
  def create_link(object, opts = {})
    if can?(:create, object)
      object_class = (object.kind_of?(Class) ? object : object.class)
      link_to(I18n.t("new", scope: scope(object)), [:new, object_class.name.underscore.to_sym], opts)
    end
  end

  private

  # Returns translation scope for object.
  #
  # @param [Class, Instance] object class or class instance
  # @return [String] scope of link translations
  def scope(object)
    "#{(object.kind_of?(Class) ? object : object.class).name.underscore.pluralize}.defaults"
  end
end