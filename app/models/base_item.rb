# == Schema Information
#
# Table name: base_items
#
#  id                              :integer         not null, primary key
#  gtin                            :string(255)
#  status                          :string(255)
#  created_at                      :datetime
#  updated_at                      :datetime
#  user_id                         :integer
#  internal_item_id                :string(255)
#  despatch_unit                   :boolean         default(FALSE)
#  invoice_unit                    :boolean         default(FALSE)
#  order_unit                      :boolean         default(FALSE)
#  consumer_unit                   :boolean         default(FALSE)
#  manufacturer_name               :string(255)
#  manufacturer_gln                :string(13)
#  content_uom                     :string(3)
#  gross_weight                    :integer
#  vat                             :integer
#  gpc_code                        :integer
#  country_of_origin_code          :string(2)
#  minimum_durability_from_arrival :integer
#  packaging_type                  :string(3)
#  height                          :integer
#  depth                           :integer
#  width                           :integer
#  content                         :decimal(6, 3)
#  brand                           :string(70)      default(""), not null
#  subbrand                        :string(70)
#  functional                      :string(35)      default(""), not null
#  item_description                :string(178)
#  item_id                         :integer         default(0), not null
#  net_weight                      :integer
#  state                           :string(255)     default("add")
#  mix                             :text
#  private                         :boolean         default(FALSE)
#  variant                         :string(255)
#

# encoding = utf-8

class BaseItem < ActiveRecord::Base
  include AASM

  #validates_associated :gpc
  #validates_associated :country_of_origin


  validates :user_id, :presence => true
  validates :item_id, :presence => true
  #validates_uniqueness_of :gtin, :scope => [:user_id, :item_id], :if => :first_step?,
                          #:unless => Proc.new{|bi| bi.gtin == '00000000'}
  #validates_gtin :gtin, :if => :first_step?
  #validates :gtin, :gtin_format => true, :if => :first_step?
  validates :gtin, :presence => true,
                   :numericality => {:only_integer => true},
                   :gtin_format => {:if => :first_step? }
  validate :check_gtin # TODO
  validates :brand, :length => 1..70
  validates :subbrand, :length =>  { :maximum => 70 }, :allow_nil => true
  validates :functional, :length => 1..35
  #validates_gln :manufacturer_gln, :first_step?
  validates :manufacturer_name, :length => 1..35
  validates :content,
      :numericality => {:greater_than => 0,
                        :less_than_or_equal_to => 999999.999}
  validates_number_length_of :internal_item_id, 20
  validates_number_length_of :minimum_durability_from_arrival, 4
  validates :vat, :presence => true, :numericality => true
  validates :content_uom,
      :presence => true, :length => { :maximum => 3 }
  validates :gpc_code, :presence => true, :numericality => true
  validates :country_of_origin_code,
      :presence => true, :length => { :maximum => 2 }
  validates :item_description,
      :presence => true, :length => { :maximum => 178 }
  validates :manufacturer_gln,
      :presence => true, :length => { :maximum => 13 }

  # Only last step validations
  validates_number_length_of :gross_weight,
      7, :step => :last_step?
  validates_number_length_of :net_weight,
      7, :allow_nil=> true, :step => :last_step?
  validates_number_length_of :height, 5, :step => :last_step?
  validates_number_length_of :depth, 5, :step => :last_step?
  validates_number_length_of :width, 5, :step => :last_step?
  validates :packaging_type,
      :presence => true, :length => { :maximum => 3 },
      :if => :last_step?

  before_save :update_mix_field # data for search

  attr_writer :current_step
  attr_accessor :packaging_name

  has_one :event, :as => :content
  has_many :packaging_items, :dependent => :destroy
  has_many :receivers
  has_many :dedicated_users,
      :through => :receivers, :source => :user
  has_many :comments
  has_many :images
  belongs_to :user
  belongs_to :item
  belongs_to :country_of_origin, :class_name => 'Country', :primary_key => :code, :foreign_key => :country_of_origin_code
  belongs_to :gpc, :primary_key => :code, :foreign_key => :gpc_code
  has_many :subscription_results
  has_many :base_item_subscription_results, :class_name => 'SubscriptionResult', :foreign_key => :base_item_id

  scope :published, where(:status => 'published')

  scope :published_by, lambda { |user| user.base_items.published }

  # Последние опубликованные BI. в терминологии - актуальные версии.
  scope :last_published, lambda { where :id => BaseItem.select('max(id) as id').published.group('item_id') }

  scope :last_published_by, lambda { |user| where(:id =>  user.base_items.select('max(id) as id').published.group('item_id'))}

  scope :private_last_published, lambda { where(:private => true).last_published }

  scope :public_last_published, lambda { where(:private => false).last_published }

  scope :private_last_published_by, lambda { |user|
    where(:private => true).last_published_by(user)
  }
  scope :public_last_published_by, lambda { |user| where(:private => false).last_published_by(user) }

  scope :readably_by, lambda { |user|
    where(['(select count(*) from receivers where receivers.base_item_id = base_items.id) = 0 or (select count(*) from receivers where receivers.base_item_id = base_items.id and receivers.user_id = ?) > 0', user.id])
  }

  scope :dedicated_to, lambda { |user|
    where(['(select count(*) from receivers where receivers.base_item_id = base_items.id and receivers.user_id = ?) > 0', user])
  }

  scope :tagged_by_user, lambda {|user, tag_id|
    where [
      'item_id in (select clouds.item_id from clouds where clouds.user_id = :user_id and clouds.tag_id = :tag_id)',
      { :user_id => user, :tag_id => tag_id }
    ]
  }

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

  def send_request
    BaseItemMailer.deliver_approve_email(self)
  end

  #def cleanup_versions
  #  versions.delete_all
  #  packaging_items.update_all(:published => true)
  #end

  def check_gtin
    unless self.gtin == '00000000000000'
      errors.add(:gtin, I18n.t('item.already_exists')) if BaseItem.published.where("item_id != ? and user_id = ? and gtin = ? and status != ?", self.item_id, self.user_id, self.gtin, 'draft').count > 0
      errors.add(:gtin, I18n.t('item.already_exists')) if PackagingItem.joins(:base_item).where("packaging_items.user_id = ? and packaging_items.gtin = ? and base_items.status = 'published'", self.user_id, self.gtin).count > 0
    end
  end

  def draft_all
    self.item.base_items.each do |bi|
      bi.draft!
    end
  end

  # Action fired when the base_item is being published
  # Transfers the subscription_results to new version
  def make_subscription_result
    self.item.user.subscribers.each do |s|
      if s.specific
        next unless s.find_in_details(self.item.id)
      end
      # Comment this for turn-off grouping of base items changes in subscription result
      # Commented to meet 8 and 9 use-cases..
      #    s.subscription_results.each do |sr|
      #      sr.delete if sr.base_item.gtin == self.gtin && sr.status == 'new'
      #    end
      # private condition
      if self.private
        s.subscription_results << SubscriptionResult.new(:base_item_id => self.id) if self.receivers.detect { |r| r.user_id == s.retailer_id }
      else
        s.subscription_results << SubscriptionResult.new(:base_item_id => self.id)
      end
    end
  end

  def differs_with_old?
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

  def gpc_name= code
    self.gpc = Gpc.find_by_code(code)
  end

  def gpc_name
    if I18n.locale == :en
      gpc.try(:brick_en)
    else
      gpc.try(:brick_ru)
    end
  end

  def calculate_gpc
    if I18n.locale == :en
      "#{gpc.code} : #{gpc.brick_en}" rescue ''
    else
      "#{gpc.code} : #{gpc.brick_ru}" rescue ''
    end
  end

  def country= code
    c = Country.where(['code = ?', code]).first
    if c
      self.country_of_origin_code = c.code
    else
      self.country_of_origin_code = nil
    end
  end

  def country
    country_of_origin.try(:description)
  end

  #def calculate_country
    #country_of_origin.description
  #end

  #def countries
    #Country.find(:all, :select => 'code, description').map { |c| [c.description, c.code] }
  #end

  def vats
    REF_BOOKS['vats'][I18n.locale]
  end


  def content_uoms
    REF_BOOKS['content_uoms'][I18n.locale]
  end

  def self.packaging_types
    REF_BOOKS['packaging_types'][I18n.locale]
  end

  def manufacturer
    "#{self.manufacturer_gln} : #{self.manufacturer_name}"
  end

  # methods calculate_* for view (highlighting)
  def calculate_packaging_type
    pt = BaseItem.packaging_types.detect{|pt| pt[:code]== packaging_type}
    pt.present? ? pt[:name] : packaging_type
  end

  def calculate_content
    content_uoms.detect { |u| content_uom == u[1] }[0]
  end

  def calculate_vat
    vats.detect { |u| vat == u[1] }[0]
  end

#  def calculate_dimensions
#    "#{height}x#{width}x#{depth}"
#  end

#  def calculate_weights
#    "#{gross_weight},#{net_weight}"
#  end

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


  # Get receivers list for exact user(supplier)
  def self.get_receivers current_user #only for suppliers-
    published_ids = private_last_published_by(current_user).map { |bi| bi.id }
    Receiver.joins(:user).select('users.id, users.name, count(*) as q').where(:receivers => {:base_item_id => published_ids}).group("users.name, users.id")
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
                     end.to_ids.compact
        private_ids = if supplier
                        private_last_published_by(supplier)
                      else
                        private_last_published
                      end.to_ids.compact
        this_receiver_ids = Receiver.where(:user_id => current_user.id).map { |r| r.base_item_id }
        this_receiver_private_ids = this_receiver_ids & private_ids
        ids = (public_ids | this_receiver_private_ids).compact.uniq
      else # /retailer_items/
        ids = self.retailer_items_ids(current_user)
      end
    else #/base_items/
      ids = last_published_by(current_user)
    end
    select("#{field_name}, count(*) as q").where(:id => ids).group(field_name).order('q DESC').limit(10)
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
        base_items = where(:id => ids).order("created_at DESC")
      else
        ids = self.retailer_items_ids(retailer)
        if conditions
          base_items = where(conditions).where(:id => ids).order("created_at DESC")
        else
          base_items = where(:id => ids).order("created_at DESC")
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
        if conditions #if any filtering conditions are passed
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
    base_items.paginate :page => options[:page], :per_page => self.per_page
  end

  def image_url(suffix = nil)
    image = Image.find(:first, :conditions => {:base_item_id => self.id}, :order => "id desc")
    if image
      "/data/#{image.id}#{suffix.to_s}.jpg"
    else
      base_item = BaseItem.find(self.id)
      img_id = BaseItem.packaging_types.find{|pt| pt[:code] == base_item.packaging_type}[:id]
      "/images/pi_new/#{img_id}.jpg"
    end
  rescue NoMethodError
    "/images/item_image#{suffix.to_s}.jpg"
  end

  #hide packaging code from user and show name instead
  def packaging_name= value
    self.packaging_type = BaseItem.packaging_types.detect{|pt| pt[:name] == value}[:code] if value.present?
    @packaging_name = value
  end
  def packaging_name
    BaseItem.packaging_types.detect{|pt| pt[:code] == packaging_type}[:name] if packaging_type.present?
  end

  protected
  # Returns IDS of items accepted by retailer for /retailer_items/ page
  # FIXME: optimize request
  def self.retailer_items_ids(retailer)
    # BI опубликованные, но не приватные
    public_ids = where(:private => false).published.to_ids
    # BI опубликованные, приватные
    private_ids = where(:private => true).published.to_ids
    # BI для текущего receiver
    this_receiver_ids = Receiver.where(:user_id => retailer.id).map { |r| r.base_item_id }
    # BI попавшие в подписку и помеченные как accepted
    accepted_ids = retailer.subscription_results.accepted.map { |sr| sr.base_item_id }
    # BI  - приватные данного пользователя и опубликованные неприватные и помеченные как accepted
    this_receiver_private_ids = this_receiver_ids & private_ids & accepted_ids
    ids = (public_ids & accepted_ids) | this_receiver_private_ids
  end

  # Build search conditions for #get_base_items method
  # Allows only one condition per request.
  # Maybe we should merge them together.
  def self.build_conditions options={}
    conditions = ["brand = ?", options[:brand]] if options[:brand]
    conditions = ["manufacturer_name = ?", options[:manufacturer_name]] if options[:manufacturer_name]
    conditions = ["functional = ?", options[:functional]] if options[:functional]
    conditions = ["mix ilike ?", '%'+options[:search]+'%'] if options[:search]
    conditions
  end


end

