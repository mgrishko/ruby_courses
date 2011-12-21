class ProductDecorator < ApplicationDecorator
  decorates :product

  # Prepares options for visibility select tag.
  #
  # @return [Array] options for visibility select tag.
  def self.visibility_options
    Product::VISIBILITIES.collect { |v| [I18n.t("visibility.#{v}", scope: i18n_scope), v] }
  end

  # Prepares options for unit select tag.
  #
  # @param [String] name of measure
  # @return [Array] options for visibility select tag.
  def self.unit_options(name)
    Measurement::UNITS_BY_MEASURES[name.to_sym].collect { |v| [I18n.t("units.short.#{v}"), v] }
  end

  # Returns label for product measurement value.
  #
  # @param [Measurement] measurement instance
  # @return [String] measurement value label.
  def self.measure_value_label(measurement)
    measure = I18n.t("measures.#{measurement.name}")
    unit = measurement.unit.nil? ? "" : " (#{I18n.t("units.short.#{measurement.unit}")})"
    "#{measure}#{unit}"
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
      # Building measurements
      build_measurements(a)

      # Building product codes
      build_product_codes(a)
    end
  end

  private

  # Builds product measurements.
  #
  # @param [Product] instance
  def build_measurements(product)
    Measurement::MEASURES.each do |name|
      unit = name == "net_content" ? nil : Measurement::UNITS_BY_MEASURES[name.to_sym].first

      product.measurements.find_or_initialize_by(name: name, unit: unit)
    end
  end

  # Builds product codes.
  #
  # @param [Product] instance
  def build_product_codes(product)
    code = ProductCode::IDENTIFICATION_LIST.first

    product.product_codes.find_or_initialize_by(name: code)
  end
end