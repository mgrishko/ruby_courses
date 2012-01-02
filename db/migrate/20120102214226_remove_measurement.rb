class RemoveMeasurement < Mongoid::Migration
  def self.up
    Product.all.each do |product|
      package = product.packages.build

      depth = product.measurement(:depth).try(:value)
      width = product.measurement(:width).try(:value)
      height = product.measurement(:height).try(:value)
      gross = product.measurement(:gross_weight).try(:value)
      net = product.measurement(:net_weight).try(:value)
      content = product.measurement(:net_content).try(:value)
      unit = product.measurement(:net_content).try(:unit)

      if depth.present? && width.present? && height.present?
        package.dimensions.build depth: depth, width: width, height: height, unit: "MM"
      end

      if gross.present?
        net = net.present? && net.to_i < gross.to_i ? net : nil
        package.weights.build gross: gross, net: net, unit: "GR"
      end

      if content.present?
        package.contents.build value: content, unit: unit
      end

      package.save

      product.measurements.map(&:destroy)
    end

  end

  def self.down
  end
end