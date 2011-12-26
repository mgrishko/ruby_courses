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
    unit = measurement.name == "net_content" ? "" : " (#{I18n.t("units.short.#{measurement.unit}")})"
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

  #  Returns link to trackable product or product name.
  #
  # @param [Hash] opts optional options for link_to helper.
  # @return [String] product show link or product name label
  def trackable_link(opts = {})
    show_link(opts)
  end

  private

  # Builds product measurements.
  #
  # @param [Product] instance
  def build_measurements(product)
    measures = Measurement::MEASURES
    measures.each do |name|
      if product.measurements.where(name: name).first.nil?
        unit = name == "net_content" ? nil : Measurement::UNITS_BY_MEASURES[name.to_sym].first

        product.measurements.new(name: name, unit: unit)
      end
    end

    product.measurements.sort! do |a, b|
      measures.find_index(a.name) <=> measures.find_index(b.name)
    end
  end

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