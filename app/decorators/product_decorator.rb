class ProductDecorator < ApplicationDecorator
  decorates :product

  # Groups products by provided field
  #
  # @param [Array] array of products
  # @param [Hash] group options
  # @option [Symbol] by - field name by which products should be grouped
  # @return [Hash] grouped products where key is a field name and values is corresponding products
  def self.group(array, opts = { by: :functional_name })
    field = opts.delete(:by)
    groupings = array.map(&field)
    groupings.inject({}) do |acc, value|
      acc[value] = array.select { |p| p.send(field) == value }
      acc
    end
  end

  # Prepares options for visibility select tag.
  #
  # @return [Array] options for visibility select tag.
  def self.visibility_options
    Product::VISIBILITIES.collect { |v| [I18n.t("visibility.#{v}", scope: i18n_scope), v] }
  end

  # Prepares options for unit select tag.
  #
  # @param [Dimension|Weight|Content] measurement object.
  # @return [Array] options for visibility select tag.
  def self.unit_options(measurement)
    measurement.class::UNITS.collect { |v| [I18n.t("units.short.#{v}"), v] }
  end

  # Returns label for product measurement value.
  #
  # @param [Dimension|Weight|Content] measurement object.
  # @param [Symbol] attribute name
  # @param [Hash] opts label options
  # @option [Symbol] :show_unit show or not measurement unit, true by default
  # @return [String] measurement value label.
  def self.measure_value_label(measurement, attribute, opts = {})
    opts = opts.with_indifferent_access
    label = I18n.t("helpers.label.#{measurement.class.name.underscore}.#{attribute}")
    opts[:show_unit] || !opts.has_key?(:show_unit) ? "#{label} (#{I18n.t("units.short.#{measurement.unit}")})": label
  end

  # Returns html code for a link to a specific product version.
  # If product version is current version it returns only link name.
  #
  # @param [Product] current version of product
  # @param [Product] last version of product
  # @return [String] link or name
  def version_link(current_version, last_version)
    path = product.version == last_version.version ?
        h.product_path(last_version) : h.product_version_path(last_version, version: product.version)

    h.link_to_if(product.version != current_version.version,
                 I18n.t("version", scope: i18n_scope, number: product.version),
                 path)
  end

  # Returns product version date:.
  #   created_at for version 1
  #   updated_at for next versions
  #
  # @return [String] link or name
  def version_date
    h.content_tag(:span, "(#{product.updated_at.try(:strftime, '%d %b %Y, %H:%M')})")
  end

  # Returns visibility label wrapped with span and optional outer html wrapper.
  #
  # @param [Hash] opts the options to create label with.
  # @option opts [Symbol] :wrapper The outer html label wrapper.
  # @option opts [Boolean] :public To show or not label
  #   when visibility is public. Show by default.
  #
  # @return [String] html code or nil.
  def visibility_label(opts = {})
    opts = opts.with_indifferent_access
    return "" if opts[:public] == false && product.public?

    css_class = product.public? ? "success" : "important"
    label = h.content_tag :span, I18n.t("visibility.#{product.visibility}", scope: i18n_scope),
                          class: "label #{css_class}"

    opts[:wrapper] ? h.content_tag(opts[:wrapper].to_sym, label) : label
  end

  # Returns tags  labels each wrapped with span and optional outer html wrapper.
  #
  # @param [Hash] opts the options to create label with.
  # @option opts [Symbol] :wrapper The outer html label wrapper.
  #
  # @return [String] html code or nil.
  def tag_labels(opts = {})
    opts = opts.with_indifferent_access

    labels = product.tags.map { |t| h.content_tag :span, h.sanitize(t.name), class: "label" }
    (opts[:wrapper] ? labels.map { |l| h.content_tag opts[:wrapper].to_sym, l }.join : labels.join).html_safe
  end

  # Setups product nested objects for new and edit forms.
  #
  # @return [Product] instance
  def setup_nested
    self.product.tap do |a|
      # Building package
      package = a.packages.empty? ? a.packages.build : a.packages.first
      package.dimensions.find_or_initialize_by(unit: "MM") if package.dimensions.empty?
      package.weights.find_or_initialize_by(unit: "GR") if package.weights.empty?
      package.contents.build if package.contents.empty?

      # Building product codes
      build_product_codes(a)
    end
  end

  #  Returns link to trackable product or product name.
  #
  # @param [Hash] opts optional options for link_to helper.
  # @return [String] product show link or product name label
  def trackable_link(opts = {})
    show_link(opts)
  end

  # Returns dimension value with unit
  #
  # @param [Symbol] method name: :height, :width, :depth
  # @return [String] value with unit or nil
  def dimension(method)
    dimension = product.packages.first.try(:dimensions).try(:first)
    value = dimension.try(method)
    "#{value} #{I18n.t("units.short.#{dimension.unit}")}" unless value.blank?
  end

  # Returns weight value with unit
  #
  # @param [Symbol] method name: :gross, :net
  # @return [String] value with unit or nil
  def weight(method)
    weight = product.packages.first.try(:weights).try(:first)
    value = weight.try(method)
    "#{value} #{I18n.t("units.short.#{weight.unit}")}" unless value.blank?
  end

  # Returns content value with unit
  #
  # @param [Symbol] method name: :value
  # @return [String] value with unit or nil
  def content(method)
    content = product.packages.first.try(:contents).try(:first)
    value = content.try(method)
    "#{value} #{I18n.t("units.short.#{content.unit}")}" unless value.blank?
  end

  # @return [String] country of origin name
  def country_of_origin
    Carmen::country_name(product.country_of_origin) unless product.country_of_origin.blank?
  end

  # @return [String] title of the product for products index
  def title
    [[product.brand, product.sub_brand, product.variant].reject(&:blank?).map(&:strip).join(" "),
    self.content(:value)].reject(&:blank?).map(&:strip).join(", ")
  end

  # @return [String] product manufacturer and country of origin
  def item_label
    [product.manufacturer, self.country_of_origin].reject(&:blank?).map(&:strip).join(", ")
  end

  private

  # Builds product codes.
  #
  # @param [Product] instance
  def build_product_codes(product)
    codes = ProductCode::IDENTIFICATION_LIST
    code = codes.first

    product.product_codes.find_or_initialize_by(name: code)

    if product.product_codes.length > 1
      product.product_codes.sort! do |a, b|
        codes.find_index(a.name) <=> codes.find_index(b.name)
      end
    end
  end
end