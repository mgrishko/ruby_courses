# ToDo Remove duplications

class Package
  include Mongoid::Document
  
  TYPES = %w(AE AM AT BG BIB BPK BA BK BLP BO BX BRK BJ CG CN CRD CT 
    CS CR CU CY DN EN FIC GBT JR JG MTP NT NE PK PX PB PLP PO RK RL SW SLE STW 
    PU TB TU VP WRP)
  
  field :type, type: String
  
  attr_accessible :type
  
  embedded_in :product
  embeds_many :dimensions
  embeds_many :weights
  embeds_many :contents

  accepts_nested_attributes_for :dimensions
  attr_accessible :dimensions_attributes

  accepts_nested_attributes_for :weights
  attr_accessible :weights_attributes
  
  accepts_nested_attributes_for :contents
  attr_accessible :contents_attributes  

  before_validation :cleanup_dimensions
  before_validation :cleanup_weights
  before_validation :cleanup_contents
  
  validates :type, presence: true, inclusion: { in: TYPES }, length: { maximum: 3 }
  
  private

  # Cleanups all dimensions with blank values.
  def cleanup_dimensions
    self.dimensions.each do |m|
      m.destroy if m.width.blank? && m.depth.blank? && m.height.blank?
    end
  end

  # Cleanups all weights with blank values.
  def cleanup_weights
    self.weights.each do |m|
      m.destroy if m.gross.blank? && m.net.blank?
    end
  end
  
  # Cleanups all contents with blank values.
  def cleanup_contents
    self.contents.each do |m|
      m.destroy if m.value.blank?
    end
  end
end