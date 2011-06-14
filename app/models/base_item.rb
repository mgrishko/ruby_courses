# == Schema Information
#
# Table name: base_items
#
#  id                              :integer(4)      not null, primary key
#  gtin                            :string(255)
#  status                          :string(255)
#  created_at                      :datetime
#  updated_at                      :datetime
#  user_id                         :integer(4)
#  internal_item_id                :string(255)
#  despatch_unit                   :boolean(1)      default(FALSE)
#  invoice_unit                    :boolean(1)      default(FALSE)
#  order_unit                      :boolean(1)      default(FALSE)
#  consumer_unit                   :boolean(1)      default(FALSE)
#  manufacturer_name               :string(255)
#  manufacturer_gln                :string(13)
#  content_uom                     :string(3)
#  gross_weight                    :integer(4)
#  vat                             :integer(4)
#  gpc_code                        :integer(4)
#  country_of_origin_code          :string(2)
#  minimum_durability_from_arrival :integer(4)
#  packaging_type                  :string(3)
#  height                          :integer(4)
#  depth                           :integer(4)
#  width                           :integer(4)
#  content                         :decimal(6, 3)
#  brand                           :string(70)      default(""), not null
#  subbrand                        :string(70)
#  functional                      :string(35)      default(""), not null
#  item_description                :string(178)
#  item_id                         :integer(4)      not null
#  net_weight                      :integer(4)
#  state                           :string(255)     default("add")
#  mix                             :string(255)
#  private                         :boolean(1)      default(FALSE)
#

class BaseItem < ActiveRecord::Base
  include AASM

  has_one :event, :as => :content

  has_many :packaging_items, :dependent => :destroy
  has_many :receivers
  has_many :comments
  belongs_to :user
  belongs_to :item
  belongs_to :country_of_origin, :class_name => 'Country', :primary_key => :code, :foreign_key => :country_of_origin_code
  belongs_to :gpc, :primary_key => :code, :foreign_key => :gpc_code
  has_many :subscription_results
  has_many :base_item_subscription_results, :class_name => 'SubscriptionResult', :foreign_key => :base_item_id
  before_save :update_mix_field # data for search

  attr_writer :current_step

  scope :published, where(:status => 'published')
  scope :published_by, lambda { |user| user.base_items.published }

  # Последние опубликованные BI. в терминологии - актуальные версии.
  scope :last_published, lambda { Item.all.map { |item| item.base_items.published.last }.compact }
  scope :last_published_by, lambda { |user| user.items.map { |item| item.base_items.published.last }.compact }

  scope :private_last_published, lambda { where(:private => true).last_published }
  scope :public_last_published, lambda { where(:private => false).last_published }

  scope :private_last_published_by, lambda { |user| where(:private => true).last_published_by(user) }
  scope :public_last_published_by, lambda { |user| where(:private => false).last_published_by(user) }

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

  validate :check_gtin

  validates_presence_of :gtin, :if => :first_step?
  #validates_gtin :gtin, :if => :first_step?
  #validates_uniqueness_of :gtin, :scope => [:user_id, :item_id], :if => :first_step?

  validates_length_of :brand, :within => 1..70, :if => :first_step?
  validates_length_of :functional, :within => 1..35, :if => :first_step?

  #validates_gln :manufacturer_gln, :first_step?

  validates_length_of :manufacturer_name, :within => 1..35, :if => :first_step?

  validates_numericality_of :content, :greater_than => 0, :less_than_or_equal_to => 999999.999, :if => :first_step?

  validates_number_length_of :gross_weight, 7, :last_step?
  validates_number_length_of :net_weight, 7, :last_step?

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

  validates_presence_of :item_description, :if => :first_step?
  validates_presence_of :manufacturer_gln

  aasm_column :status

  aasm_initial_state :draft

  #aasm_state :draft
  #aasm_state :published, :enter => :cleanup_versions
  #aasm_state :pending, :enter => :send_request
  #aasm_state :rejected

  aasm_state :draft
  aasm_state :published, :enter => :make_subscription_result

  #aasm_event :draft do
  #  transitions :to => :draft, :from => [:published, :rejected, :draft]
  #end

  aasm_event :draft do
    transitions :to => :draft, :from => [:published, :draft]
  end

  #aasm_event :publish do
  #  transitions :to => :pending, :from => [:draft]
  #end

  aasm_event :publish do
    transitions :to => :published, :from => [:draft]
  end

  #aasm_event :accept do
  #  transitions :to => :published, :from => [:pending]
  #end

  #aasm_event :reject do
  #  transitions :to => :rejected, :from => [:pending]
  #end

  def send_request
    BaseItemMailer.deliver_approve_email(self)
  end

  #def cleanup_versions
  #  versions.delete_all
  #  packaging_items.update_all(:published => true)
  #end

  def check_gtin
    errors.add(:gtin, "Уже существует") if BaseItem.published.where("item_id != ? and user_id = ? and gtin = ? ", self.item_id, self.user_id, self.gtin).count > 0
    errors.add(:gtin, "Уже существует") if PackagingItem.joins(:base_item).where("packaging_items.user_id = ? and packaging_items.gtin = ? and base_items.status = 'published'", self.user_id, self.gtin).count > 0
  end

  def draft_all
    self.item.base_items.each do |bi|
      bi.draft!
    end
  end

  def make_subscription_result
    self.item.user.subscribers.each do |s|
      if s.specific
        next unless s.find_in_details(self.item.id)
      end
      # Comment this for turn-off grouping of base items changes in subscription result
      s.subscription_results.each do |sr|
        sr.delete if sr.base_item.gtin == self.gtin && sr.status == 'new'
      end
      # private condition
      if self.private
        s.subscription_results << SubscriptionResult.new(:base_item_id => self.id) if self.receivers.detect { |r| r.user_id == s.retailer_id }
      else
        s.subscription_results << SubscriptionResult.new(:base_item_id => self.id)
      end
    end
  end

  def has_difference_between_old?
    old_bi = self.item.last_bi.first
    return true unless old_bi
    # 1. bi_attributes
    # 2. receivers
    # 3. pi_attributes

    # 1
    necessary_attributes = old_bi.attributes.keys - ['id', 'status', 'created_at', 'updated_at', 'user_id', 'state', 'mix']
    necessary_attributes.each do |na|
      return true if old_bi[na] != self[na]
    end
    old_pi = old_bi.packaging_items.order("lft, created_at")
    pi = self.packaging_items.order("lft, created_at")

    # 2
    old_receivers = old_bi.receivers.sort { |b, a| a.user_id <=> b.user_id }
    new_receivers = self.receivers.sort { |b, a| a.user_id <=> b.user_id }
    return true if old_receivers.length != new_receivers.length
    if old_receivers.length > 0
      i = 0
      while i < old_receivers.length do
        return true if old_receivers[i][:user_id] != new_receivers[i][:user_id]
        i += 1
      end
    end
    # 3
    return true if old_pi.length != pi.length
    return false if old_pi.length == 0
    necessary_attributes = old_pi.first.attributes.keys - ['id', 'base_item_id', 'parent_id', 'created_at', 'updated_at', 'published']
    i = 0
    while i < old_pi.length do
      necessary_attributes.each do |na|
        return true if old_pi[i][na] != pi[i][na]
      end
      i += 1
    end
    false
  end

  #def published
  #  versions.scoped(:conditions => 'changes like "%pending%published%"')
  #end

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
    swallow_nil { gpc.name }
  end

  def country= name
    c = Country.first(:conditions => ['description = ?', name])
    if c
      self.country_of_origin_code = c.code
    else
      self.country_of_origin_code = nil
    end
  end

  def country
    country_of_origin.try(:description)
  end

  def vats
    [['0 %', 57], ['10 %', 59], ['18 %', 60]]
  end

  def content_uoms
    [
        ["квадратный метр", "MTK"],
        ["килограм", "KGM"],
        ["комплект", "SET"],
        ["кубометр", "MTQ"],
        ["лист", "ST"],
        ["литр", "LTR"],
        ["пара", "PR"],
        ["метр", "MTR"],
        ["штука", "PCE"],
        ["сантиметр", "CMT"],
        ["грамм", "GRM"],
        ["миллилитр", "MLT"],
        ["миллиметр", "MMT"],
    ]
  end

  def self.packaging_types
    [{:id => 1, :code => "AE", :name => "Aerosol"},
     {:id => 2, :code => "AM", :name => "Ampoule"},
     {:id => 3, :code => "AT", :name => "Atomizer"},
     {:id => 4, :code => "BG", :name => "Bag"},
     {:id => 5, :code => "NEW", :name => "Bag in Box"},
     {:id => 6, :code => "NEW", :name => "Banded package"},
     {:id => 7, :code => "BA", :name => "Barrel"},
     {:id => 8, :code => "BK", :name => "Basket"},
     {:id => 9, :code => "NEW", :name => "Blister pack"},
     {:id => 10, :code => "BO", :name => "Bottle"},
     {:id => 11, :code => "BX", :name => "Box"},
     {:id => 12, :code => "NEW", :name => "Brick"},
     {:id => 13, :code => "BJ", :name => "Bucket"},
     {:id => 14, :code => "CG", :name => "Cage"},
     {:id => 15, :code => "NEW", :name => "Can"},
     {:id => 16, :code => "NEW", :name => "Card"},
     {:id => 17, :code => "CT", :name => "Carton"},
     {:id => 18, :code => "CS", :name => "Case"},
     {:id => 19, :code => "CR", :name => "Crate"},
     {:id => 20, :code => "CU", :name => "Cup"},
     {:id => 21, :code => "CY", :name => "Cylinder"},
     {:id => 22, :code => "DN", :name => "Dispenser"},
     {:id => 23, :code => "EN", :name => "Envelope"},
     {:id => 24, :code => "NEW", :name => "Flexible Intermediate Bulk Container"},
     {:id => 25, :code => "NEW", :name => "Gable top"},
     {:id => 26, :code => "JR", :name => "Jar"},
     {:id => 27, :code => "JG", :name => "Jug"},
     {:id => 28, :code => "NEW", :name => "Multipack"},
     {:id => 29, :code => "NT", :name => "Net"},
     {:id => 30, :code => "NEW", :name => "Not packed"},
     {:id => 31, :code => "NEW", :name => "Packed, unspecified"},
     {:id => 32, :code => "PX", :name => "Pallet"},
     {:id => 33, :code => "PB", :name => "Pallet Box"},
     {:id => 34, :code => "NEW", :name => "Peel pack"},
     {:id => 35, :code => "PO", :name => "Pouch"},
     {:id => 36, :code => "RK", :name => "Rack"},
     {:id => 37, :code => "RL", :name => "Reel"},
     {:id => 38, :code => "SW", :name => "Shrinkwrapped"},
     {:id => 39, :code => "NEW", :name => "Sleeve"},
     {:id => 40, :code => "NEW", :name => "Stretchwrapped "},
     {:id => 41, :code => "PU", :name => "Tray"},
     {:id => 42, :code => "TB", :name => "Tub"},
     {:id => 43, :code => "TU", :name => "Tube"},
     {:id => 44, :code => "VP", :name => "Vacuum-packed"},
     {:id => 45, :code => "NEW", :name => "Wrapper"}]
  end

  def countries
    Country.find(:all, :select => 'code, description').map { |c| [c.description, c.code] }
  end

  # methods calculate_* for view (highlighting)
  def calculate_content
    content_uoms.detect { |u| content_uom == u[1] }[0]
  end

  def calculate_country
    country_of_origin.description
  end

  def calculate_gpc
    "#{gpc.code} : #{gpc.name}"
  end

  def calculate_vat
    vats.detect { |u| vat == u[1] }[0]
  end

  def calculate_dimmensions
    "<span class='d'>#{height}</span> <span class='t'>x</span> <span class='d'>#{width}</span> <span class='t'>x</span> <span class='d'>#{depth}</span> <span class='t'>(В x Д x Ш)</span>".html_safe
  end

  def calculate_weights
    "<span class='d'>#{gross_weight}</span> <span class='t'>г. брутто,</span> <span class='d'>#{net_weight}</span> <span class='t'>г. нетто</span>".html_safe
  end

  def has_forest?
    if self.packaging_items.count(:conditions => {:parent_id => nil}) > 1
      return true
    else
      return false
    end
  end

  def get_url(current_user)
    if current_user.retailer?
      "/base_items/#{self.id}?view=true"
    else
      "/base_items/#{self.id}"
    end

  end

  def get_title
    self.item_description.to_s
  end

  def get_description
    self.item_description.to_s
  end

  def update_mix_field
    necessary_fields = [:gtin, :internal_item_id, :manufacturer_name, :manufacturer_gln, :gpc_code, :country_of_origin_code, :brand, :subbrand, :functional, :item_description] #fields for search

    self.mix = ''
    necessary_fields.each do |nf|
      self.mix += self[nf].to_s + ' '
    end
    self.packaging_items.each do |pi|
      self.mix += pi.gtin.to_s + ' '
    end
  end


  # Get receivers list for exact user( )
  def self.get_receivers current_user #only for suppliers-
    published_ids = private_last_published_by(current_user).map { |bi| bi.id }
    Receiver.joins(:user).select('users.id, users.name, count(*) as q').where(:receivers => {:base_item_id => published_ids}).group("users.name")
  end

  # Может стоит преписать через паттерн method missing?
  def self.get_brands current_user, supplier=nil, all_suppliers=nil
    get_field "brand", current_user, supplier, all_suppliers
  end

  def self.get_manufacturers current_user, supplier=nil, all_suppliers=nil
    get_field "manufacturer_name", current_user, supplier, all_suppliers
  end

  def self.get_functionals current_user, supplier=nil, all_suppliers=nil
    get_field "functional", current_user, supplier, all_suppliers
  end

  # Выбирает поле, и проводит по нему подсчет с группировкой по этому полю
  def self.get_field field_name, current_user, supplier=nil, all_suppliers=nil
    ids = []
    if current_user.retailer? # case when /suppliers/ and /retailer_items/ controllers works
      if supplier or all_suppliers # /suppliers/:id or /suppliers/all
        public_ids = if supplier
                       public_last_published_by(supplier)
                     else
                       public_last_published
                     end.map { |bi| bi.id }.compact
        private_ids = if supplier
                        private_last_published_by(supplier)
                      else
                        private_last_published
                      end.map { |bi| bi.id }.compact
        this_receiver_ids = Receiver.where(:user_id => current_user.id).map { |r| r.base_item_id }
        this_receiver_private_ids = this_receiver_ids & private_ids
        ids = (public_ids | this_receiver_private_ids).compact.uniq
      else # /retailer_items/
        ids = self.retailer_items_ids(current_user)
      end
    else #/base_items/
      ids = last_published_by(current_user)
    end
    select("#{field_name}, count(*) as q").where(:id => ids).group(field_name)
  end

  # Forms a paginated collection of base_items with according filtration
  def self.get_base_items options={}
    conditions = build_conditions(options)
    base_items = []
    if options[:retailer] # for retailer items only
      retailer = User.where(:id => options[:user_id]).first
      if options[:tag]
        #NOTE: behaviour differs with previous code  possible error in as retailer http://localhost:3000/retailer_items
        clouded_base_items = retailer.clouds.where(:tag_id => options[:tag]).map{|cloud| cloud.item.base_items.to_ids}.flatten
        accepted_base_items = retailer.subscription_results.accepted.map { |sr| sr.base_item_id }
        ids = clouded_base_items & accepted_base_items
        base_items = BaseItem.where(:id => ids).order("created_at DESC")
      else
        ids = self.retailer_items_ids(retailer)
        if conditions
          base_items = BaseItem.where(conditions).where(:id => ids).order("created_at DESC")
        else
          base_items = BaseItem.where(:id => ids).order("created_at DESC")
        end
      end
    else # for base_items, common case: user is supplier
      options[:retailer_id] = options[:user_id] unless options[:retailer_id] #for controller => :suplier, action => :show
      supplier = User.where(:id => options[:user_id]).first
      retailer = User.where(:id => options[:retailer_id]).first
      if options[:tag]
        # Last tagged and published by retailer/supplier with exact tag
        base_items = retailer.clouds.where(:tag_id => options[:tag]).map{|cloud| cloud.item.last_bi.first}
        base_items = base_items.sort{|a,b| b.created_at <=> a.created_at}
      else
        if conditions
          source = options[:user_id] ? supplier.base_items : BaseItem
          base_items = source.where(conditions).order("created_at desc").last_published
        else
          if options[:receiver] #receivers only
            private_ids = private_last_published_by(supplier).to_ids
            receiver_ids = Receiver.where(:user_id => options[:receiver]).map { |r| r.base_item_id }
            receiver_private_ids = receiver_ids & private_ids
            base_items = where(:id => receiver_private_ids).order("created_at desc")
          else
            source = options[:user_id] ? supplier.base_items : BaseItem
            base_items = source.order("created_at desc").last_published
          end
        end
      end
    end
    base_items.paginate :page => options[:page], :per_page => 10
  end

  protected
  # Returns IDS of items accepted by retailer for /retailer_items/ page
  def self.retailer_items_ids(retailer)
     #FIXME
     # BI опубликованные, но не приватные
     public_ids = public_last_published.map { |bi| bi.id }
     # BI опубликованные, приватные
     private_ids = private_last_published.map { |bi| bi.id }
     # BI для текущего receiver
     this_receiver_ids = Receiver.where(:user_id => retailer.id).map { |r| r.base_item_id }
     # BI попавшие в подписку и помеченные как accepted
     accepted_ids = retailer.subscription_results.accepted.map { |sr| sr.base_item_id }
     # BI  - приватные данного пользователя и опубликованные неприватные и помеченные как accepted
     this_receiver_private_ids = this_receiver_ids & private_ids & accepted_ids
     ids = (public_ids & accepted_ids) | this_receiver_private_ids
  end

  # Build search conditions for #get_base_items method
  def self.build_conditions options={}
    conditions = ["brand = ?", options[:brand]] if options[:brand]
    conditions = ["manufacturer_name = ?", options[:manufacturer_name]] if options[:manufacturer_name]
    conditions = ["functional = ?", options[:functional]] if options[:functional]
    conditions = ["mix like ?", '%'+options[:search]+'%'] if options[:search]
    conditions
  end

end

