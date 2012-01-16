class ApplicationDecorator < Draper::Base

  # Returns I18n translation scope for class object.
  #
  # @return [String] I18n translation scope
  def self.i18n_scope
    namespace = self.name.index("::") ? "#{self.name.split("::").first.underscore}." : ""
    "#{namespace}#{self.model_class.name.underscore.pluralize}.defaults"
  end

  # Generates a create link if current ability allows to create object:
  #
  #   ProductDecorator.create_link, class: "button"
  #   # => <a href="/products/new" class="button">New Product</a>
  #
  # @param [Hash] opts optional options for link_to helper
  # @return [String, nil] link to new object page.
  def self.create_link(opts = {})
    if h.can?(:create, self.model_class)
      h.link_to(I18n.t("new", scope: i18n_scope), [:new, self.model_class.name.underscore.to_sym], opts)
    end
  end

  # Generates a show link if current ability allows to view object:
  #
  #   show_link @product, class: "button"
  #   # => <a href="/products/1">Show</a>
  #
  #   show_link @product, class: "button", name: :title
  #   # => <a href="/products/1">This is a product title</a>
  #     returns a link name if ability does not allow to view object
  #   # => This is a product title
  #
  #   show_link @product, class: "button", name: :title, fallback: false
  #     nothing return if ability does not allow to view object
  #   # => nil
  #
  # @param [Hash] opts optional options for link_to helper.
  # @option [Symbol] fallback when true then show link name when user can not view object.
  # @option [Symbol] anchor adds anchor to generated link, accepts string.
  # @option [Symbol] content specifies content of link, accepts string.
  # @option [Symbol] name specifies method to be call on object to generate link name.
  #   Ignored if content specified.
  #
  # @return [String, nil] link to show an object.
  def show_link(opts = {})
    opts = (opts || {}).with_indifferent_access
    #Default options
    opts.merge!(fallback: opts[:fallback].nil? ? true : opts[:fallback])
    
    content = opts.delete(:content)
    anchor = opts.delete(:anchor)
    
    if content.blank?
      # Returning default name if name option does not present or object does not respond to name_method
      name_method = opts.delete(:name)
      content = (model.try(name_method.to_sym) unless name_method.nil?) || I18n.t("show")
    end

    fallback = opts.delete(:fallback)

    if h.can?(:read, model)
      path = h.send("#{model.class.name.downcase}_path", model.id, anchor: anchor)
      h.link_to(content, path, opts)
    elsif fallback
      content
    end
  end

  # Generates an edit link if current ability allows to edit object:
  #
  #   edit_link @product, class: "button"
  #   # => <a href="/products/1/edit">Edit Product</a>
  #
  # @param [Hash] opts optional options for link_to helper
  # @return [String, nil] link to edit an object.
  def edit_link(opts = {})
    h.link_to(I18n.t("edit", scope: i18n_scope), [:edit, model], opts) if h.can?(:update, model)
  end

  # Generates a destroy link if current ability allows to destroy object:
  #
  #   destroy_link @product, class: "button"
  #   # => <a href="/products/1" rel="nofollow" data-method="delete" data-confirm="Are you sure?">Delete Product</a>
  #
  #   destroy_link @comment, class: "button", confirm: false
  #   # => <a href="/products/1" rel="nofollow" data-method="delete">Delete Product</a>
  #
  #   destroy_link @comment, class: "button", confirm: false, through: [@account, @product]
  #   # => <a href="account/1/products/1/comments/1" rel="nofollow" data-method="delete">Delete Product</a>
  #
  # @param [Hash] opts optional options for link_to helper
  # @return [String, nil] link to destroy an object.
  def destroy_link(opts = {})
    if h.can?(:destroy, model)
      opts = (opts || {}).with_indifferent_access
      opts.merge!(method: :delete)
      opts.merge!(confirm: I18n.t("confirm")) if opts[:confirm] === true
      through = opts.delete(:through) || []
      segments = through.kind_of?(Array) ? through : [through]
      segments = segments << model
      h.link_to(I18n.t("destroy", scope: i18n_scope), segments, opts)
    end
  end

  private
  # Returns I18n translation scope for class instance object.
  #
  # @return [String] I18n translation scope
  def i18n_scope
    self.class.i18n_scope
  end

end
