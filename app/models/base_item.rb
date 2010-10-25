class BaseItem < ActiveRecord::Base
  include AASM

  versioned

  has_many :packaging_items
  belongs_to :user
  belongs_to :country_of_origin, :class_name => 'Country', :primary_key => :code, :foreign_key => :country_of_origin_code
  belongs_to :gpc, :primary_key => :code, :foreign_key => :gpc_code

  #validates_associated :gpc
  #validates_associated :country_of_origin

  validates_presence_of :gtin
  validates_gtin :gtin
  validates_uniqueness_of :gtin, :scope => :user_id

  validates_length_of :name, :maximum => 105
  validates_length_of :item_name_long_en, :maximum => 35
  validates_length_of :item_name_long_ru, :maximum => 35

  validates_gln :manufacturer_gln
  validates_length_of :manufacturer_name, :maximum => 35, :allow_nil => true

  validates_numericality_of :content, :greater_than => 0, :less_than_or_equal_to => 999999.999

  validates_number_length_of :gross_weight, 7

  validates_length_of :plu_description, :maximum => 12

  validates_number_length_of :height, 5
  validates_number_length_of :depth, 5
  validates_number_length_of :width, 5

  validates_number_length_of :internal_item_id, 20
  validates_number_length_of :minimum_durability_from_arrival, 4

  validates_presence_of :vat
  validates_presence_of :content_uom
  validates_presence_of :packaging_type
  validates_presence_of :gpc_code
  validates_presence_of :country_of_origin_code

  aasm_column :status

  aasm_initial_state :draft

  aasm_state :draft
  aasm_state :published, :enter => :cleanup_versions
  aasm_state :pending, :enter => :send_request
  aasm_state :rejected

  aasm_event :draft do
    transitions :to => :draft, :from => [:published, :rejected, :draft]
  end

  aasm_event :publish do
    transitions :to => :pending, :from => [:draft]
  end

  aasm_event :accept do
    transitions :to => :published, :from => [:pending]
  end

  aasm_event :reject do
    transitions :to => :rejected, :from => [:pending]
  end

  def send_request
    BaseItemMailer.deliver_approve_email(self)
  end

  def cleanup_versions
    versions.delete_all
    packaging_items.update_all(:published => true)
  end

  def published
    versions.scoped(:conditions => 'changes like "%pending%published%"')
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

  def gpc_name= (name)
    self.gpc = name.blank? ? nil : Gpc.find_by_name(name)
  end

  def gpc_name
    gpc.name if gpc
  end

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
    Country.find(:all, :select => 'code, description').map { |c| [c.description, c.code] }
  end

end
