class Cloud < ActiveRecord::Base
  belongs_to :tag
  belongs_to :item
  belongs_to :user
  validates_presence_of :tag_id

  def self.get_clouds retailer, supplier=nil
    if supplier
      #/suppliers/1 = ok
      find_by_sql <<-SQL
	SELECT c.tag_id, t.name, count(*) as q FROM base_items as bi
	LEFT JOIN items i ON bi.item_id = i.id
	LEFT JOIN clouds c ON c.item_id = i.id
	LEFT JOIN tags t ON c.tag_id = t.id
	WHERE bi.id = (
	  SELECT b.id FROM base_items b 
	  WHERE bi.item_id = b.item_id 
	  AND b.status ='published'
	  ORDER BY created_at DESC LIMIT 1
	)
	AND c.user_id = #{retailer.id}
	AND i.user_id = #{supplier.id}
	AND
	IF ((i.private=1),
	  i.id = (select r.item_id from receivers r where r.item_id = i.id and r.user_id = #{retailer.id}),
	  1=1
	)
	GROUP BY name
      SQL
    else
      #retailer_items = ok
      find_by_sql <<-SQL
	SELECT c.tag_id, t.name, count(*) as q FROM base_items as bi
	LEFT JOIN items i ON bi.item_id = i.id
	LEFT JOIN clouds c ON c.item_id = i.id
	LEFT JOIN tags t ON c.tag_id = t.id
	JOIN subscription_results sr ON bi.id = sr.base_item_id
	JOIN subscriptions s ON sr.subscription_id = s.id
      
	WHERE bi.id = (
	  SELECT b.base_item_id FROM subscription_results b
	  LEFT JOIN base_items c on c.id = b.base_item_id
	  LEFT JOIN items d on d.id = c.item_id    
	  where
	  b.status='accepted'
	  AND d.id = i.id
	  ORDER BY b.created_at DESC LIMIT 1
	)
	AND c.user_id = #{retailer.id}
	AND sr.status = 'accepted'
	AND s.retailer_id = #{retailer.id}
	AND
	IF ((i.private=1),
	  i.id = (select r.item_id from receivers r where r.item_id = i.id and r.user_id = #{retailer.id}),
	  1=1
	)
	GROUP BY name
      SQL
    end
  end
end

# == Schema Information
#
# Table name: clouds
#
#  id         :integer(4)      not null, primary key
#  tag_id     :integer(4)      not null
#  item_id    :integer(4)      not null
#  user_id    :integer(4)      not null
#  created_at :datetime
#  updated_at :datetime
#

