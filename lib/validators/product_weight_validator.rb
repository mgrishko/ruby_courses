class ProductWeightValidator < ActiveModel::Validator
  attr_reader :record

  def validate(record)
    @record = record

    if gross_weight_present? && net_weight > gross_weight
      message = I18n.t("errors.messages.invalid_net_weight")
      record.errors[:measurements] << message
      measurement(:net).errors[:value] << message
    end
  end

  private

  def gross_weight
    weight(:gross)
  end

  def net_weight
    weight(:net)
  end

  def weight(name)
    measurement(name).try(:value).try(:to_i) || 0
  end

  def gross_weight_present?
    measurement(:gross).try(:value).try(:present?)
  end

  def measurement(name)
    record.measurements.where(name: "#{name}_weight").first
  end
end
