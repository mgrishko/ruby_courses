class BaseItem < ActiveRecord::Base
  include AASM

  versioned

  has_many :packaging_items
  belongs_to :user
  belongs_to :country_of_origin, :class_name => 'Country', :primary_key => :code, :foreign_key => :country_of_origin_code
  belongs_to :gpc, :primary_key => :code, :foreign_key => :gpc_code

  attr_writer :current_step
  
  def current_step
    @current_step || steps.first
  end

  def steps
    %w[step1 step2]
  end
  
  def next_step
    self.current_step = steps[steps.index(current_step)+1]
  end
  def previous_step  
    self.current_step = steps[steps.index(current_step)-1]  
  end
  def first_step?
    current_step == steps.first
  end
  def last_step?
    current_step == steps.last
  end
  
  def all_valid?  
    steps.all? do |step|  
      self.current_step = step  
      valid?  
    end  
  end  
  #validates_associated :gpc
  #validates_associated :country_of_origin

  validates_presence_of :gtin, :if => :first_step?
  validates_gtin :gtin, :if => :first_step?
  validates_uniqueness_of :gtin, :scope => :user_id, :if => :first_step?

  validates_length_of :name, :maximum => 105, :if => :first_step?
  validates_length_of :item_name_long_en, :within => 1..35, :if => :first_step?
  validates_length_of :item_name_long_ru, :within => 1..35, :if => :first_step?
  validates_length_of :brand, :within => 1..70, :if => :first_step?
  validates_length_of :functional, :within => 1..35, :if => :first_step?
  
  validates_gln :manufacturer_gln, :first_step?

  validates_length_of :manufacturer_name, :maximum => 35, :allow_nil => true, :if => :first_step?

  validates_numericality_of :content, :greater_than => 0, :less_than_or_equal_to => 999999.999, :if => :first_step?

  validates_number_length_of :gross_weight, 7, :last_step?

  validates_length_of :plu_description, :maximum => 12, :if => :first_step?

  validates_number_length_of :height, 5, :last_step?
  validates_number_length_of :depth, 5, :last_step?
  validates_number_length_of :width, 5, :last_step?
  validates_number_length_of :internal_item_id, 20, :first_step?
  validates_number_length_of :minimum_durability_from_arrival, 4, :first_step?

  validates_presence_of :vat, :if => :first_step?
  validates_presence_of :content_uom, :if => :first_step?
  validates_presence_of :packaging_type, :if => :last_step?
  validates_presence_of :gpc_code, :if => :first_step?
  validates_presence_of :gpc_name, :if => :first_step?
  validates_presence_of :country_of_origin_code, :if => :first_step?


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
  
  def gpc_name= name
    self.gpc = Gpc.find_by_name(name)
  end

  def gpc_name
    swallow_nil{gpc.name}
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
      ["Банка"              , "CX" ],
      ["Блистер"            , "BME"],
      ["Блок"               , "BK" ],
      ["Бочка"              , "BA" ],
      ["Бутылка"            , "BO" ],
      ["Бутылка пластиковая", "KF" ],
      ["Коробка"            , "CT" ],
      ["Мешок"              , "BG" ],
      ["Пакет"              , "PA" ],
      ["Палета"             , "PX" ],
      ["Подложка"           , "PU" ],
      ["Рулон"              , "RO" ],
      ["Связка"             , "BE" ],
      ["Сетка"              , "UUE"],
      ["Стакан"             , "CU" ],
      ["Тюбик"              , "TU" ],
      ["Упак. пленочн."     , "UVQ"],
      ["Упаковка"           , "PK" ],
      ["Ящик дерев."        , "CR" ],
      ["Ящик обычный"       , "BX" ],
      ["Ящик для бутылок"   , "BC" ],
    ]
  end

  def countries
    Country.find(:all, :select => 'code, description').map { |c| [c.description, c.code] }
  end

end
