require 'gtin_field_validations'

class Article < ActiveRecord::Base
  include AASM
  include FilterByUser

  has_many :packaging_items, :conditions => {:packaging_item_id => nil}
  belongs_to :user
  belongs_to :country_of_origin, :class_name => 'Country'

  #validates_is_gtin :gtin
  validates_presence_of :gtin
  validates_numericality_of :gtin, :less_than => 10 ** 14, :greater_than_or_equal_to => (10 ** (14 - 1))
  validates_uniqueness_of :gtin, :scope => :user_id

  validates_length_of :plu_description, :maximum => 12
  validates_length_of :item_name_long_en, :maximum => 30
  validates_length_of :manufacturer_name, :maximum => 35
  validates_length_of :item_name_long_ru, :maximum => 30

  validates_numericality_of :internal_item_id
  validates_numericality_of :manufacturer_gln, :less_than => (10 ** 13), :greater_than_or_equal_to => (10 ** (13 -1))
  validates_numericality_of :content, :greater_than_or_equal_to => 0.001, :less_than => 10 ** 9
  #validates_numericality_of :content_uom
  validates_numericality_of :gross_weight, :less_than => 10 ** 7, :greater_than => 0
  validates_numericality_of :vat
  validates_numericality_of :gpc
  #validates_numericality_of :country_of_origin
  validates_numericality_of :minimum_durability_from_arrival, :less_than => 10 ** 4, :greater_than => 0
  #validates_numericality_of :packaging_type
  validates_numericality_of :height, :less_than => 10 ** 5, :greater_than => 0
  validates_numericality_of :depth,  :less_than => 10 ** 5, :greater_than => 0
  validates_numericality_of :width,  :less_than => 10 ** 5, :greater_than => 0

  aasm_column :status

  aasm_initial_state :draft

  aasm_state :draft
  aasm_state :published
  aasm_state :pending, :enter => :send_request
  aasm_state :rejected

  aasm_event :publish_request do
    transitions :to => :pending, :from => [:draft, :rejected]
  end

  aasm_event :publish do
    transitions :to => :published, :from => [:pending]
  end

  aasm_event :reject do
    transitions :to => :rejected, :from => [:pending]
  end

  def send_request
    ArticleMailer.deliver_approve_email(self)
  end

  #def check_for_xml_response
    #fname = "#{RECORDS_IN_DIR}/#{id}.xml"
    #if File::exists?(fname) && File::readable?(fname)

    #end
  #end

  #def after_initalize
    #unless self.new_record?
      #check_for_xml_response
    #end
  #end

  def vats
    [['0 %', 57], ['10 %', 59], ['18 %', 60]]
  end

  def content_uoms
    [
      ["квадратный метр", "MTK"],
      ["килограм"       , "KGM"],
      ["комплект"       , "SET"],
      ["кубометр"       , "MTQ"],
      ["лист"           , "ST" ],
      ["литр"           , "LTR"],
      ["пара"           , "PR" ],
      ["метр"           , "MTR"],
      ["штука"          , "PCE"],
      ["сантиметр"      , "CMT"],
      ["грамм"          , "GRM"],
      ["миллилитр"      , "MLT"],
      ["миллиметр"      , "MMT"],
    ]
  end

  def packaging_types
    [
      ["банка"              , "CX" ],
      ["блистер"            , "BME"],
      ["блок"               , "BK" ],
      ["бочка"              , "BA" ],
      ["бутылка"            , "BO" ],
      ["бутылка пластиковая", "KF" ],
      ["коробка"            , "CT" ],
      ["мешок"              , "BG" ],
      ["пакет"              , "PA" ],
      ["палета"             , "PX" ],
      ["подложка"           , "PU" ],
      ["рулон"              , "RO" ],
      ["связка"             , "BE" ],
      ["сетка"              , "UUE"],
      ["стакан"             , "CU" ],
      ["тюбик"              , "TU" ],
      ["упак. пленочн."     , "UVQ"],
      ["упаковка"           , "PK" ],
      ["ящик дерев."        , "CR" ],
      ["ящик обычный"       , "BX" ],
      ["ящик для бутылок"   , "BC" ],
    ]
  end

  def countries
    Country.find(:all, :select => 'id, description').map { |c| [c.description, c.id] }
  end

end
