class Cloud < ActiveRecord::Base
  belongs_to :tag
  belongs_to :item
  belongs_to :user
  validates_presence_of :tag_id

  def self.get_clouds retailer, supplier=nil
    if supplier
      #/suppliers/1
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
	GROUP BY name
      SQL
    else
      #retailer_items
      find_by_sql <<-SQL
	SELECT c.tag_id, t.name, count(*) as q FROM base_items as bi
	LEFT JOIN items i ON bi.item_id = i.id
	LEFT JOIN clouds c ON c.item_id = i.id
	LEFT JOIN tags t ON c.tag_id = t.id
	JOIN subscription_results sr ON bi.id = sr.base_item_id
	JOIN subscriptions s ON sr.subscription_id = s.id
      
	WHERE bi.id = (
	  SELECT b.id FROM base_items b 
	  WHERE bi.item_id = b.item_id 
	  AND b.status ='published'
	  ORDER BY created_at DESC LIMIT 1
	)
	AND c.user_id = #{retailer.id}
	AND  sr.status = 'accepted'
	GROUP BY name
      SQL
    end
  end
end
