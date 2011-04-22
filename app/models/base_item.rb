class BaseItem < ActiveRecord::Base
  include AASM
  
  has_many :packaging_items, :dependent => :destroy
  has_many :comments
  belongs_to :user
  belongs_to :item
  belongs_to :country_of_origin, :class_name => 'Country', :primary_key => :code, :foreign_key => :country_of_origin_code
  belongs_to :gpc, :primary_key => :code, :foreign_key => :gpc_code
  has_many   :subscription_result

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

  #validates_presence_of :gtin, :if => :first_step?
  #validates_gtin :gtin, :if => :first_step?
  #validates_uniqueness_of :gtin, :scope => :user_id, :if => :first_step?

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
  
  def draft_all
    self.item.base_items.each do |bi|
      bi.draft!
    end
  end
  
  def make_subscription_result
    self.item.user.subscribers.each do |s|
      # Comment this for turn-off grouping of base items changes in subscription result
      s.subscription_results.each do |sr|
        sr.delete if sr.base_item.gtin == self.gtin && sr.status == 'new'
      end
      # private condition
      if item.private
	s.subscription_results << SubscriptionResult.new(:base_item_id => self.id) if self.item.receivers.detect {|r| r.user_id == s.retailer_id}
      else
	s.subscription_results << SubscriptionResult.new(:base_item_id => self.id)
      end
    end
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
    swallow_nil{gpc.name}
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
    "<span class='d'>#{height}</span> <span class='t'>x</span> <span class='d'>#{width}</span> <span class='t'>x</span> <span class='d'>#{depth}</span> <span class='t'>(В x Д x Ш)</span>"
  end
  
  def calculate_weights
    "<span class='d'>#{gross_weight}</span> <span class='t'>г. брутто,</span> <span class='d'>#{net_weight}</span> <span class='t'>г. нетто</span>"
  end
  
  def has_forest?
    if self.packaging_items.count(:conditions => {:parent_id => nil}) > 1
      return true
    else
      return false
    end
  end
  
  def self.get_receivers current_user #only for suppliers
    find_by_sql <<-SQL
      SELECT u.id, u.name, count(*) as q from base_items a
      LEFT JOIN items i on i.id = a.item_id
      LEFT JOIN receivers r on r.item_id = i.id
      LEFT JOIN users u on u.id = r.user_id
      WHERE i.private = 1
      AND a.id = (
	SELECT b.id FROM base_items b 
	WHERE a.item_id = b.item_id 
	AND b.status = 'published' 
	AND b.user_id = #{current_user.id} 
	ORDER BY created_at DESC LIMIT 1
      ) GROUP by u.name
    SQL
  end

  def self.get_brands current_user, supplier=nil
    if current_user.retailer? # case when /suppliers/ and /retailer_items/ controllers works
      if supplier # /suppliers/:id
	find_by_sql <<-SQL
	  SELECT a.brand, count(*) AS q FROM base_items a
	  LEFT JOIN items i on i.id = a.item_id
	  WHERE a.id = (
	    SELECT b.id FROM base_items b 
            WHERE a.item_id = b.item_id 
            AND b.status = 'published' 
            AND b.user_id = #{supplier.id} 
            ORDER BY created_at DESC LIMIT 1
	  )
	  AND
	  IF ((i.private=1),
	    i.id = (select r.item_id from receivers r where r.item_id = i.id and r.user_id = #{current_user.id}),
	    1=1
	  )
	  GROUP by brand
	SQL
      else # /retailer_items/
	find_by_sql <<-SQL
	  SELECT a.brand, count(*) AS q FROM base_items a
	  LEFT JOIN items i on i.id = a.item_id
	  LEFT JOIN subscription_results sr ON a.id = sr.base_item_id
	  LEFT JOIN subscriptions s ON sr.subscription_id = s.id
	  WHERE a.id = (
	    SELECT b.base_item_id FROM subscription_results b
	    LEFT JOIN base_items c on c.id = b.base_item_id
	    LEFT JOIN items d on d.id = c.item_id    
	    where
	    b.status='accepted'
	    AND d.id = i.id
	    ORDER BY b.created_at DESC LIMIT 1
	  ) 
	    AND  s.retailer_id = #{current_user.id}
	    AND  sr.status = 'accepted'
	    AND 
	    IF ((i.private=1),
	      i.id = (select r.item_id from receivers r where r.item_id = i.id and r.user_id = #{current_user.id}),
	      1=1
	    )
	  GROUP by brand
	SQL
      end
    else #/base_items/
      find_by_sql <<-SQL
        SELECT a.brand, count(*) AS q FROM base_items a 
        WHERE a.id = (
	  SELECT b.id FROM base_items b 
          WHERE a.item_id = b.item_id 
          AND b.status = 'published' 
          AND b.user_id = #{current_user.id} 
	  ORDER BY created_at DESC LIMIT 1
	) GROUP by brand
      SQL
    end
  end
  
  def self.get_manufacturers current_user, supplier=nil
    if current_user.retailer?
      if supplier # /suppliers/:id
	find_by_sql <<-SQL
	  SELECT a.manufacturer_name, count(*) AS q FROM base_items a 
	  LEFT JOIN items i on i.id = a.item_id
	  WHERE a.id = (SELECT b.id FROM base_items b 
                        WHERE a.item_id = b.item_id 
                          AND b.status = 'published' 
                          AND b.user_id = #{supplier.id} 
                      ORDER BY created_at DESC LIMIT 1)
	  AND 
	    IF ((i.private=1),
	      i.id = (select r.item_id from receivers r where r.item_id = i.id and r.user_id = #{current_user.id}),
	      1=1
	    )
	  GROUP by manufacturer_name      
	SQL
      else # /retailer_items/
	find_by_sql <<-SQL
	  SELECT a.manufacturer_name, count(*) AS q FROM base_items a
	  LEFT JOIN items i on i.id = a.item_id
	  LEFT JOIN subscription_results sr ON a.id = sr.base_item_id
	  LEFT JOIN subscriptions s ON sr.subscription_id = s.id
	  WHERE a.id = (
	    SELECT b.base_item_id FROM subscription_results b
	    LEFT JOIN base_items c on c.id = b.base_item_id
	    LEFT JOIN items d on d.id = c.item_id    
	    where
	    b.status='accepted'
	    AND d.id = i.id
	    ORDER BY b.created_at DESC LIMIT 1
	  ) 
          AND  s.retailer_id = #{current_user.id}
	  AND  sr.status = 'accepted'
	  AND 
	    IF ((i.private=1),
	      i.id = (select r.item_id from receivers r where r.item_id = i.id and r.user_id = #{current_user.id}),
	      1=1
	    )
	  GROUP by manufacturer_name      
	SQL
      end
    else
      find_by_sql <<-SQL
        SELECT a.manufacturer_name, count(*) AS q FROM base_items a 
        WHERE a.id = (SELECT b.id FROM base_items b 
                        WHERE a.item_id = b.item_id 
                          AND b.status = 'published' 
                          AND b.user_id = #{current_user.id} 
                      ORDER BY created_at DESC LIMIT 1) GROUP by manufacturer_name      
      SQL
    end
  end
  
  def self.get_functionals current_user, supplier = nil
    if current_user.retailer?
      if supplier #/suppliers/:id
	find_by_sql <<-SQL
	    SELECT a.functional, count(*) AS q FROM base_items a
	    LEFT JOIN items i on i.id = a.item_id
	    WHERE a.id = (
	      SELECT b.id FROM base_items b 
	      WHERE a.item_id = b.item_id 
	      AND b.status = 'published' 
	      AND b.user_id = #{supplier.id} 
	      ORDER BY created_at DESC LIMIT 1
	    )
	    AND
	    IF ((i.private=1),
	      i.id = (select r.item_id from receivers r where r.item_id = i.id and r.user_id = #{current_user.id}),
	      1=1
	    )
	    GROUP by functional      
	SQL
      else # /retailer_items/
	find_by_sql <<-SQL
	    SELECT a.functional, count(*) AS q FROM base_items a
	    LEFT JOIN items i on i.id = a.item_id
	    LEFT JOIN subscription_results sr ON a.id = sr.base_item_id
	    LEFT JOIN subscriptions s ON sr.subscription_id = s.id
	    WHERE a.id = (
	      SELECT b.base_item_id FROM subscription_results b
	      LEFT JOIN base_items c on c.id = b.base_item_id
	      LEFT JOIN items d on d.id = c.item_id    
	      where
	      b.status='accepted'
	      AND d.id = i.id
	      ORDER BY b.created_at DESC LIMIT 1
	    ) 
	    AND  s.retailer_id = #{current_user.id}
	    AND  sr.status = 'accepted'
	    AND
	    IF ((i.private=1),
	      i.id = (select r.item_id from receivers r where r.item_id = i.id and r.user_id = #{current_user.id}),
	      1=1
	    )
	    GROUP by functional      
	SQL
      end
    else # /base_items/
      find_by_sql <<-SQL
        SELECT a.functional, count(*) AS q FROM base_items a 
        WHERE a.id = (
	  SELECT b.id FROM base_items b 
          WHERE a.item_id = b.item_id 
          AND b.status = 'published' 
	  AND b.user_id = #{current_user.id} 
          ORDER BY created_at DESC LIMIT 1
	) GROUP by functional      
       SQL
     end
   end
  
  
  def self.get_base_items options={}
    conditions = ["brand = ?", options[:brand]] if options[:brand]
    conditions = ["manufacturer_name = ?", options[:manufacturer_name]] if options[:manufacturer_name]
    conditions = ["functional = ?", options[:functional]] if options[:functional]
    if options[:retailer] # for retailer items only
      subquery = <<-SQL
	(SELECT b.base_item_id FROM subscription_results b
	LEFT JOIN base_items c on c.id = b.base_item_id
	LEFT JOIN items d on d.id = c.item_id    
	where
	b.status='accepted'
	AND d.id = i.id
	ORDER BY b.created_at DESC LIMIT 1)
      SQL
=begin
      subquery = <<-SQL
      (SELECT b.id FROM base_items b 
                  WHERE bi.item_id = b.item_id 
                    AND b.status='published' 
                    AND b.user_id = s.supplier_id
                  ORDER BY created_at DESC LIMIT 1)
      SQL
=end
      if options[:tag]
        query = <<-SQL
          SELECT bi.* FROM base_items AS bi
          LEFT JOIN items i ON bi.item_id = i.id
          LEFT JOIN clouds c on i.id = c.item_id 
          JOIN subscription_results sr ON bi.id = sr.base_item_id
          JOIN subscriptions s ON sr.subscription_id = s.id
          WHERE sr.status = 'accepted'
            AND c.user_id = ?
            AND c.tag_id = ?
            AND bi.id = #{subquery}
	    AND s.retailer_id = #{options[:user_id]}
	    AND
	      IF (i.private=1,
		i.id = (select r.item_id from receivers r where r.item_id = i.id and r.user_id = #{options[:user_id]}),
		1=1
	      )
          ORDER BY bi.created_at DESC
        SQL
        find_by_sql([query, options[:user_id], options[:tag]])
      else 
        if conditions
  	        query = <<-SQL
              SELECT bi.* FROM base_items AS bi
              LEFT JOIN items i ON bi.item_id = i.id
              JOIN subscription_results sr ON bi.id = sr.base_item_id
              JOIN subscriptions s ON sr.subscription_id = s.id
              WHERE sr.status = 'accepted'
                AND bi.id = #{subquery}
                AND #{conditions.first.to_s}
                AND s.retailer_id = #{options[:user_id]}
		AND
		  IF (i.private=1,
		    i.id = (select r.item_id from receivers r where r.item_id = i.id and r.user_id = #{options[:user_id]}),
		    1=1
		  )
              ORDER BY bi.created_at DESC
            SQL
            find_by_sql([query, conditions.last])
        else
	        query = <<-SQL
            SELECT bi.* FROM base_items AS bi
            LEFT JOIN items i ON bi.item_id = i.id
            JOIN subscription_results sr ON bi.id = sr.base_item_id
            JOIN subscriptions s ON sr.subscription_id = s.id
            WHERE sr.status = 'accepted'
              AND bi.id = #{subquery}
	      AND s.retailer_id = #{options[:user_id]}
	      AND 
		IF (i.private=1,
		  i.id = (select r.item_id from receivers r where r.item_id = i.id and r.user_id = #{options[:user_id]}),
		  1=1
		)
            ORDER BY bi.created_at DESC
          SQL
          find_by_sql([query, options[:user_id]])
        end
      end
    else # for base_items, common case: user is supplier
      options[:retailer_id] = options[:user_id] unless options[:retailer_id] #for controller => :suplier, action => :show
      if options[:tag]
        find_by_sql(["select a.* from base_items as a 
          left join items i on a.item_id = i.id 
          left join clouds c on i.id = c.item_id 
          where c.user_id = #{options[:retailer_id]} 
            and c.tag_id = ? 
            and a.id = (select b.id from base_items b 
                        where a.item_id = b.item_id 
                          and b.status='published' 
                          and b.user_id = #{options[:user_id]} 
                        order by created_at desc limit 1)
	   AND
	   IF ((i.private=1 AND i.user_id != #{options[:retailer_id]}),
		   i.id = (select r.item_id from receivers r where r.item_id = i.id and r.user_id = #{options[:retailer_id]}),
		   1=1
	      )
          order by a.created_at desc", options[:tag]])
      else 
        if conditions
  	      find_by_sql(["select a.* from base_items as a 
  	        left join items i on i.id = a.item_id
		where a.id = (select b.id from base_items b 
  	                      where a.item_id = b.item_id 
  	                        and b.status='published' 
  	                        and b.user_id = #{options[:user_id]} 
  	                        and "+conditions.first.to_s+" 
  	                      order by created_at desc limit 1)
		AND
		IF ((i.private=1 AND i.user_id != #{options[:retailer_id]}),
		  i.id = (select r.item_id from receivers r where r.item_id = i.id and r.user_id = #{options[:retailer_id]}),
		  1=1
		)
  	        order by a.created_at desc", conditions.last])
        else
	  if options[:receiver] #receivers only
	      find_by_sql("select a.* from base_items as a 
  	        left join items i on i.id = a.item_id
		where a.id = (select b.id from base_items b 
  	                      where a.item_id = b.item_id 
  	                        and b.status='published' 
  	                        and b.user_id = #{options[:user_id]} 
  	                      order by created_at desc limit 1)
		AND
		  i.id = (select r.item_id from receivers r where r.item_id = i.id and r.user_id = #{options[:receiver]})
  	        order by a.created_at desc")

	  else
  	      find_by_sql("select a.* from base_items as a
		left join items i on i.id = a.item_id
  	        where a.id = (select b.id from base_items b 
  	                      where a.item_id = b.item_id and b.status='published' 
  	                        and b.user_id = #{options[:user_id]} 
  	                      order by created_at desc limit 1) 
		AND
		IF ((i.private=1 AND i.user_id != #{options[:retailer_id]}),
		  i.id = (select r.item_id from receivers r where r.item_id = i.id and r.user_id = #{options[:retailer_id]}),
		  1=1
		)

  	        order by a.created_at desc")
	  end
        end
      end
    end 
  end
end
